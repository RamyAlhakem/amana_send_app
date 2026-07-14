import 'dart:async';
import 'dart:convert';

import 'package:amana_send/app/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/extensions/dark_mode.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/app/views/main_pages/recipients/recipient/widget/icon_detail.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/row.dart';
import '/app/widgets/shimmer/shimmer_load.dart';
import '/app/widgets/text/text_x.dart';
import '/graphql/api/get_recipients.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import '/router/app_route.dart';

class Recipients extends StatefulWidget {
  const Recipients({super.key});

  @override
  State<Recipients> createState() => _RecipientsState();
}

class _RecipientsState extends State<Recipients> {
  late AppLocalizations? _arb;
  late TextEditingController _searchController;
  Timer? _timer;

  @override
  void initState() {
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipient = Provider.of<RecipientsState>(context, listen: false);
      recipient.resetPage();
    });

    super.initState();
    GetRecipients.request();
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipientsState>(
      builder: (_, recipients, child) {
        child = Visibility(
          visible: !recipients.isLoading,
          replacement: ListView(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              children: const [
                ShimmerLoad(height: 80, verticalCount: 4),
              ]),
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await GetRecipients.request(page: recipients.page);
                },
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SearchWidget(
                      controller: _searchController,
                      hint: _arb!.search,
                      onChange: (text) {
                        recipients.resetPage();
                        // recipients.search(text);
                        if (_timer != null) _timer!.cancel();

                        _timer = Timer(const Duration(milliseconds: 500), () {
                          GetRecipients.request(search: text);
                        });
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                        itemCount: recipients.receipients.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                            width: MediaQuery.of(context).size.width,
                            child: GestureDetector(
                              onTap: () => context.pushNamed(
                                AppRoute.recipient,
                                pathParameters: <String, String>{
                                  'recipient':
                                      jsonEncode(recipients.receipients[i]),
                                },
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 10, 12, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: RecipientIconDetail(
                                          recipient: recipients.receipients[i]),
                                    ),
                                    Flexible(
                                      child: Button(
                                        () {
                                          if (AppMetadata.get.maintenanceMode) {
                                            return Helper.bannerWarning(
                                              '\n${AppMetadata.get.maintenanceMessage}\n',
                                            );
                                          }
                                          final calculator =
                                              Provider.of<Calculator>(
                                            context,
                                            listen: false,
                                          );
                                          calculator
                                              .clearProviderFieldTransfer();
                                          calculator.setReceiverCountry(
                                              recipients
                                                  .receipients[i].country);
                                          calculator.agentsVisibility(true);
                                          // calculator.setIsLoad(true);
                                          calculator.recipientSend(
                                            recipients.receipients[i],
                                            navigate: true,
                                          );
                                        },
                                        height: 38,
                                        padding: EdgeInsets.zero,
                                        color: Colors.transparent,
                                        foregroundColor: context.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 10),
                                              TextX(
                                                _arb!.send.toUpperCase(),
                                              ),
                                              const SizedBox(width: 10),
                                              const Icon(Icons.chevron_right)
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    recipients.isFinish
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              recipients.increasePage();
                              Helper.log("page ${recipients.page}");
                              GetRecipients.request(
                                  page: recipients.page,
                                  search: _searchController.text);
                              recipients.updateUi();
                            },
                            child: recipients.isLoadingBtn
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  )
                                : Text(_arb!.loadMore)),
                    const SizedBox(
                      height: 20,
                    )
                  ],
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
