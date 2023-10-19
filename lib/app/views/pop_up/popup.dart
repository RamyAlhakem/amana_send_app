import '/app/widgets/dialogs/message.dart';
import '/models/metadata.dart';

class PopupService {
  static Future<void> show() async {
    if (AppMetadata.get.popupStatus) {
      await MessageDialog(AppMetadata.get.popupMessage).show();
    }
  }
}
