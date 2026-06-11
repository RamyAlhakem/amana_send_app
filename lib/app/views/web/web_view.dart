import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/dialogs/loading.dart';
import '/app/widgets/dialogs/message.dart';
import '/app/widgets/dialogs/submit.dart';
import '/global/variables.dart';
import '/graphql/api/get_transfer.dart';
import '/router/app_route.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.url});

  final String url;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late AppLocalizations? _arb;
  late TransfersState _pr;

  final GlobalKey webViewKey = GlobalKey();

  late String pageUrl;

  double _progress = 0;
  @override
  void initState() {
    super.initState();
    pageUrl = widget.url;
    _pr = Provider.of<TransfersState>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SubmitDialog(
          () {
            context.pop();
            context.pop();
          },
          content: _arb!.areYouSureYouWantToCancelThisTransfer,
        ).show();
        return false;
      },
      child: Scaffold(
        appBar: AutoAppBar(
          onPressed: () => SubmitDialog(
            () {
              context.pop();
              context.pop();
            },
            content: _arb!.areYouSureYouWantToCancelThisTransfer,
          ).show(),
        ),
        body: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(pageUrl)),
              initialSettings: InAppWebViewSettings(
                mediaPlaybackRequiresUserGesture: false,
                useOnDownloadStart: true,
                useShouldOverrideUrlLoading: true,
                javaScriptEnabled: true,
                userAgent:
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0',
                cacheEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
                allowsInlineMediaPlayback: true,
                iframeAllowFullscreen: true,
              ),
              onProgressChanged: (InAppWebViewController ctrl, int progress) {
                if (mounted) setState(() => _progress = progress / 100);
              },
              onLoadStart: (InAppWebViewController controller, Uri? url) {
                // MessageDialog('$url').show(context);

                setState(() => pageUrl = '$url');

                if (pageUrl
                    .toString()
                    .toLowerCase()
                    .contains('amanaSend.com')) {
                  if (pageUrl.toString().toLowerCase().contains('success')) {
                    final String lastSegment = pageUrl.split('/').last;

                    // Remove any trailing slashes and parse the number
                    final int transferId =
                        int.tryParse(lastSegment.replaceAll('/', '')) ?? 0;

                    LoadingDialog().show();
                    GetTransfer(context, transferId).request().whenComplete(() {
                      LoadingDialog.dismiss();
                      if (!_pr.transfer.isEmpty()) {
                        context.pushReplacementNamed(
                          AppRoute.success,
                          pathParameters: <String, String>{
                            'transfer': jsonEncode(_pr.transfer)
                          },
                        );
                      }
                    });
                  } else {
                    context.pop(); // close webview page.
                    context.pop(); // close send hub page.
                    Global.pageCtrl.jumpToPage(1); // transfers.
                    MessageDialog(_arb!.oops).show();
                  }
                }
              },
              onPermissionRequest: (ctrl, request) async {
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },
            ),
            Visibility(
              visible: _progress < 1,
              child: SizedBox(
                height: 7,
                child: LinearProgressIndicator(
                  value: _progress,
                  color: MainColors.color1,
                  backgroundColor: MainColors.color2.withOpacity(0.6),
                ),
              ),
            ),
            Visibility(
              visible: _progress < 1,
              child: const Center(
                child: CircularProgressIndicator(color: MainColors.color3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
