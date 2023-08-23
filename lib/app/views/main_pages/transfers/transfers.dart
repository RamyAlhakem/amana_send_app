import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/widgets/shimmer/shimmer_load.dart';
import '/graphql/api/get_transfers.dart';
import 'widgets/recent.dart';

class Transfers extends StatefulWidget {
  const Transfers({super.key});

  @override
  State<Transfers> createState() => _TransfersState();
}

class _TransfersState extends State<Transfers> {
  @override
  void initState() {
    super.initState();
    GetTransfers(context).request();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransfersState>(
      builder: (_, state, child) {
        child = Visibility(
          visible: !state.isLoading,
          replacement: ListView(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              children: const [
                ShimmerLoad(height: 80, verticalCount: 4),
              ]),
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await GetTransfers(context).request();
                },
                edgeOffset: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                  itemCount: state.transfers.length,
                  itemBuilder: (BuildContext context, int i) {
                    return TransferRecent(state.transfers[i]);
                  },
                ),
              ),
            ],
          ),
        );
        return child;
      },
    );
  }
}
