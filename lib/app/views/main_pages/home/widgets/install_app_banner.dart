// lib/app/views/main_pages/home/widgets/install_app_banner.dart
//
// Strategy for web:
//   We DO NOT use HtmlElementView / platform views at all.
//   Those approaches are fundamentally broken on Flutter 3.32 (callback
//   signature changes, elements going through a detached DOM fragment,
//   iframes getting an empty browsing context, etc.)
//
//   Instead, when the dialog opens, we append a real <video> element
//   directly to `document.body` with fixed positioning and a high z-index.
//   That element is always in the live DOM, so the browser's autoplay
//   policy allows it (muted + autoplay).
//   When the dialog closes, we remove the element again.

import 'package:amana_send/app/extensions/dark_mode.dart';
import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

import '../../../../../helper/helper.dart';

// ============================================================================
// Web-only native <video> overlay helper.
// Bypasses Flutter's rendering pipeline entirely — appends a fixed-positioned
// <video> to document.body so the browser treats it as a regular HTML element.
// ============================================================================
class _NativeVideoOverlay {
  _NativeVideoOverlay._(this._video);

  final html.VideoElement _video;
  static const String _instanceId = 'amana_install_app_video';

  /// Create the <video> and append it to the page body.
  factory _NativeVideoOverlay.create(String videoSrc) {
    // Remove any previous orphan instance (e.g. after an abnormal close).
    _tryRemoveExisting();

    final video = html.VideoElement()
      ..id = _instanceId
      ..src = videoSrc
      ..muted = true
      ..autoplay = true
      ..loop = true
      ..setAttribute('playsinline', '')
      ..setAttribute('preload', 'auto')
      ..style.position = 'fixed'
      ..style.left = '0'
      ..style.top = '0'
      ..style.width = '1px'
      ..style.height = '1px'
      ..style.objectFit = 'fill'
      ..style.backgroundColor = '#000'
      ..style.zIndex = '1000000'
      ..style.borderRadius = '8px'
      ..style.pointerEvents = 'none'
      ..style.opacity = '0'; // hidden until positioned

    html.document.body!.append(video);

    Helper.log(
        'WebVideo: <video#${_instanceId}> appended to body, src=$videoSrc');

    // Try to play. Because the element is already in the live DOM and is
    // muted, the browser should allow this. If it rejects for any reason,
    // retry once after a short delay.
    void attemptPlay() {
      video.muted = true;
      video.play().catchError((e) {
        Helper.log('WebVideo: play() rejected: $e');
      });
    }

    // Attempt once now and again once the element reports it's ready.
    attemptPlay();
    video.onLoadedData.listen(
        (_) {
          attemptPlay();
        },
        onDone: null,
        onError: (e) {
          Helper.log('WebVideo: onLoadedData error: $e');
        });
    video.onCanPlay.listen((_) => attemptPlay());

    return _NativeVideoOverlay._(video);
  }

  /// Position this <video> so it covers [bounds]. The caller passes the
  /// preview widget's screen rect, which we compute from its GlobalKey.
  void position({required Rect bounds}) {
    _video.style.opacity = '1';
    _video.style.left = '${bounds.left}px';
    _video.style.top = '${bounds.top}px';
    _video.style.width = '${bounds.width}px';
    _video.style.height = '${bounds.height}px';
    Helper.log('WebVideo: positioned at bounds=$bounds');
  }

  void hide() {
    _video.style.opacity = '0';
    _video.style.pointerEvents = 'none';
    _video.pause();
  }

  void dispose() {
    _video.remove();
    Helper.log('WebVideo: <video#${_instanceId}> removed from body');
  }

  static void _tryRemoveExisting() {
    final existing = html.document.getElementById(_instanceId);
    if (existing != null && existing is html.VideoElement) {
      existing.remove();
    }
  }
}

// ============================================================================
// InstallAppBanner
// ============================================================================
class InstallAppBanner extends StatefulWidget {
  final AppLocalizations arb;
  final Calculator state;

