import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/widgets/fade_switcher.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/refresh_button.dart';
import '/app/widgets/shimmer/shimmer_load.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/graphql/api/get_transfers.dart';
import '/helper/helper.dart';
import '/models/transfer.dart';
import '/router/app_route.dart';
import 'widgets/recent.dart';

class Transfers extends StatefulWidget {
  const Transfers({super.key});

  @override
  State<Transfers> createState() => _TransfersState();
}

class _TransfersState extends State<Transfers> with TickerProviderStateMixin {
  late AppLocalizations arb;
  late TransfersState provider;

  late AnimationController animationCtrl;
  late Animation<double> animationRotate;

  final ScrollController scrollCtrl1 = ScrollController();
  final ScrollController scrollCtrl2 = ScrollController();
  final ScrollController scrollCtrl3 = ScrollController();
  final ScrollController scrollCtrl4 = ScrollController();
  final ScrollController scrollCtrl5 = ScrollController();
  final ScrollController scrollCtrl6 = ScrollController();
  bool isPaging = false;
  int page = 1;

  void scrollListener(ScrollController ctrl, Status status) {
    ctrl.addListener(() {
      if (!isPaging && ctrl.position.pixels == ctrl.position.maxScrollExtent) {
        provider.incresePage();

        setState(() => isPaging = true);
        GetTransfers(page: provider.page, status: status)
            .request()
            .then((isNotEmpty) {
          setState(() => isPaging = false);

          if (isNotEmpty && provider.page > 1 && ctrl.hasClients) {
            ctrl.animateTo(
              ctrl.position.pixels + kTextTabBarHeight * 6,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInBack,
            );
          } else {
            Helper.snack('No more transfers', seconds: 2);
          }
          return isNotEmpty;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<TransfersState>(context, listen: false);
    animationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    );
    animationRotate =
        Tween<double>(begin: 0.0, end: 360.0).animate(animationCtrl);

    scrollListener(scrollCtrl1, Status.pending);
    scrollListener(scrollCtrl2, Status.newTransfer);
    scrollListener(scrollCtrl3, Status.processing);
    scrollListener(scrollCtrl4, Status.completed);
    scrollListener(scrollCtrl5, Status.canceled);
    scrollListener(scrollCtrl6, Status.dispute);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    super.didChangeDependencies();
    GetTransfers().request();
  }

  @override
  void dispose() {
    super.dispose();
    provider.isRequestLoading(true);
    provider.clearTransfers();
    scrollCtrl1.dispose();
    scrollCtrl2.dispose();
    scrollCtrl3.dispose();
    scrollCtrl4.dispose();
    scrollCtrl5.dispose();
    scrollCtrl6.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? labelStyle = Theme.of(context).textTheme.bodyLarge;
    return Consumer<TransfersState>(
      builder: (_, state, child) {
        child = DefaultTabController(
          length: TransferStatus.values.length,
          initialIndex: getStatusIndex(state.transfer.status),
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextX(
                    arb.transfersHistory,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // TextX(
                  //   arb.allTransfers,
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                ],
              ),
              actions: [
                GeneralWidgets.notificationBell(context),
                IconButton(
                  onPressed: () => context.push('/${AppRoute.support}'),
                  icon: const HeroIcon(HeroIcons.informationCircle),
                ),
                if (!state.isLoading)
                  RefreshButton(
                    animation: animationRotate,
                    callback: () async {
                      animationCtrl.forward();
                      state.resetPage();
                      await GetTransfers(
                              page: state.page, status: state.getStatusName())
                          .request();
                      animationCtrl.reset();
                    },
                  ),
              ],
              systemOverlayStyle: Global.systemOverlayStyle(context),
              backgroundColor: Theme.of(context).cardColor,
              bottom: TabBar(
                labelColor: MainColors.color2,
                unselectedLabelColor: MainColors.color2,
                labelStyle: labelStyle?.copyWith(fontWeight: FontWeight.w600),
                unselectedLabelStyle: labelStyle,
                isScrollable: true,
                dividerColor: Theme.of(context).dividerColor,
                indicatorPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                labelPadding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                tabs: [
                  TextX(arb.waitingPayment),
                  TextX(arb.awaitingProcess),
                  TextX(arb.processing),
                  TextX(arb.completed),
                  TextX(arb.canceled),
                  TextX(arb.dispute),
                ],
              ),
            ),
            body: Visibility(
              visible: !state.isLoading,
              replacement: ListView(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  children: const [
                    ShimmerLoad(height: 80, verticalCount: 4),
                  ]),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _TranfersTab(
                    transfers: state.pendingTransfers,
                    ctrl: scrollCtrl1,
                    status: Status.pending,
                    page: page,
                    isPaging: isPaging,
                  ),
                  _TranfersTab(
                    transfers: state.newTransfers,
                    ctrl: scrollCtrl2,
                    status: Status.newTransfer,
                    page: page,
                    isPaging: isPaging,
                  ),
                  _TranfersTab(
                    transfers: state.processingTransfers,
                    ctrl: scrollCtrl3,
                    status: Status.processing,
                    page: page,
                    isPaging: isPaging,
                  ),
                  _TranfersTab(
                    transfers: state.completedTransfers,
                    ctrl: scrollCtrl4,
                    status: Status.completed,
                    page: page,
                    isPaging: isPaging,
                  ),
                  _TranfersTab(
                    transfers: state.canceledTransfers,
                    ctrl: scrollCtrl5,
                    status: Status.canceled,
                    page: page,
                    isPaging: isPaging,
                  ),
                  _TranfersTab(
                    transfers: state.disputeTransfers,
                    ctrl: scrollCtrl6,
                    status: Status.dispute,
                    page: page,
                    isPaging: isPaging,
                  ),
                ],
              ),
            ),
          ),
        );
        return child;
      },
    );
  }

  // Widget _transfers(
  //     List<TransferModel> transfers, ScrollController ctrl, Status status) {
  //   return Stack(
  //     children: [
  //       RefreshIndicator(
  //         onRefresh: () async =>
  //             await GetTransfers(page: page, status: status).request(),
  //         child: Visibility(
  //           visible: transfers.isNotEmpty,
  //           replacement: FadeSwitcher(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Lottie.asset(
  //                     'assets/json/empty_${context.isDarkMode ? 'dark' : 'light'}.json'),
  //                 TextX(arb.noTransfersFoundYet),
  //               ],
  //             ),
  //           ),
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             controller: ctrl,
  //             itemCount: transfers.length,
  //             padding: const EdgeInsets.fromLTRB(0, 6, 0, 100),
  //             itemBuilder: (_, i) => TransferRecent(transfers[i]),
  //           ),
  //         ),
  //       ),
  //       if (isPaging)
  //         Align(
  //           alignment: FractionalOffset.bottomCenter,
  //           child: Lottie.asset(
  //             'assets/json/arrows_down.json',
  //             height: 150,
  //           ),
  //         ),
  //     ],
  //   );
  // }
}

