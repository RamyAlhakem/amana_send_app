import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldShowInstallBanner', () {
    test('returns true for Safari on web when the app is not installed', () {
      expect(
        shouldShowInstallBanner(
          isWeb: true,
          isSafari: true,
          isAppInstalled: false,
        ),
        isTrue,
      );
    });

    test('returns false for Chrome on web', () {
      expect(
        shouldShowInstallBanner(
          isWeb: true,
          isSafari: false,
          isAppInstalled: false,
        ),
        isFalse,
      );
    });

    test('returns false when the app is already installed', () {
      expect(
        shouldShowInstallBanner(
          isWeb: true,
          isSafari: true,
          isAppInstalled: true,
        ),
        isFalse,
      );
    });
  });

  group('shouldUseEmbeddedVideoPlayer', () {
    test('returns true for Safari on web', () {
      expect(
        shouldUseEmbeddedVideoPlayer(
          isWeb: true,
          isSafari: true,
        ),
        isTrue,
      );
    });

    test('returns false for non-Safari web', () {
      expect(
        shouldUseEmbeddedVideoPlayer(
          isWeb: true,
          isSafari: false,
        ),
        isFalse,
      );
    });
  });

  group('isSafariBrowserUserAgent', () {
    test('returns true for a Safari browser user agent', () {
      final userAgent =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 '
          '(KHTML, like Gecko) Version/15.1 Safari/605.1.15';

      expect(isSafariBrowserUserAgent(userAgent), isTrue);
    });

    test('returns false for Chrome user agent', () {
      final userAgent =
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36';

      expect(isSafariBrowserUserAgent(userAgent), isFalse);
    });
  });
}
