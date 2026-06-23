import 'package:amana_send/flavor.dart';
import 'package:amana_send/app.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.production;
  await initlize();
}
