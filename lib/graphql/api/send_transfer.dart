import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql/client.dart';
import 'package:provider/provider.dart';

import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/widgets/dialogs/loading.dart';
import '/graphql/explorer/mutations.dart';
import '/graphql/graphql.dart';
import '/helper/debug_colors.dart';
import '/helper/helper.dart';
import '/models/transfer.dart';
import '/router/app_route.dart';
import '/tools/tools.dart';
import 'get_countries.dart';

class SendTransfer {
  SendTransfer(
    this.context,
    this.page, {
    required this.recipientAmount,
    required this.sendAmount,
    required this.recipientId,
    required this.receivingCityId,
    required this.providerId,
    required this.paymentMethodId,
    required this.isReceiveInUSD,
    this.fields = const {},
  });

  final BuildContext context;
  final PageController page;
  final double recipientAmount, sendAmount;
  final int receivingCityId, providerId, paymentMethodId, recipientId;
  final bool isReceiveInUSD;
  final Map<int, String> fields;

  static late AppLocalizations _arb;
  static late TransfersState _provider;
  static late Calculator _calculator;
  static Map<String, dynamic> _variables = const <String, dynamic>{};

  Future<void> request() async {
    _provider = Provider.of<TransfersState>(context, listen: false);
    _calculator = Provider.of<Calculator>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _arb = AppLocalizations.of(context)!;
    });

    LoadingDialog().show();

    _variables = <String, dynamic>{
      'recipientAmount': recipientAmount,
      'sendAmount': sendAmount,
      'recipientId': recipientId,
      'isReceiveInUSD': isReceiveInUSD,
      'paymentMethodId': paymentMethodId,
      'receivingCityId': receivingCityId,
      'providerId': providerId,
      'providerFields': fields.entries
          .map((e) => {'fieldId': e.key, 'value': e.value})
          .toList(),
    };

    Helper.debugger('transfer');
    Helper.log('PARAMETERS: $_variables', color: DebugColor.white);

    await GraphQL.client().mutate(
      MutationOptions(
        document: gql(Mutations.transfer),
        variables: _variables,
        onCompleted: (Map<String, dynamic>? data) {
          LoadingDialog.dismiss();

          Helper.debug('transfer', '$data');

          if (data != null) return _result(data);
        },
        onError: (OperationException? error) {
          Helper.log('error: $error', color: DebugColor.red);

          if (error != null) {
            return _error(error);
          } else {
            Helper.toast(_arb.somethingWentWrong);
          }
        },
      ),
    );
  }

  void _result(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data.containsKey('transfer')) {
      final TransferModel transfer = TransferModel.fromJson(data['transfer']);
      const Duration duration = Duration(milliseconds: 250);
      page.nextPage(duration: duration, curve: Curves.easeIn);
      // Global.pageCtrl.jumpToPage(Pages.transfers.index);
      _provider.getTransfer(transfer);
    }
  }

  void _error(OperationException error) async {
    if (error.graphqlErrors.isNotEmpty) {
      switch (error.graphqlErrors.first.extensions?['code']) {
        case 302:
          context.pushNamed(
            '/${AppRoute.webView}',
            pathParameters: <String, String>{
              'url': error.graphqlErrors.first.extensions?['message'],
            },
          );
          break;
        case 452:
          Helper.bannerWarning(
            '\n${_arb.cannotSendThisTransferDueToRecipientDetailsHasBeenModifiedOrDeleteKindlyMakeNewTransfer}\n',
          );
          break;

        case 456:
          Helper.bannerWarning(_arb.yourSendingCountryIsCurrentlyDeactivated);
          break;

        case 463:
          Helper.bannerWarning(
            _arb.youHaveExceededTheMaximumSendingAmountThisMonth,
          );
          break;

        case 468:
          String amount = '';
          String message = error.graphqlErrors.first.extensions?['message'];
          List<num> numbers = Tools.extractNumbers(message);
          for (num number in numbers) {
            amount = '$number';
          }

          Helper.bannerWarning(
            '${_arb.minimumReceivingLimitToThisPickUpPointIs} $amount ${_calculator.receiverCountry.currency.code}',
          );
          GetCountriesAPI.request();
          break;

        case 479:
          String amount = '';
          String message = error.graphqlErrors.first.extensions?['message'];
          List<num> numbers = Tools.extractNumbers(message);
          for (num number in numbers) {
            amount = '$number';
          }
          Helper.bannerWarning(
            '${_arb.recipientProviderMaxAmountIs} $amount ${_calculator.receiverCountry.currency.code}',
          );
          break;

        case 492:
          Helper.bannerWarning(_arb.providerIsInactiveForTheReceivingCity);
          break;

        default:
          Helper.toast(
              '${_arb.somethingWentWrong} [${error.graphqlErrors.first.extensions?['code']}]');
      }
    } else {
      Helper.toast(_arb.somethingWentWrong);
    }
  }
}
