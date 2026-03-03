import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AmanaSend'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfers;

  /// No description provided for @recipients.
  ///
  /// In en, this message translates to:
  /// **'Recipients'**
  String get recipients;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @transfersHistory.
  ///
  /// In en, this message translates to:
  /// **'Transfers history'**
  String get transfersHistory;

  /// No description provided for @allTransfers.
  ///
  /// In en, this message translates to:
  /// **'All transfers'**
  String get allTransfers;

  /// No description provided for @addNewTransfer.
  ///
  /// In en, this message translates to:
  /// **'Add new transfer'**
  String get addNewTransfer;

  /// No description provided for @currenciesPricesUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Currencies prices up to date.'**
  String get currenciesPricesUpToDate;

  /// No description provided for @transferStatus.
  ///
  /// In en, this message translates to:
  /// **'Transfer status'**
  String get transferStatus;

  /// No description provided for @transferDetails.
  ///
  /// In en, this message translates to:
  /// **'Transfer details'**
  String get transferDetails;

  /// No description provided for @recentTransferUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Recent transfer update status:'**
  String get recentTransferUpdateStatus;

  /// No description provided for @transferInformationDetails.
  ///
  /// In en, this message translates to:
  /// **'Transfer information details:'**
  String get transferInformationDetails;

  /// No description provided for @transferDate.
  ///
  /// In en, this message translates to:
  /// **'Transfer date'**
  String get transferDate;

  /// No description provided for @resendAgain.
  ///
  /// In en, this message translates to:
  /// **'Resend again'**
  String get resendAgain;

  /// No description provided for @continueX.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueX;

  /// No description provided for @waitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting Payment'**
  String get waitingPayment;

  /// No description provided for @awaitingProcess.
  ///
  /// In en, this message translates to:
  /// **'Paid - Waiting Processing'**
  String get awaitingProcess;

  /// No description provided for @noTransfersFoundYet.
  ///
  /// In en, this message translates to:
  /// **'No transfers found yet'**
  String get noTransfersFoundYet;

  /// No description provided for @recipientProviderMaxAmountIs.
  ///
  /// In en, this message translates to:
  /// **'المزود المستلم يمكنه الحصول على الحد الأقصى '**
  String get recipientProviderMaxAmountIs;

  /// No description provided for @pleaseMakeSureToEnterPhoneNumberWhatsAppNumberAndFullNameCorrectlyToAvoidDelayingTheTransferDelivery.
  ///
  /// In en, this message translates to:
  /// **'Please make sure to enter phone number, WhatsApp number, and full name correctly to avoid delaying the transfer delivery'**
  String
      get pleaseMakeSureToEnterPhoneNumberWhatsAppNumberAndFullNameCorrectlyToAvoidDelayingTheTransferDelivery;

  /// No description provided for @beforeConfirmingYourOrderYouShouldHaveADigitalWallet.
  ///
  /// In en, this message translates to:
  /// **'Before confirming your order you should have a digital wallet'**
  String get beforeConfirmingYourOrderYouShouldHaveADigitalWallet;

  /// No description provided for @clickHereToLearnHowToPay.
  ///
  /// In en, this message translates to:
  /// **'Click here to learn how to pay'**
  String get clickHereToLearnHowToPay;

  /// No description provided for @yourOrderHasBeenReceivedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your order has been received successfully!'**
  String get yourOrderHasBeenReceivedSuccessfully;

  /// No description provided for @toCompleteTheTransferPleasePayTheDueAmount.
  ///
  /// In en, this message translates to:
  /// **'To complete the transfer please pay the due amount'**
  String get toCompleteTheTransferPleasePayTheDueAmount;

  /// No description provided for @toThisWalletAddress.
  ///
  /// In en, this message translates to:
  /// **'To this Wallet Address'**
  String get toThisWalletAddress;

  /// No description provided for @onceThePaymentIsBeingConfirmedWeWillNotifyYouAndProcessTheTransferImmediately.
  ///
  /// In en, this message translates to:
  /// **'Once the payment is being confirmed, we will notify you and process the transfer immediately'**
  String
      get onceThePaymentIsBeingConfirmedWeWillNotifyYouAndProcessTheTransferImmediately;

  /// No description provided for @pleaseMakeSureToPayTheExactAmountToTheWALLETInOneGoOtherwiseIfTheAmountPaidInMoreOrLessWeWillPayOutExactlyWhatWeReceivedOnSameExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Please Make sure to pay the exact amount to the WALLET in one go, otherwise if the amount paid in more or less we will pay out exactly what we received on same exchange rate'**
  String
      get pleaseMakeSureToPayTheExactAmountToTheWALLETInOneGoOtherwiseIfTheAmountPaidInMoreOrLessWeWillPayOutExactlyWhatWeReceivedOnSameExchangeRate;

  /// No description provided for @yourSendingCountryIsCurrentlyDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Your sending country is currently deactivated'**
  String get yourSendingCountryIsCurrentlyDeactivated;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didNotReceiveCode;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @neW.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get neW;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @processed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get processed;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @providerFees.
  ///
  /// In en, this message translates to:
  /// **'Provider fees'**
  String get providerFees;

  /// No description provided for @selectPickUpPoint.
  ///
  /// In en, this message translates to:
  /// **'Select pickup point'**
  String get selectPickUpPoint;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @howToPay.
  ///
  /// In en, this message translates to:
  /// **'How to pay'**
  String get howToPay;

  /// No description provided for @walletAddress.
  ///
  /// In en, this message translates to:
  /// **'Wallet address'**
  String get walletAddress;

  /// No description provided for @walletAddressWillExpireWithin.
  ///
  /// In en, this message translates to:
  /// **'Wallet address will expire within'**
  String get walletAddressWillExpireWithin;

  /// No description provided for @oopsWalletAddressIsExpired.
  ///
  /// In en, this message translates to:
  /// **'Oops... Wallet address is expired'**
  String get oopsWalletAddressIsExpired;

  /// No description provided for @recipientBankDetailsOptional.
  ///
  /// In en, this message translates to:
  /// **'Recipient Bank details (Optional)'**
  String get recipientBankDetailsOptional;

  /// No description provided for @editRecipient.
  ///
  /// In en, this message translates to:
  /// **'Edit recipient'**
  String get editRecipient;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccessful;

  /// No description provided for @yourPaymentHasBeenSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your payment has been submitted successfully'**
  String get yourPaymentHasBeenSubmittedSuccessfully;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @confirmSendingOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm sending order'**
  String get confirmSendingOrder;

  /// No description provided for @weOnlyAcceptInUSDT.
  ///
  /// In en, this message translates to:
  /// **'The transfer is paid using the chosen digital currency'**
  String get weOnlyAcceptInUSDT;

  /// No description provided for @readOnly.
  ///
  /// In en, this message translates to:
  /// **'Read Only'**
  String get readOnly;

  /// No description provided for @transferId.
  ///
  /// In en, this message translates to:
  /// **'Transfer-ID'**
  String get transferId;

  /// No description provided for @transactionNo.
  ///
  /// In en, this message translates to:
  /// **'Transaction no'**
  String get transactionNo;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction date'**
  String get transactionDate;

  /// No description provided for @sentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to'**
  String get sentTo;

  /// No description provided for @thankYouForUsingAmanaSendYouCanTrackTheTransactionProcessingOnTheTransfersPage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using AmanaSend. You can track the transaction processing on the transfers page'**
  String
      get thankYouForUsingAmanaSendYouCanTrackTheTransactionProcessingOnTheTransfersPage;

  /// No description provided for @trackTransfer.
  ///
  /// In en, this message translates to:
  /// **'Track transfer'**
  String get trackTransfer;

  /// No description provided for @receiveTypeIsNotAvailableForThisCountry.
  ///
  /// In en, this message translates to:
  /// **'Receive type isn\'t available for this country'**
  String get receiveTypeIsNotAvailableForThisCountry;

  /// No description provided for @iAccept.
  ///
  /// In en, this message translates to:
  /// **'I accept'**
  String get iAccept;

  /// No description provided for @noteAllRemittanceWillBeWithin48HoursExceptForPublicHolidays.
  ///
  /// In en, this message translates to:
  /// **'Note: All remittance will be within 48 hours, except for public holidays'**
  String get noteAllRemittanceWillBeWithin48HoursExceptForPublicHolidays;

  /// No description provided for @pleaseReadOurTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Please read our terms & conditions'**
  String get pleaseReadOurTermsAndConditions;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @expireDate.
  ///
  /// In en, this message translates to:
  /// **'Expire date'**
  String get expireDate;

  /// No description provided for @cardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Card holder name'**
  String get cardHolderName;

  /// No description provided for @payByCard.
  ///
  /// In en, this message translates to:
  /// **'Pay by card'**
  String get payByCard;

  /// No description provided for @payByCash.
  ///
  /// In en, this message translates to:
  /// **'Pay by cash'**
  String get payByCash;

  /// No description provided for @cardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card details'**
  String get cardDetails;

  /// No description provided for @noteWeAreNotResponsibleForAnyAdditionalFeesThatYourBankMayCharge.
  ///
  /// In en, this message translates to:
  /// **'Note: We\'re not responsible for any additional fees that your bank may charge'**
  String get noteWeAreNotResponsibleForAnyAdditionalFeesThatYourBankMayCharge;

  /// No description provided for @expireDateStartsWithMonth.
  ///
  /// In en, this message translates to:
  /// **'Expire date starts with month'**
  String get expireDateStartsWithMonth;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get payNow;

  /// No description provided for @chooseCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose country'**
  String get chooseCountry;

  /// No description provided for @areYouSureYouWantToCancelThisTransfer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this transfer?'**
  String get areYouSureYouWantToCancelThisTransfer;

  /// No description provided for @pleaseSelectRecipient.
  ///
  /// In en, this message translates to:
  /// **'Please select recipient'**
  String get pleaseSelectRecipient;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @pleaseNoteThatThisWalletAddressIsJustForThisTransferPleaseDoNotUseItForAnotherTransfers.
  ///
  /// In en, this message translates to:
  /// **'Please note that this wallet address is just for this transfer, please don\'t use it for another transfers'**
  String
      get pleaseNoteThatThisWalletAddressIsJustForThisTransferPleaseDoNotUseItForAnotherTransfers;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get paymentDetails;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oops... Something went wrong'**
  String get oops;

  /// No description provided for @copiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Copied successfully!'**
  String get copiedSuccessfully;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @onlyArabic.
  ///
  /// In en, this message translates to:
  /// **'ONLY ARABIC LETTERS'**
  String get onlyArabic;

  /// No description provided for @onlyLatin.
  ///
  /// In en, this message translates to:
  /// **'ONLY LATIN LETTERS'**
  String get onlyLatin;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @pleaseEnter.
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get pleaseEnter;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createNewAccount;

  /// No description provided for @logInToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get logInToYourAccount;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @weWillSendResetPassword.
  ///
  /// In en, this message translates to:
  /// **'We will send reset password OTP code via SMS message to your mobile number'**
  String get weWillSendResetPassword;

  /// No description provided for @verifyMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify mobile number'**
  String get verifyMobileNumber;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get verifyEmail;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get savePassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'login'**
  String get logIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get registerNow;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @fatherName.
  ///
  /// In en, this message translates to:
  /// **'Father name'**
  String get fatherName;

  /// No description provided for @fatherNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Father name (Optional)'**
  String get fatherNameOptional;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @passwordMustContainAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 8 characters!'**
  String get passwordMustContainAtLeast8Characters;

  /// No description provided for @passwordAndConfirmPasswordDoesNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Password & confirm password doesn\'t match!'**
  String get passwordAndConfirmPasswordDoesNotMatch;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sendMoney.
  ///
  /// In en, this message translates to:
  /// **'Send money'**
  String get sendMoney;

  /// No description provided for @deleteRecipient.
  ///
  /// In en, this message translates to:
  /// **'Delete recipient'**
  String get deleteRecipient;

  /// No description provided for @areYouSureYouWantToDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get areYouSureYouWantToDelete;

  /// No description provided for @chooseRecipient.
  ///
  /// In en, this message translates to:
  /// **'Choose a recipient'**
  String get chooseRecipient;

  /// No description provided for @chooseRecipientToContinue.
  ///
  /// In en, this message translates to:
  /// **'Choose a recipient to continue'**
  String get chooseRecipientToContinue;

  /// No description provided for @reviewAndCheckout.
  ///
  /// In en, this message translates to:
  /// **'Review & Checkout'**
  String get reviewAndCheckout;

  /// No description provided for @reviewYourTransferDetailsToContinueCheckout.
  ///
  /// In en, this message translates to:
  /// **'Review your transfer details to continue checkout'**
  String get reviewYourTransferDetailsToContinueCheckout;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @enterDebitCreditCardToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter Debit/Credit card to continue'**
  String get enterDebitCreditCardToContinue;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @wrongLogin.
  ///
  /// In en, this message translates to:
  /// **'Wrong login info'**
  String get wrongLogin;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention!'**
  String get attention;

  /// No description provided for @proceedWithLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'Proceed with logging out?'**
  String get proceedWithLoggingOut;

  /// No description provided for @selectFromTheListBelow.
  ///
  /// In en, this message translates to:
  /// **'Select from the list below'**
  String get selectFromTheListBelow;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @pleaseAvoidStartingMobileNumberWithAZero.
  ///
  /// In en, this message translates to:
  /// **'Please avoid starting mobile number with a zero'**
  String get pleaseAvoidStartingMobileNumberWithAZero;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System theme'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @youSend.
  ///
  /// In en, this message translates to:
  /// **'You send'**
  String get youSend;

  /// No description provided for @sendingRate.
  ///
  /// In en, this message translates to:
  /// **'Sending rate'**
  String get sendingRate;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @reviewSendingInfo.
  ///
  /// In en, this message translates to:
  /// **'Review sending info'**
  String get reviewSendingInfo;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient name'**
  String get recipientName;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @totalToPay.
  ///
  /// In en, this message translates to:
  /// **'Total to pay'**
  String get totalToPay;

  /// No description provided for @receiverGets.
  ///
  /// In en, this message translates to:
  /// **'Receiver gets'**
  String get receiverGets;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @selectReceiveType.
  ///
  /// In en, this message translates to:
  /// **'Select receive type'**
  String get selectReceiveType;

  /// No description provided for @receiveType.
  ///
  /// In en, this message translates to:
  /// **'Receive type'**
  String get receiveType;

  /// No description provided for @cashPickUp.
  ///
  /// In en, this message translates to:
  /// **'Cash Pickup'**
  String get cashPickUp;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @addRecipient.
  ///
  /// In en, this message translates to:
  /// **'Add recipient'**
  String get addRecipient;

  /// No description provided for @addNewRecipient.
  ///
  /// In en, this message translates to:
  /// **'Add new recipient'**
  String get addNewRecipient;

  /// No description provided for @myRecipients.
  ///
  /// In en, this message translates to:
  /// **'My Recipients'**
  String get myRecipients;

  /// No description provided for @recipientsList.
  ///
  /// In en, this message translates to:
  /// **'Recipients list'**
  String get recipientsList;

  /// No description provided for @recipientNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Recipient name (English)*'**
  String get recipientNameEnglish;

  /// No description provided for @recipientNameEnglishOptional.
  ///
  /// In en, this message translates to:
  /// **'Recipient name (English) / Optional'**
  String get recipientNameEnglishOptional;

  /// No description provided for @recipientNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Recipient name (Arabic)*'**
  String get recipientNameArabic;

  /// No description provided for @recipientNameArabicOptional.
  ///
  /// In en, this message translates to:
  /// **'Recipient name (Arabic) / Optional'**
  String get recipientNameArabicOptional;

  /// No description provided for @relation.
  ///
  /// In en, this message translates to:
  /// **'Relation *'**
  String get relation;

  /// No description provided for @youHaveExceededTheMaximumSendingAmountThisMonth.
  ///
  /// In en, this message translates to:
  /// **'You\'ve exceeded the maximum sending amount this month'**
  String get youHaveExceededTheMaximumSendingAmountThisMonth;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @yourMaxSendingAmountWithin.
  ///
  /// In en, this message translates to:
  /// **'Your max sending amount within'**
  String get yourMaxSendingAmountWithin;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @iS.
  ///
  /// In en, this message translates to:
  /// **'is'**
  String get iS;

  /// No description provided for @captchaVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Captcha verification failed'**
  String get captchaVerificationFailed;

  /// No description provided for @ifYourIDHasTwoSidesSuchAs.
  ///
  /// In en, this message translates to:
  /// **'if your ID has two sides such as'**
  String get ifYourIDHasTwoSidesSuchAs;

  /// No description provided for @drivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving license'**
  String get drivingLicense;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @residentPermit.
  ///
  /// In en, this message translates to:
  /// **'Resident permit'**
  String get residentPermit;

  /// No description provided for @please.
  ///
  /// In en, this message translates to:
  /// **'please'**
  String get please;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'upload'**
  String get upload;

  /// No description provided for @backside.
  ///
  /// In en, this message translates to:
  /// **'backside'**
  String get backside;

  /// No description provided for @inTheOtherDocumentsSectionBelowOnThisPageOtherwiseYourAccountWillBeRejected.
  ///
  /// In en, this message translates to:
  /// **'in the (other documents) section below on this page, otherwise your account will be rejected'**
  String
      get inTheOtherDocumentsSectionBelowOnThisPageOtherwiseYourAccountWillBeRejected;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @ticket.
  ///
  /// In en, this message translates to:
  /// **'ticket'**
  String get ticket;

  /// No description provided for @pleaseSelectReceiveType.
  ///
  /// In en, this message translates to:
  /// **'Please select receive type'**
  String get pleaseSelectReceiveType;

  /// No description provided for @enterAccountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Enter account holder name'**
  String get enterAccountHolderName;

  /// No description provided for @enterRecipientArabicName.
  ///
  /// In en, this message translates to:
  /// **'Enter recipient Arabic name'**
  String get enterRecipientArabicName;

  /// No description provided for @enterRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Enter recipient name'**
  String get enterRecipientName;

  /// No description provided for @countries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get cities;

  /// No description provided for @fullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get fullAddress;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumber;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank name'**
  String get bankName;

  /// No description provided for @recipientBankInfoIsMissingPleaseEditRecipientByAddingBankAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Recipient bank info is missing, Please Edit recipient by adding bank account details'**
  String
      get recipientBankInfoIsMissingPleaseEditRecipientByAddingBankAccountDetails;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get selectCity;

  /// No description provided for @typeOfCurrency.
  ///
  /// In en, this message translates to:
  /// **'Type of currency'**
  String get typeOfCurrency;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose the digital currency'**
  String get chooseCurrency;

  /// No description provided for @pleaseChooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select crypto payment method'**
  String get pleaseChooseCurrency;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @selectCountryPhoneCodeFromTheListBelow.
  ///
  /// In en, this message translates to:
  /// **'Select country phone code from the list below'**
  String get selectCountryPhoneCodeFromTheListBelow;

  /// No description provided for @selectCityFromTheListBelow.
  ///
  /// In en, this message translates to:
  /// **'Select city from the list below'**
  String get selectCityFromTheListBelow;

  /// No description provided for @areaOptionalEXStreetName.
  ///
  /// In en, this message translates to:
  /// **'Area (Optional) EX: Street name'**
  String get areaOptionalEXStreetName;

  /// No description provided for @pickUpPointsReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Pickup points (Read only)'**
  String get pickUpPointsReadOnly;

  /// No description provided for @pickUpPoint.
  ///
  /// In en, this message translates to:
  /// **'Pickup point'**
  String get pickUpPoint;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact details *'**
  String get contactDetails;

  /// No description provided for @relativeRelation.
  ///
  /// In en, this message translates to:
  /// **'Relative relation'**
  String get relativeRelation;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @countryCity.
  ///
  /// In en, this message translates to:
  /// **'Country/City'**
  String get countryCity;

  /// No description provided for @sendCountries.
  ///
  /// In en, this message translates to:
  /// **'Send Countries'**
  String get sendCountries;

  /// No description provided for @receiverCountries.
  ///
  /// In en, this message translates to:
  /// **'Receiver Countries'**
  String get receiverCountries;

  /// No description provided for @attentionWhenMakingThePayment.
  ///
  /// In en, this message translates to:
  /// **'Attention when making the payment:'**
  String get attentionWhenMakingThePayment;

  /// No description provided for @makeSureToEnterTheWalletAddressCorrectly.
  ///
  /// In en, this message translates to:
  /// **'Make sure to enter the wallet address correctly and completely, and use'**
  String get makeSureToEnterTheWalletAddressCorrectly;

  /// No description provided for @polygonNetworkOnly.
  ///
  /// In en, this message translates to:
  /// **'network only, as any error or use of another network will result in the permanent loss of your funds, and your transactions will not be considered as paid.'**
  String get polygonNetworkOnly;

  /// No description provided for @pleaseEnterSendingAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter sending amount'**
  String get pleaseEnterSendingAmount;

  /// No description provided for @minimumReceivingLimitToThisPickUpPointIs.
  ///
  /// In en, this message translates to:
  /// **'Minimum receiving limit to this pickup point is'**
  String get minimumReceivingLimitToThisPickUpPointIs;

  /// No description provided for @maximumReceivingLimitToThisPickUpPointIs.
  ///
  /// In en, this message translates to:
  /// **'Maximum receiving limit to this pickup point is'**
  String get maximumReceivingLimitToThisPickUpPointIs;

  /// No description provided for @useThisUniqueWalletAddressForOneTimeAndForThisTransferOnly.
  ///
  /// In en, this message translates to:
  /// **'Use this unique wallet address for one time and for this transfer only'**
  String get useThisUniqueWalletAddressForOneTimeAndForThisTransferOnly;

  /// No description provided for @walletNetwork.
  ///
  /// In en, this message translates to:
  /// **'Wallet network'**
  String get walletNetwork;

  /// No description provided for @pleasePayWithinAMaximumPeriod.
  ///
  /// In en, this message translates to:
  /// **'Please pay within a maximum period'**
  String get pleasePayWithinAMaximumPeriod;

  /// No description provided for @timeLimitToPay.
  ///
  /// In en, this message translates to:
  /// **'Time limit to pay'**
  String get timeLimitToPay;

  /// No description provided for @ifThePaymentHasNotBeenDoneInCertainTimeItIsNoLongerPossibleToUseThisWalletAndTheOrderWillBeCanceled.
  ///
  /// In en, this message translates to:
  /// **'If the payment has not been done in certain time, it is no longer possible to use this wallet and the order will be canceled.'**
  String
      get ifThePaymentHasNotBeenDoneInCertainTimeItIsNoLongerPossibleToUseThisWalletAndTheOrderWillBeCanceled;

  /// No description provided for @yourMaxLevelSendingAmountIs.
  ///
  /// In en, this message translates to:
  /// **'Your max level sending amount is'**
  String get yourMaxLevelSendingAmountIs;

  /// No description provided for @toIncreaseYourMaxLevelAmountKindlyVerifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'To increase your max level amount, Kindly upgrade your account'**
  String get toIncreaseYourMaxLevelAmountKindlyVerifyYourAccount;

  /// No description provided for @selectTheCountryYouWantToTransferTo.
  ///
  /// In en, this message translates to:
  /// **'Select the country you want to transfer to'**
  String get selectTheCountryYouWantToTransferTo;

  /// No description provided for @selectTheReceivingCity.
  ///
  /// In en, this message translates to:
  /// **'Select the receiving city'**
  String get selectTheReceivingCity;

  /// No description provided for @knowTheCurrentExchangeRateAndChooseYourPreferredAgent.
  ///
  /// In en, this message translates to:
  /// **'Know the current exchange rate and choose your preferred agent'**
  String get knowTheCurrentExchangeRateAndChooseYourPreferredAgent;

  /// No description provided for @enterTheAmountYouWantToTransferInTheUSDTWhichIsEqualToTheValueOfTheUSDollar.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you want to transfer in the USDT which is equal to the value of the US dollar \$'**
  String
      get enterTheAmountYouWantToTransferInTheUSDTWhichIsEqualToTheValueOfTheUSDollar;

  /// No description provided for @theAmountRequiredToBeTransferredInYourLocalCurrencyIsApproximatelyBasedOnTheCurrentExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'The amount required to be transferred in your local currency is approximately based on the current exchange rate'**
  String
      get theAmountRequiredToBeTransferredInYourLocalCurrencyIsApproximatelyBasedOnTheCurrentExchangeRate;

  /// No description provided for @theAmountTheRecipientWillReceiveDependsOnTheExchangeRateOfTheSelectedAgent.
  ///
  /// In en, this message translates to:
  /// **'The amount the recipient will receive depends on the exchange rate of the selected agent'**
  String
      get theAmountTheRecipientWillReceiveDependsOnTheExchangeRateOfTheSelectedAgent;

  /// No description provided for @afterCompletingTheTransferInformationClickHereToSpecifyTheNameOfTheRecipientAndPayTheAmount.
  ///
  /// In en, this message translates to:
  /// **'After completing the transfer information, click here to specify the name of the recipient and pay the amount'**
  String
      get afterCompletingTheTransferInformationClickHereToSpecifyTheNameOfTheRecipientAndPayTheAmount;

  /// No description provided for @cameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission'**
  String get cameraPermission;

  /// No description provided for @pleaseAllowAppToAccessCamera.
  ///
  /// In en, this message translates to:
  /// **'Please allow app to access camera'**
  String get pleaseAllowAppToAccessCamera;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @takeThePhotoWithinTheFrame.
  ///
  /// In en, this message translates to:
  /// **'Take the photo within the frame'**
  String get takeThePhotoWithinTheFrame;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @clickOnTheFocusedBoxToContinue.
  ///
  /// In en, this message translates to:
  /// **'Click on the focused box to continue'**
  String get clickOnTheFocusedBoxToContinue;

  /// No description provided for @noNewChangesInTheFieldsToSave.
  ///
  /// In en, this message translates to:
  /// **'There are no new changes in the fields to save'**
  String get noNewChangesInTheFieldsToSave;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select currency'**
  String get selectCurrency;

  /// No description provided for @selectReceiveCurrencyForThisCountry.
  ///
  /// In en, this message translates to:
  /// **'Select receive currency for this country'**
  String get selectReceiveCurrencyForThisCountry;

  /// No description provided for @usdIsNotAvailableForThisCountry.
  ///
  /// In en, this message translates to:
  /// **'USD is not available for this country'**
  String get usdIsNotAvailableForThisCountry;

  /// No description provided for @usdDollar.
  ///
  /// In en, this message translates to:
  /// **'USD (US Dollar)'**
  String get usdDollar;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @enterOTPcodeSentToTheNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP code sent to the number'**
  String get enterOTPcodeSentToTheNumber;

  /// No description provided for @enterOTPcodeSentToTheEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP code sent to the email'**
  String get enterOTPcodeSentToTheEmail;

  /// No description provided for @enterOTPVerificationCodeToResetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP verification code to reset your password'**
  String get enterOTPVerificationCodeToResetYourPassword;

  /// No description provided for @codeSuccessfullySentKindlyWait.
  ///
  /// In en, this message translates to:
  /// **'Code successfully sent, Kindly wait'**
  String get codeSuccessfullySentKindlyWait;

  /// No description provided for @youCanRequestAnotherOTPagainWithin.
  ///
  /// In en, this message translates to:
  /// **'You can request another OTP again within'**
  String get youCanRequestAnotherOTPagainWithin;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @newPasswordMustContainAtLeastEightLetters.
  ///
  /// In en, this message translates to:
  /// **'New password must contain at least eight letters!'**
  String get newPasswordMustContainAtLeastEightLetters;

  /// No description provided for @newPasswordAndConfirmPasswordDoesNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New password & confirm password doesn\'t match!'**
  String get newPasswordAndConfirmPasswordDoesNotMatch;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @recipientCountryUnavailableAtTheMoment.
  ///
  /// In en, this message translates to:
  /// **'Recipient country unavailable at the moment'**
  String get recipientCountryUnavailableAtTheMoment;

  /// No description provided for @passwordSuccessfullyChangedPleaseLoginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Password successfully changed, Please login to continue'**
  String get passwordSuccessfullyChangedPleaseLoginToContinue;

  /// No description provided for @pleaseloginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue'**
  String get pleaseloginToContinue;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @newPasswordCannotBeTheSameAsTheCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as the current password'**
  String get newPasswordCannotBeTheSameAsTheCurrentPassword;

  /// No description provided for @recipientHasBeenDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Recipient has been deleted successfully'**
  String get recipientHasBeenDeletedSuccessfully;

  /// No description provided for @accountHasBeenDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account has been deleted successfully'**
  String get accountHasBeenDeletedSuccessfully;

  /// No description provided for @invalidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid mobile number'**
  String get invalidMobileNumber;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @wrongEmail.
  ///
  /// In en, this message translates to:
  /// **'Wrong email'**
  String get wrongEmail;

  /// No description provided for @mobileAlreadyExist.
  ///
  /// In en, this message translates to:
  /// **'Mobile already exist'**
  String get mobileAlreadyExist;

  /// No description provided for @emailAlreadyExist.
  ///
  /// In en, this message translates to:
  /// **'Email already exist'**
  String get emailAlreadyExist;

  /// No description provided for @accountDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Account deactivated'**
  String get accountDeactivated;

  /// No description provided for @youHaveTriedThreeWrongAttemptsYouCanTryAgainNext24h.
  ///
  /// In en, this message translates to:
  /// **'You\'ve tried three wrong attempts. You can try again next 24h'**
  String get youHaveTriedThreeWrongAttemptsYouCanTryAgainNext24h;

  /// No description provided for @iDExpireDateAlreadyExpired.
  ///
  /// In en, this message translates to:
  /// **'ID Expire date already expired'**
  String get iDExpireDateAlreadyExpired;

  /// No description provided for @iDIssuedDateIsInvalid.
  ///
  /// In en, this message translates to:
  /// **'ID Issued date is invalid'**
  String get iDIssuedDateIsInvalid;

  /// No description provided for @accountIsUnderReview.
  ///
  /// In en, this message translates to:
  /// **'account is under review'**
  String get accountIsUnderReview;

  /// No description provided for @accountIsAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'Account is already verified'**
  String get accountIsAlreadyVerified;

  /// No description provided for @mobileWallet.
  ///
  /// In en, this message translates to:
  /// **'Mobile wallet'**
  String get mobileWallet;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get bankTransfer;

  /// No description provided for @startSendingMoney.
  ///
  /// In en, this message translates to:
  /// **'Start sending money'**
  String get startSendingMoney;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @youAskedToSend.
  ///
  /// In en, this message translates to:
  /// **'You asked to send'**
  String get youAskedToSend;

  /// No description provided for @youSent.
  ///
  /// In en, this message translates to:
  /// **'You sent'**
  String get youSent;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate'**
  String get exchangeRate;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @contactSupportTeam.
  ///
  /// In en, this message translates to:
  /// **'Contact support team'**
  String get contactSupportTeam;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @mainInformation.
  ///
  /// In en, this message translates to:
  /// **'Main information'**
  String get mainInformation;

  /// No description provided for @firstNameFatherNameLastName.
  ///
  /// In en, this message translates to:
  /// **'First name - Father name - Last name'**
  String get firstNameFatherNameLastName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address *'**
  String get address;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get enterCity;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name *'**
  String get fullName;

  /// No description provided for @enterPostCode.
  ///
  /// In en, this message translates to:
  /// **'Enter postcode'**
  String get enterPostCode;

  /// No description provided for @enterStreet.
  ///
  /// In en, this message translates to:
  /// **'Enter street'**
  String get enterStreet;

  /// No description provided for @enterHouseNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter house number'**
  String get enterHouseNumber;

  /// No description provided for @pleaseUploadProofOfAddress.
  ///
  /// In en, this message translates to:
  /// **'Please upload proof of address'**
  String get pleaseUploadProofOfAddress;

  /// No description provided for @enterIdentityNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter identity number'**
  String get enterIdentityNumber;

  /// No description provided for @pleaseUploadIdentityImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload identity image'**
  String get pleaseUploadIdentityImage;

  /// No description provided for @pleaseUploadSelfie.
  ///
  /// In en, this message translates to:
  /// **'Please upload selfie'**
  String get pleaseUploadSelfie;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequired;

  /// No description provided for @newVersionIsAvailable.
  ///
  /// In en, this message translates to:
  /// **'New Version is available'**
  String get newVersionIsAvailable;

  /// No description provided for @thereIsANewVersionAvailableToDownloadPleaseUpdateAmanaSendToContinue.
  ///
  /// In en, this message translates to:
  /// **'There\'s a new version available to download! Please update AmanaSend to continue'**
  String
      get thereIsANewVersionAvailableToDownloadPleaseUpdateAmanaSendToContinue;

  /// No description provided for @updateAmanaSend.
  ///
  /// In en, this message translates to:
  /// **'Update AmanaSend'**
  String get updateAmanaSend;

  /// No description provided for @postCode.
  ///
  /// In en, this message translates to:
  /// **'Post code'**
  String get postCode;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @buildingOptional.
  ///
  /// In en, this message translates to:
  /// **'Building (Optional)'**
  String get buildingOptional;

  /// No description provided for @houseNumber.
  ///
  /// In en, this message translates to:
  /// **'House number'**
  String get houseNumber;

  /// No description provided for @proofOfAddress.
  ///
  /// In en, this message translates to:
  /// **'Proof of address'**
  String get proofOfAddress;

  /// No description provided for @documentProvingYourPlaceOfResidenceWithYourAddressWrittenOnItSuchAsUtilityBillLeaseContractResidencePermit.
  ///
  /// In en, this message translates to:
  /// **'A document proving your place of residence with your address written on it, such as (Utility bill / Lease contract / Residence permit)'**
  String
      get documentProvingYourPlaceOfResidenceWithYourAddressWrittenOnItSuchAsUtilityBillLeaseContractResidencePermit;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday *'**
  String get birthday;

  /// No description provided for @selectBirthdayDate.
  ///
  /// In en, this message translates to:
  /// **'Select birthday date'**
  String get selectBirthdayDate;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity *'**
  String get identity;

  /// No description provided for @privacyPolicyAndPersonalDataProtection.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy and personal data protection'**
  String get privacyPolicyAndPersonalDataProtection;

  /// No description provided for @inOrderToBeAbleToUseOurServicesWeMustVerifyYourIdentityUploadClearCopyOfIdentificationCardAndProofOfResidenceAddressInAdditionToTakeSelfieWithoutHatOrSunglassesOnTheEye.
  ///
  /// In en, this message translates to:
  /// **'In order to be able to use our services, we must verify your identity. Upload a clear copy of identification card and proof of residence address, in addition to Take a selfie without a hat or sunglasses on the eye.'**
  String
      get inOrderToBeAbleToUseOurServicesWeMustVerifyYourIdentityUploadClearCopyOfIdentificationCardAndProofOfResidenceAddressInAdditionToTakeSelfieWithoutHatOrSunglassesOnTheEye;

  /// No description provided for @identityNumber.
  ///
  /// In en, this message translates to:
  /// **'Identity number'**
  String get identityNumber;

  /// No description provided for @issuedDate.
  ///
  /// In en, this message translates to:
  /// **'Issued date'**
  String get issuedDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get expiryDate;

  /// No description provided for @uploadClearCopyOfIdentityDocumentSuchAsPassportDrivingLicenseResidencePermit.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear copy of identity document such as a Passport – Driving License - Residence Permit'**
  String
      get uploadClearCopyOfIdentityDocumentSuchAsPassportDrivingLicenseResidencePermit;

  /// No description provided for @fullNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Full name (Arabic)'**
  String get fullNameArabic;

  /// No description provided for @enterFullAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter full address'**
  String get enterFullAddress;

  /// No description provided for @selfie.
  ///
  /// In en, this message translates to:
  /// **'Selfie *'**
  String get selfie;

  /// No description provided for @takeSelfie.
  ///
  /// In en, this message translates to:
  /// **'Take selfie'**
  String get takeSelfie;

  /// No description provided for @takeSelfieWithoutHatOrSunglassesOnTheEyeToCompareYourPhotoOnTheIdentificationDocument.
  ///
  /// In en, this message translates to:
  /// **'Take a selfie without a hat or sunglasses on the eye to compare your photo on the identification document'**
  String
      get takeSelfieWithoutHatOrSunglassesOnTheEyeToCompareYourPhotoOnTheIdentificationDocument;

  /// No description provided for @otherDocuments.
  ///
  /// In en, this message translates to:
  /// **'Other documents'**
  String get otherDocuments;

  /// No description provided for @noteYourTransferLimitWillIncreaseIfYouProvideSecondID.
  ///
  /// In en, this message translates to:
  /// **'Note: Your transfer limit will increase if you provide a second ID.'**
  String get noteYourTransferLimitWillIncreaseIfYouProvideSecondID;

  /// No description provided for @uploadDocumentImage.
  ///
  /// In en, this message translates to:
  /// **'Upload document image'**
  String get uploadDocumentImage;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get changeImage;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @sendingAmount.
  ///
  /// In en, this message translates to:
  /// **'Sending amount'**
  String get sendingAmount;

  /// No description provided for @estimatedValueInLocalCurrency.
  ///
  /// In en, this message translates to:
  /// **'Estimated value in local currency'**
  String get estimatedValueInLocalCurrency;

  /// No description provided for @currenciesExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Currencies exchange rate'**
  String get currenciesExchangeRate;

  /// No description provided for @providerIsInactiveForTheReceivingCity.
  ///
  /// In en, this message translates to:
  /// **'Provider is inactive for the receiving city'**
  String get providerIsInactiveForTheReceivingCity;

  /// No description provided for @oncePaymentHasBeenConfirmedInOurSystemYouWillGetNotifiedAndTheTransactionWillStartToProcessedWithin24hours.
  ///
  /// In en, this message translates to:
  /// **'Once payment has been confirmed in our system, you will get notified and the transaction will start to processed within 24 hours'**
  String
      get oncePaymentHasBeenConfirmedInOurSystemYouWillGetNotifiedAndTheTransactionWillStartToProcessedWithin24hours;

  /// No description provided for @areYouSureYouWantToDeleteYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account!?'**
  String get areYouSureYouWantToDeleteYourAccount;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @cannotSendThisTransferDueToRecipientDetailsHasBeenModifiedOrDeleteKindlyMakeNewTransfer.
  ///
  /// In en, this message translates to:
  /// **'Cannot send this transfer due to recipient details has been modified or delete, Kindly make new transfer'**
  String
      get cannotSendThisTransferDueToRecipientDetailsHasBeenModifiedOrDeleteKindlyMakeNewTransfer;

  /// No description provided for @amanaSendSupportTeam.
  ///
  /// In en, this message translates to:
  /// **'AmanaSend support team'**
  String get amanaSendSupportTeam;

  /// No description provided for @dearValuedCustomerAmanaSendSupportTeamIsHereToHelpYouPleaseFeelFreeToContactUsViaTheFollowing.
  ///
  /// In en, this message translates to:
  /// **'Dear valued customer, AmanaSend support team is here to help you, please feel free to contact us via the following:'**
  String
      get dearValuedCustomerAmanaSendSupportTeamIsHereToHelpYouPleaseFeelFreeToContactUsViaTheFollowing;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @whatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @wouldYouLikeToRateOurApp.
  ///
  /// In en, this message translates to:
  /// **'Would you like to rate our app?'**
  String get wouldYouLikeToRateOurApp;

  /// No description provided for @thankYouForUsingAmanaSend.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using Amana send'**
  String get thankYouForUsingAmanaSend;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get workingHours;

  /// No description provided for @mondayToFriday.
  ///
  /// In en, this message translates to:
  /// **'Monday to Friday'**
  String get mondayToFriday;

  /// No description provided for @mondayToSaturday.
  ///
  /// In en, this message translates to:
  /// **'Monday to Saturday'**
  String get mondayToSaturday;

  /// No description provided for @saturdayAndSunday.
  ///
  /// In en, this message translates to:
  /// **'Saturday & Sunday'**
  String get saturdayAndSunday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @dispute.
  ///
  /// In en, this message translates to:
  /// **'Dispute'**
  String get dispute;

  /// No description provided for @telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// No description provided for @verifyAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify account'**
  String get verifyAccount;

  /// No description provided for @verificationInProcess.
  ///
  /// In en, this message translates to:
  /// **'Verification in process'**
  String get verificationInProcess;

  /// No description provided for @verificationCodeWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'The verification code will be sent via WhatsApp'**
  String get verificationCodeWhatsApp;

  /// No description provided for @accountVerificationInProcessOnceAccountIsVerifiedYouWillBeAbleToTransferMoneyWorldwide.
  ///
  /// In en, this message translates to:
  /// **'Account verification in process, once account is verified, you will be able to transfer money worldwide'**
  String
      get accountVerificationInProcessOnceAccountIsVerifiedYouWillBeAbleToTransferMoneyWorldwide;

  /// No description provided for @toEnsureThatYouCanSendMoneyWorldwidePleaseVerifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'To ensure that you can send money worldwide, please verify your account.'**
  String get toEnsureThatYouCanSendMoneyWorldwidePleaseVerifyYourAccount;

  /// No description provided for @pleasePayTheBalanceForThisTransactionWithin3DaysAtYourNearestApprovedCashPaymentAddress.
  ///
  /// In en, this message translates to:
  /// **'Please pay the balance for this transaction within 3 days at your nearest approved cash payment address.'**
  String
      get pleasePayTheBalanceForThisTransactionWithin3DaysAtYourNearestApprovedCashPaymentAddress;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @verifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'Verified account'**
  String get verifiedAccount;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// No description provided for @amountWeWillConvert.
  ///
  /// In en, this message translates to:
  /// **'Amount we\'ll convert'**
  String get amountWeWillConvert;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get totalPaid;

  /// No description provided for @recipientGets.
  ///
  /// In en, this message translates to:
  /// **'Recipient gets'**
  String get recipientGets;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @firstNameOne.
  ///
  /// In en, this message translates to:
  /// **'First name (arabic)'**
  String get firstNameOne;

  /// No description provided for @lastNameOne.
  ///
  /// In en, this message translates to:
  /// **'Last name (arabic)'**
  String get lastNameOne;

  /// No description provided for @fatherNameOne.
  ///
  /// In en, this message translates to:
  /// **'Father name (arabic)'**
  String get fatherNameOne;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get english;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @suggestionsAndComplaints.
  ///
  /// In en, this message translates to:
  /// **'Suggestions And Complaints'**
  String get suggestionsAndComplaints;

  /// No description provided for @chooseTheCity.
  ///
  /// In en, this message translates to:
  /// **'Choose the city'**
  String get chooseTheCity;

  /// No description provided for @pleaseChooseTheCity.
  ///
  /// In en, this message translates to:
  /// **'Please choose the city'**
  String get pleaseChooseTheCity;

  /// No description provided for @paymentMethodDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment method details'**
  String get paymentMethodDetails;

  /// No description provided for @requiredAdditionalFields.
  ///
  /// In en, this message translates to:
  /// **'Required additional fields.'**
  String get requiredAdditionalFields;

  /// No description provided for @fixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get fixed;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characters;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @mandatoryInformation.
  ///
  /// In en, this message translates to:
  /// **'Mandatory Information'**
  String get mandatoryInformation;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