enum Status { pending, newTransfer, processing, completed, canceled, dispute }

class _TranfersTab extends StatefulWidget {
  final List<TransferModel> transfers;
  final ScrollController ctrl;
  final Status status;
  final bool isPaging;
  final int page;
  const _TranfersTab({
    required this.transfers,
    required this.ctrl,
    required this.status,
    required this.isPaging,
    required this.page,
  });

  @override
  State<_TranfersTab> createState() => __TranfersTabState();
}

class __TranfersTabState extends State<_TranfersTab> {
  late TransfersState provider;
  @override
  void initState() {
    provider = Provider.of<TransfersState>(context, listen: false);
    provider.resetPage();
    provider.setIndex(widget.status);

    GetTransfers(page: provider.page, status: widget.status).request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arb = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Consumer<TransfersState>(
          builder: (context, state, child) => state.isLoading && state.page == 1
              ? const Center(
                  child: CircularProgressIndicator(
                    color: MainColors.color1,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    state.resetPage();
                    await GetTransfers(
                            page: provider.page, status: widget.status)
                        .request();
                  },
                  child: Visibility(
                    visible: widget.transfers.isNotEmpty,
                    replacement: FadeSwitcher(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                              'assets/json/empty_${context.isDarkMode ? 'dark' : 'light'}.json'),
                          TextX(arb.noTransfersFoundYet),
                        ],
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: widget.ctrl,
                      itemCount: widget.transfers.length,
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 100),
                      itemBuilder: (_, i) =>
                          TransferRecent(widget.transfers[i]),
                    ),
                  ),
                ),
        ),
        if (widget.isPaging)
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Lottie.asset(
              'assets/json/arrows_down.json',
              height: 150,
            ),
          ),
      ],
    );
  }
}
