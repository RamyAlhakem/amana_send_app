// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:provider/provider.dart';

// import '/app/theme/colors/main_colors.dart';
// import '/app/theme/decoration/decorations.dart';
// import '/app/views/main_pages/provider/calculator.dart';
// import '/app/widgets/buttons/expand_button.dart';
// import '/app/widgets/credit_card/credit_card_form.dart';
// import '/app/widgets/credit_card/credit_card_model.dart';
// import '/app/widgets/credit_card/credit_card_widget.dart';
// import '/app/widgets/row.dart';
// import '/app/widgets/text/text_x.dart';
// import '/database/injector.dart';
// import '/global/variables.dart';
// import '/graphql/api/send_transfer.dart';
// import '/helper/helper.dart';
// import '/models/user.dart';
// import 'components/bottom_buttons.dart';

// class Payment extends StatefulWidget {
//   const Payment({super.key});
//   static String cvvCode = '';

//   static final GlobalKey<FormState> form = GlobalKey<FormState>();
//   static const Duration _duration = Duration(milliseconds: 250);
//   static Widget footer(BuildContext context, PageController page) {
//     final AppLocalizations? arb = AppLocalizations.of(context);
//     return BottomButtons(
//       firstButton: ExpandButton(
//         () => page.previousPage(duration: _duration, curve: Curves.easeIn),
//         height: 45,
//         color: MainColors.red.withOpacity(0.2),
//         FittedBox(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.arrow_back,
//                 color: Theme.of(context).iconTheme.color,
//               ),
//               const SizedBox(width: 8),
//               TextX(
//                 arb!.previous.toUpperCase(),
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ],
//           ),
//         ),
//       ),
//       secondButton: ExpandButton(
//         () => _PaymentState().submit(context),
//         height: 45,
//         color: MainColors.color3,
//         FittedBox(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextX(
//                 arb.payNow.toUpperCase(),
//                 style: const TextStyle(color: Colors.white),
//               ),
//               const SizedBox(width: 8),
//               const Icon(LineIcons.check, color: Colors.white),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   State<Payment> createState() => _PaymentState();
// }

// class _PaymentState extends State<Payment> {
//   late AppLocalizations? _arb;

//   UserModel user = UserModel();

//   bool isCvvFocused = false;

//   @override
//   void initState() {
//     super.initState();
//     user = Database().getUser;
//   }