  const InstallAppBanner({
    super.key,
    required this.arb,
    required this.state,
  });

  @override
  State<InstallAppBanner> createState() => _InstallAppBannerState();
}

class _InstallAppBannerState extends State<InstallAppBanner> {
  VideoPlayerController? _controller;
  _NativeVideoOverlay? _videoOverlay;

  /// Points at the Container that reserves space for the video preview so we
  /// can measure its screen coordinates and position the real <video> there.
  final GlobalKey _videoPreviewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _initMobileVideo();
  }

  Future<void> _initMobileVideo() async {
    final url = _buildVideoUrl();
    Helper.log('InstallAppBanner: loading $url');

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      await _controller!.setLooping(true);
      await _controller!.setVolume(0);
      await _controller!.play();
      if (mounted) setState(() {});
      Helper.log('InstallAppBanner: mobile video playing');
    } catch (e, stack) {
      Helper.log('InstallAppBanner: init error: $e\n$stack');
    }
  }

  String _buildVideoUrl() {
    if (kIsWeb) {
      return Uri.base
          .replace(path: '/videos/install_app.mp4')
          .toString()
          .replaceAll(RegExp(r'//videos'), '/videos');
    }
    return '/videos/install_app.mp4';
  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoOverlay?.dispose();
    _videoOverlay = null;
    super.dispose();
  }

  void _positionOverlayOverPreview() {
    if (!kIsWeb || _videoOverlay == null) return;
    final ctx = _videoPreviewKey.currentContext;
    if (ctx == null) {
      Helper.log('WebVideo: preview key has no context');
      return;
    }
    final box = ctx.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.hasSize) return;
    final offset = box.localToGlobal(Offset.zero);
    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      box.size.width,
      box.size.height,
    );
    _videoOverlay!.position(bounds: rect);
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowBanner = widget.state.showInstall &&
        shouldShowInstallBanner(
          isWeb: kIsWeb,
          isSafari: isSafariBrowserUserAgent(html.window.navigator.userAgent),
          isAppInstalled: false,
        );

    if (!shouldShowBanner) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
          color:
              context.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => widget.state.changeInstall(false),
            icon: const Icon(Icons.close),
          ),
          Text(
            widget.arb.installAppOnYourPhoneForACompleteExperience,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => _showInstallDialog(context),
            child: Text(widget.arb.installNow),
          ),
        ],
      ),
    );
  }

  void _showInstallDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width.clamp(260.0, 360.0);
    final videoWidth = cardWidth - 170;
    final dialogMaxHeight = size.height * 0.75;
    final videoHeight = dialogMaxHeight * 0.68;

    final isSafari = kIsWeb &&
        isSafariBrowserUserAgent(html.window.navigator.userAgent);

    // On web, spawn a native <video> overlay BEFORE the dialog paints.
    // Safari is excluded here to avoid the web overlay instability that can
    // lead to blank rendering while still allowing the banner to appear.
    if (kIsWeb && !isSafari) {
      _videoOverlay?.dispose();
      _videoOverlay = _NativeVideoOverlay.create('/videos/install_app.mp4');
      // After the first frame the preview Container has laid out — position.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _positionOverlayOverPreview();
      });
    } else {
      _videoOverlay?.hide();
      _videoOverlay?.dispose();
      _videoOverlay = null;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.arb
                      .followTheInstructionsAboveToUseTheSiteAsAnAppWithoutOpeningItFromTheBrowser,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  key: _videoPreviewKey,
                  width: videoWidth,
                  height: videoHeight,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // No child — the real <video> floats above this rect.
                ),
                const SizedBox(height: 20),
                // Text(
                //   widget.arb
                //       .followTheInstructionsAboveToUseTheSiteAsAnAppWithoutOpeningItFromTheBrowser,
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 18,
                //   ),
                // ),
                // const SizedBox(height: 20),
                SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(widget.arb.ok),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Dialog closed — remove the native <video>.
      _videoOverlay?.hide();
      _videoOverlay?.dispose();
      _videoOverlay = null;
    });
  }
}
