import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/nav_bar/nav_bar.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import 'account/account.dart';
import 'handler/structure_handler.dart';
import 'home/home.dart';
import 'provider/calculator.dart';
import 'recipients/recipients.dart';
import 'settings/structure_kit.dart';
import 'transfers/transfers.dart';

class Structure extends StatefulWidget {
  const Structure({this.query = const <String, String>{}, super.key});

  final Map<String, String> query;

  @override
  State<Structure> createState() => _StructureState();
}

class _StructureState extends State<Structure> {
  late int _index;

  @override
  void initState() {
    super.initState();

    _index = int.parse(widget.query['i'] ?? '0');
    Global.pageCtrl = PageController(initialPage: _index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => StructureHandler.onWillPop(),
      child: GestureDetector(
        onTap: () => Helper.unFocusCursor(context),
        child: Scaffold(
          appBar: AutoAppBar(
            bGColor: Theme.of(context).cardColor,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            titleReplacement: StructureKit(pageIndex: _index).title(context),
            actions: StructureKit(pageIndex: _index).actions(context),
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: Global.pageCtrl,
            onPageChanged: (int page) => setState(() => _index = page),
            children: <Widget>[
              AnnotatedRegion<SystemUiOverlayStyle>(
                // Home page appBar status bar colors:
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: Global.brightnessLight(),
                  statusBarIconBrightness: Global.brightnessLight(),
                ),
                child: const Home(),
              ),
              const Transfers(),
              const Recipients(),
              const Account(),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Visibility(
            visible: !context.select((Calculator c) => c.isLoading),
            child: StructureKit(pageIndex: _index).floatingBottom(context),
          ),
          bottomNavigationBar: NavBar(i: _index),
        ),
      ),
    );
  }
}