//   @override
//   void didChangeDependencies() {
//     _arb = AppLocalizations.of(context);
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     Payment.cvvCode = '';
//     Global.snackKey.currentState?.hideCurrentMaterialBanner();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Calculator>(builder: (_, state, child) {
//       child = GestureDetector(
//         onTap: () => Helper.unFocusCursor(context),
//         child: SingleChildScrollView(
//           child: Container(
//             margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
//             padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
//             decoration: Decorations.main(context),
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(1, 0, 1, 12),
//                   child: TextX(
//                     _arb!.cardDetails,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.w500,
//                         ),
//                   ),
//                 ),
//                 CreditCardWidget(
//                   cardNumber: user.cardNumber,
//                   expiryDate: user.expiryDate,
//                   cardHolderName: user.cardHolderName,
//                   cvvCode: Payment.cvvCode,
//                   showBackView: isCvvFocused,
//                   obscureCardNumber: true,
//                   obscureCardCvv: true,
//                   bankName: ' ',
//                   isHolderNameVisible: true,
//                   padding: 0,
//                   onCreditCardWidgetChange: (creditCardBrand) {},
//                 ),
//                 const SizedBox(height: 14),
//                 CreditCardForm(
//                   formKey: Payment.form,
//                   obscureCvv: true,
//                   obscureNumber: false,
//                   cardNumber: user.cardNumber,
//                   cvvCode: Payment.cvvCode,
//                   cardHolderName: user.cardHolderName,
//                   expiryDate: user.expiryDate,
//                   themeColor: Colors.blue,
//                   cardNumberDecoration: InputDecoration(
//                     labelStyle: Theme.of(context).textTheme.bodyMedium,
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     focusedBorder: focusedBorder,
//                     contentPadding: contentPadding,
//                     border: const OutlineInputBorder(),
//                     labelText: _arb!.cardNumber,
//                     hintText: 'XXXX XXXX XXXX XXXX',
//                   ),
//                   expiryDateDecoration: InputDecoration(
//                     labelStyle: Theme.of(context).textTheme.bodyMedium,
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     focusedBorder: focusedBorder,
//                     contentPadding: contentPadding,
//                     border: const OutlineInputBorder(),
//                     labelText: _arb!.expireDate,
//                     hintText: 'MM/YY',
//                   ),
//                   cvvCodeDecoration: InputDecoration(
//                     labelStyle: Theme.of(context).textTheme.bodyMedium,
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     focusedBorder: focusedBorder,
//                     contentPadding: contentPadding,
//                     border: const OutlineInputBorder(),
//                     labelText: 'CVV',
//                     hintText: 'XXX',
//                   ),
//                   cardHolderDecoration: InputDecoration(
//                     labelStyle: Theme.of(context).textTheme.bodyMedium,
//                     hintStyle: Theme.of(context).textTheme.bodySmall,
//                     focusedBorder: focusedBorder,
//                     contentPadding: contentPadding,
//                     border: const OutlineInputBorder(),
//                     labelText: _arb!.cardHolderName,
//                   ),
//                   onCreditCardModelChange: onCreditCardModelChange,
//                   onFormComplete: () => submit(context),
//                   // onFieldSubmitted: (String? v) => _submit(),
//                 ),
//                 const SizedBox(height: 20),
//                 RowSpaceBetween([
//                   TextX(
//                     _arb!.totalToPay,
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                   Text.rich(
//                     textScaler: TextScaler.noScaling,
//                     TextSpan(
//                       children: <TextSpan>[
//                         TextSpan(
//                           text: '${state.amountPlusFee.toStringAsFixed(2)} ',
//                         ),
//                         TextSpan(
//                           text: state.sendCountry.currency.code,
//                         ),
//                       ],
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ),
//                 ]),
//                 const SizedBox(height: 18),
//                 Container(
//                   padding: const EdgeInsets.all(15),
//                   decoration: Decorations.note(context),
//                   child: TextX(
//                     _arb!
//                         .noteWeAreNotResponsibleForAnyAdditionalFeesThatYourBankMayCharge,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: MainColors.red,
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//       return child;
//     });
//   }

//   Future<void> onCreditCardModelChange(CreditCardModel? creditCardModel) async {
//     setState(() {
//       user.cardNumber = creditCardModel!.cardNumber;
//       if (user.expiryDate.length >= 2 &&
//           int.parse(user.expiryDate.substring(0, 2)) > 12) {
//         Helper.toast(_arb!.expireDateStartsWithMonth);
//       }
//       user.expiryDate = creditCardModel.expiryDate;
//       user.cardHolderName = creditCardModel.cardHolderName;
//       Payment.cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });

//     Database().setUser = user;
//   }

//   Future<void> submit(BuildContext context) async {
//     if (!Payment.form.currentState!.validate()) {
//       return;
//     }
//     user = Database().getUser;

//     final calculator = Provider.of<Calculator>(context, listen: false);

//     SendTransfer(
//       context,
//       recipientAmount: double.parse(calculator.receiver.text),
//       sendAmount: double.parse(calculator.sender.text),
//       recipientId: calculator.selectedRecipient!.id,
//       isReceiveInUSD: calculator.sendUSD,
//       providerId: calculator.receiveType,
//       paymentMethodId: calculator.onlinePaymentMethodId,
//     ).request();
//   }

//   final EdgeInsets contentPadding = const EdgeInsets.fromLTRB(15, 0, 15, 0);
//   final OutlineInputBorder focusedBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.circular(4.0),
//     borderSide: const BorderSide(color: MainColors.color1, width: 2.0),
//   );
// }
