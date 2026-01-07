// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'امانة';

  @override
  String get home => 'الرئيسية';

  @override
  String get transfers => 'الحوالات';

  @override
  String get recipients => 'المستلمين';

  @override
  String get profile => 'الحساب';

  @override
  String get transfersHistory => 'سجل الحوالات';

  @override
  String get allTransfers => 'جميع الحوالات';

  @override
  String get addNewTransfer => 'إضافة حوالة جديدة';

  @override
  String get currenciesPricesUpToDate => 'أسعار العملات محدثة.';

  @override
  String get transferStatus => 'حالة الحوالة';

  @override
  String get transferDetails => 'تفاصيل الحوالة';

  @override
  String get recentTransferUpdateStatus => 'آخر تحديث لحالة الحوالة:';

  @override
  String get transferInformationDetails => 'تفاصيل معلومات التحويل:';

  @override
  String get transferDate => 'تاريخ التحويل';

  @override
  String get resendAgain => 'إرسال مرة اخرى';

  @override
  String get continueX => 'استمرار';

  @override
  String get waitingPayment => 'في انتظار الدفع';

  @override
  String get awaitingProcess => 'مسدد - بانتظار المعالجة';

  @override
  String get noTransfersFoundYet => 'لم يتم العثور على حوالات بعد';

  @override
  String get recipientProviderMaxAmountIs => 'الحد الأقصى للمزود المستلم';

  @override
  String get pleaseMakeSureToEnterPhoneNumberWhatsAppNumberAndFullNameCorrectlyToAvoidDelayingTheTransferDelivery =>
      'يرجى التأكد من إدخال رقم الهاتف ورقم الواتساب والاسم الكامل بشكل صحيح لتجنب تأخير تسليم الحوالة';

  @override
  String get beforeConfirmingYourOrderYouShouldHaveADigitalWallet =>
      'قبل تأكيدك للحوالة يجب أن تمتلك محفظة عملات رقمية';

  @override
  String get clickHereToLearnHowToPay => 'اضغط هنا لمعرفة طريقة السداد';

  @override
  String get yourOrderHasBeenReceivedSuccessfully =>
      'لقد تم استلام طلبك بنجاح!';

  @override
  String get toCompleteTheTransferPleasePayTheDueAmount =>
      'لتنفيذ الحوالة يرجى تسديد المبلغ المستحق بالدولار الرقمي';

  @override
  String get toThisWalletAddress => 'الى عنوان المحفظة الآتية';

  @override
  String get onceThePaymentIsBeingConfirmedWeWillNotifyYouAndProcessTheTransferImmediately =>
      'بمجرد إتمامك التسديد سوف نعلمك بإستلامنا المبلغ, و نقوم بتنفيذ الحوالة مباشرة حسب شروط التسليم';

  @override
  String get pleaseMakeSureToPayTheExactAmountToTheWALLETInOneGoOtherwiseIfTheAmountPaidInMoreOrLessWeWillPayOutExactlyWhatWeReceivedOnSameExchangeRate =>
      'يرجى مراعاة تسديد المبلغ بالكامل إلى المحفظة وفي حال وصول مبلغ أقل أو أكثر سيتم تحويل قيمة المبلغ المستلم من قبلكم فقط و بنفس سعر الصرف المحدد للحوالة';

  @override
  String get yourSendingCountryIsCurrentlyDeactivated =>
      'بلد الإرسال الخاص بك معطل حالياً';

  @override
  String get didNotReceiveCode => 'لم تتلق الرمز؟';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get neW => 'حديثاً';

  @override
  String get processing => 'جاري المعالجة';

  @override
  String get processed => 'تم المعالجة';

  @override
  String get completed => 'تم التنفيذ';

  @override
  String get canceled => 'ملغى';

  @override
  String get providerFees => 'رسوم المزود';

  @override
  String get selectPickUpPoint => 'حدد نقطة الاستلام';

  @override
  String get nextStep => 'الخطوة التالية';

  @override
  String get previous => 'السابق';

  @override
  String get howToPay => 'كيفية دفع';

  @override
  String get walletAddress => 'عنوان المحفظة';

  @override
  String get walletAddressWillExpireWithin =>
      'ستنتهي صلاحية عنوان المحفظة خلال';

  @override
  String get oopsWalletAddressIsExpired =>
      'عفواً ... انتهت صلاحية عنوان المحفظة';

  @override
  String get recipientBankDetailsOptional => 'تفاصيل بنك المستلم (اختياري)';

  @override
  String get editRecipient => 'تعديل المستلم';

  @override
  String get paymentSuccessful => 'تم الدفع بنجاح';

  @override
  String get yourPaymentHasBeenSubmittedSuccessfully => 'تم إرسال دفعتك بنجاح';

  @override
  String get success => 'نجاح';

  @override
  String get confirmSendingOrder => 'تأكيد طلب الحوالة';

  @override
  String get weOnlyAcceptInUSDT =>
      'يتم تسديد الحوالة بواسطة العملة الرقمية المختارة';

  @override
  String get readOnly => 'قراءة فقط';

  @override
  String get transferId => 'رقم الحوالة';

  @override
  String get transactionNo => 'رقم الحوالة';

  @override
  String get transactionDate => 'تاريخ العملية';

  @override
  String get sentTo => 'مرسلة إلى';

  @override
  String get thankYouForUsingAmanaSendYouCanTrackTheTransactionProcessingOnTheTransfersPage =>
      'شكرا لاستخدامكم تطبيق أمانة، بإمكانكم تتبع معالجة وتنفيذ الحوالة في سجل الحوالات';

  @override
  String get trackTransfer => 'تتبع الحوالة';

  @override
  String get receiveTypeIsNotAvailableForThisCountry =>
      'نوع الاستلام غير متاح لهذا البلد';

  @override
  String get iAccept => 'أنا أقبل';

  @override
  String get noteAllRemittanceWillBeWithin48HoursExceptForPublicHolidays =>
      'ملحوظة: جميع التحويلات ستكون في غضون 48 ساعة، باستثناء أيام العطل الرسمية';

  @override
  String get pleaseReadOurTermsAndConditions =>
      'يرجى قراءة الشروط والأحكام الخاصة بنا';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get expireDate => 'تاريخ الانتهاء';

  @override
  String get cardHolderName => 'اسم حامل البطاقة';

  @override
  String get payByCard => 'الدفع بالبطاقة';

  @override
  String get payByCash => 'الدفع نقدا';

  @override
  String get cardDetails => 'معلومات البطاقة';

  @override
  String get noteWeAreNotResponsibleForAnyAdditionalFeesThatYourBankMayCharge =>
      'ملاحظة: نحن لسنا مسؤولين عن أي رسوم إضافية قد يفرضها البنك الذي تتعامل معه';

  @override
  String get expireDateStartsWithMonth => 'تاريخ انتهاء الصلاحية يبدأ بالشهر';

  @override
  String get payNow => 'ادفع الآن';

  @override
  String get chooseCountry => 'اختر الدولة';

  @override
  String get areYouSureYouWantToCancelThisTransfer =>
      'هل أنت متأكد أنك تريد إلغاء هذه الحوالة؟';

  @override
  String get pleaseSelectRecipient => 'الرجاء تحديد المستلم';

  @override
  String get to => 'إلى';

  @override
  String get from => 'من';

  @override
  String get error => 'خطأ';

  @override
  String get copy => 'نسخ';

  @override
  String get share => 'مشاركة';

  @override
  String get pleaseNoteThatThisWalletAddressIsJustForThisTransferPleaseDoNotUseItForAnotherTransfers =>
      'يرجى ملاحظة أن عنوان المحفظة مخصص لهذا التحويل فقط، يرجى عدم استخدامه لعمليات تحويل أخرى';

  @override
  String get paymentDetails => 'تفاصيل الدفع';

  @override
  String get oops => 'عفواً... حدث خطأ ما';

  @override
  String get copiedSuccessfully => 'تم النسخ بنجاح!';

  @override
  String get userNotFound => 'لم يتم العثور على المستخدم';

  @override
  String get hello => 'مرحباً';

  @override
  String get welcome => 'أهلاً بك';

  @override
  String get settings => 'إعدادات';

  @override
  String get onlyArabic => 'فقط حروف عربية';

  @override
  String get onlyLatin => 'فقط حروف لاتينية';

  @override
  String get enterValidEmail => 'أدخل عنوان بريد إلكتروني صالح';

  @override
  String get pleaseEnter => 'من فضلك ادخل';

  @override
  String get createNewAccount => 'إنشاء حساب جديد';

  @override
  String get logInToYourAccount => 'تسجيل الدخول إلى حسابك';

  @override
  String get password => 'كلمة السر';

  @override
  String get forgotPassword => 'نسيت كلمة السر؟';

  @override
  String get weWillSendResetPassword =>
      'سوف نرسل رمز إعادة تعيين كلمة المرور عبر رسالة نصية قصيرة إلى رقم هاتفك المحمول';

  @override
  String get verifyMobileNumber => 'تحقق من رقم الجوال';

  @override
  String get verifyEmail => 'تحقق من البريد الإلكتروني';

  @override
  String get savePassword => 'حفظ كلمة السر';

  @override
  String get resetPassword => 'إعادة تعيين كلمة السر';

  @override
  String get confirmPassword => 'تأكيد كلمة السر';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get logIn => 'تسجيل دخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب؟';

  @override
  String get registerNow => 'سجل الآن';

  @override
  String get firstName => 'الاسم';

  @override
  String get fatherName => 'اسم الأب';

  @override
  String get fatherNameOptional => 'اسم الأب (اختياري)';

  @override
  String get lastName => 'الكنية';

  @override
  String get passwordMustContainAtLeast8Characters =>
      'يجب أن تحتوي كلمة السر على 8 أحرف على الأقل!';

  @override
  String get passwordAndConfirmPasswordDoesNotMatch =>
      'كلمة السر وتأكيد كلمة السر غير متطابقتين!';

  @override
  String get send => 'إرسال';

  @override
  String get sendMoney => 'إرسال مال';

  @override
  String get deleteRecipient => 'حذف المستلم';

  @override
  String get areYouSureYouWantToDelete => 'هل انت متأكد انك تريد حذف';

  @override
  String get chooseRecipient => 'اختر المستلم';

  @override
  String get chooseRecipientToContinue => 'اختر المستلم للمتابعة';

  @override
  String get reviewAndCheckout => 'مراجعة والدفع';

  @override
  String get reviewYourTransferDetailsToContinueCheckout =>
      'قم بمراجعة تفاصيل التحويل الخاصة بك لمواصلة الدفع';

  @override
  String get payment => 'الدفع';

  @override
  String get enterDebitCreditCardToContinue => 'أدخل بطاقة الائتمان للمتابعة';

  @override
  String get somethingWentWrong => 'هناك خطأ ما';

  @override
  String get wrongLogin => 'معلومات تسجيل الدخول خاطئة';

  @override
  String get wrongPassword => 'كلمة السر خاطئة';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get attention => 'انتباه!';

  @override
  String get proceedWithLoggingOut => 'متابعة تسجيل الخروج؟';

  @override
  String get selectFromTheListBelow => 'حدد من القائمة ادناه';

  @override
  String get done => 'تم';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get ok => 'حسناً';

  @override
  String get pleaseAvoidStartingMobileNumberWithAZero =>
      'يرجى تجنب بدء رقم الجوال بصفر';

  @override
  String get systemTheme => 'سمة النظام';

  @override
  String get lightTheme => 'سمة النهار';

  @override
  String get darkTheme => 'سمة الليل';

  @override
  String get changeEmail => 'تغيير البريد الإلكتروني';

  @override
  String get changePassword => 'تغيير كلمة السر';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get youSend => 'انت ترسل';

  @override
  String get sendingRate => 'سعر الصرف';

  @override
  String get fee => 'الرسوم';

  @override
  String get reviewSendingInfo => 'مراجعة معلومات الإرسال';

  @override
  String get recipientName => 'اسم المستلم';

  @override
  String get recipient => 'المستلم';

  @override
  String get totalToPay => 'مجموع الدفع';

  @override
  String get receiverGets => 'يحصل المستلم';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get selectReceiveType => 'حدد نوع الاستلام';

  @override
  String get receiveType => 'نوع الاستلام';

  @override
  String get cashPickUp => 'قبض نقدياً';

  @override
  String get total => 'المجموع';

  @override
  String get addRecipient => 'أضف مستلم';

  @override
  String get addNewRecipient => 'أضف مستلم جديد';

  @override
  String get myRecipients => 'المستلمون';

  @override
  String get recipientsList => 'قائمة المستلمين';

  @override
  String get recipientNameEnglish => 'اسم المستلم (إنجليزي)*';

  @override
  String get recipientNameEnglishOptional => 'اسم المستلم (إنجليزي) / اختياري';

  @override
  String get recipientNameArabic => 'اسم المستلم (عربي)*';

  @override
  String get recipientNameArabicOptional => 'اسم المستلم (عربي) / اختياري';

  @override
  String get relation => 'القرابة *';

  @override
  String get youHaveExceededTheMaximumSendingAmountThisMonth =>
      'لقد تجاوزت الحد الأعلى لمبلغ الإرسال هذا الشهر';

  @override
  String get country => 'البلد';

  @override
  String get yourMaxSendingAmountWithin =>
      'الحد الأعلى لمبلغ الإرسال الخاص بك خلال';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get day => 'يوم';

  @override
  String get iS => 'هو';

  @override
  String get captchaVerificationFailed => 'فشل التحقق';

  @override
  String get ifYourIDHasTwoSidesSuchAs => 'إذا كان المستند يحتوي على وجهين مثل';

  @override
  String get drivingLicense => 'رخصة القيادة';

  @override
  String get or => 'أو';

  @override
  String get residentPermit => 'تصريح الإقامة';

  @override
  String get please => 'فيرجى';

  @override
  String get upload => 'تحميل';

  @override
  String get backside => 'الجانب الخلفي';

  @override
  String get inTheOtherDocumentsSectionBelowOnThisPageOtherwiseYourAccountWillBeRejected =>
      'في قسم (المستندات الأخرى) الموجود في أسفل هذه الصفحة، وإلا فسيتم رفض حسابك';

  @override
  String get receipt => 'فاتورة';

  @override
  String get ticket => 'إشعار';

  @override
  String get pleaseSelectReceiveType => 'الرجاء تحديد نوع الاستلام';

  @override
  String get enterAccountHolderName => 'أدخل اسم صاحب الحساب';

  @override
  String get enterRecipientArabicName => 'أدخل اسم المستلم باللغة العربية';

  @override
  String get enterRecipientName => 'أدخل اسم المستلم';

  @override
  String get countries => 'الدول';

  @override
  String get cities => 'المدن';

  @override
  String get fullAddress => 'العنوان الكامل';

  @override
  String get provider => 'المزود';

  @override
  String get accountNumber => 'رقم الحساب';

  @override
  String get bankName => 'اسم البنك';

  @override
  String get recipientBankInfoIsMissingPleaseEditRecipientByAddingBankAccountDetails =>
      'معلومات بنك المستلم مفقودة ، يرجى تحرير المستلم بإضافة تفاصيل الحساب المصرفي';

  @override
  String get selectCity => 'حدد المدينة';

  @override
  String get typeOfCurrency => 'نوع العملة';

  @override
  String get chooseCurrency => 'اختر العملة الرقمية';

  @override
  String get pleaseChooseCurrency => 'اختر العملة الرقمية للدفع';

  @override
  String get selectCountry => 'حدد البلد';

  @override
  String get selectCountryPhoneCodeFromTheListBelow =>
      'حدد رمز هاتف الدولة من القائمة أدناه';

  @override
  String get selectCityFromTheListBelow => 'حدد المدينة من القائمة أدناه';

  @override
  String get areaOptionalEXStreetName => 'المنطقة (اختياري) مثال: اسم الشارع';

  @override
  String get pickUpPointsReadOnly => 'نقاط الاستلام (للقراءة فقط)';

  @override
  String get pickUpPoint => 'نقطة الاستلام';

  @override
  String get contactDetails => 'معلومات التواصل *';

  @override
  String get relativeRelation => 'صلة القرابة';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get countryCity => 'البلد/المدينة';

  @override
  String get sendCountries => 'دول الإرسال';

  @override
  String get receiverCountries => 'دول الاستلام';

  @override
  String get attentionWhenMakingThePayment => 'يرجى الإنتباه عند السداد:';

  @override
  String get makeSureToEnterTheWalletAddressCorrectly =>
      'تأكد من إدخال عنوان المحفظة بشكل كامل و صحيح و استخدام شبكة';

  @override
  String get polygonNetworkOnly =>
      'حصراً, علماً أن أي خطأ أو استخدام أي شبكة أخرى سيؤدي إلى خسارة أموالك نهائياً و لا تعتبر حوالتك مسددة.';

  @override
  String get pleaseEnterSendingAmount => 'الرجاء إدخال مبلغ الإرسال';

  @override
  String get minimumReceivingLimitToThisPickUpPointIs =>
      'الحد الأدنى للاستلام إلى نقطة التسليم هذه هو';

  @override
  String get maximumReceivingLimitToThisPickUpPointIs =>
      'الحد الأعلى للاستلام إلى نقطة التسليم هذه هو';

  @override
  String get useThisUniqueWalletAddressForOneTimeAndForThisTransferOnly =>
      'هذه المحفظة خاصة بهذا التحويل فقط, وتستخدم لمرة واحدة فقط';

  @override
  String get walletNetwork => 'عند الدفع اختر الشبكة';

  @override
  String get pleasePayWithinAMaximumPeriod => 'يرجى السداد خلال مدة أقصاها';

  @override
  String get timeLimitToPay => 'يجب السداد خلال مدة أقصاها';

  @override
  String get ifThePaymentHasNotBeenDoneInCertainTimeItIsNoLongerPossibleToUseThisWalletAndTheOrderWillBeCanceled =>
      'في حال عدم السداد وإنتهاء المدة, لا يمكن استخدام المحفظة و ستيم إلغاء طلب الحوالة.';

  @override
  String get yourMaxLevelSendingAmountIs =>
      'الحد الأعلى لمبلغ الإرسال الخاص بك هو';

  @override
  String get toIncreaseYourMaxLevelAmountKindlyVerifyYourAccount =>
      'لزيادة الحد الأعلى لمبلغ الإرسال الخاص بك، يرجى ترقية الحساب';

  @override
  String get selectTheCountryYouWantToTransferTo =>
      'حدد البلد المطلوب التحويل إليها';

  @override
  String get selectTheReceivingCity => 'حدد مدينة الاستلام';

  @override
  String get knowTheCurrentExchangeRateAndChooseYourPreferredAgent =>
      'أعرف سعر الصرف الحالي واختر وكيل التسليم المفضل إليك';

  @override
  String get enterTheAmountYouWantToTransferInTheUSDTWhichIsEqualToTheValueOfTheUSDollar =>
      'ادخل المبلغ الذي ترغب بتحويله بالدولار الرقميUSDT والذي يساوي بقيمته الدولار الأميريكي \$';

  @override
  String get theAmountRequiredToBeTransferredInYourLocalCurrencyIsApproximatelyBasedOnTheCurrentExchangeRate =>
      'قيمة المبلغ المطلوب تحويله بعملتك المحلية بشكل تقريبي حسب سعر الصرف الحالي';

  @override
  String
      get theAmountTheRecipientWillReceiveDependsOnTheExchangeRateOfTheSelectedAgent =>
          'المبلغ الذي سيحصل عليه المستلم حسب سعر الصرف للوكيل المحدد';

  @override
  String
      get afterCompletingTheTransferInformationClickHereToSpecifyTheNameOfTheRecipientAndPayTheAmount =>
          'بعد إتمام معلومات التحويل اضغط هنا لتحديد اسم المستلم و سداد المبلغ';

  @override
  String get cameraPermission => 'إذن الكاميرا';

  @override
  String get pleaseAllowAppToAccessCamera =>
      'يرجى السماح للتطبيق بالوصول إلى الكاميرا';

  @override
  String get skip => 'تخطي';

  @override
  String get takeThePhotoWithinTheFrame => 'قم بالتصوير داخل الإطار';

  @override
  String get minute => 'دقيقة';

  @override
  String get area => 'المنطقة';

  @override
  String get clickOnTheFocusedBoxToContinue =>
      'انقر على المستطيل المحدد للمتابعة';

  @override
  String get noNewChangesInTheFieldsToSave =>
      'لا توجد تغييرات جديدة في الحقول للحفظ';

  @override
  String get selectCurrency => 'اختر العملة';

  @override
  String get selectReceiveCurrencyForThisCountry =>
      'حدد عملة الاستلام لهذا البلد';

  @override
  String get usdIsNotAvailableForThisCountry =>
      'الدولار الأمريكي غير متوفر لهذا البلد';

  @override
  String get usdDollar => 'USD (دولار أمريكي)';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get notifications => 'إشعارات';

  @override
  String get verification => 'تَحَقّق';

  @override
  String get enterOTPcodeSentToTheNumber => 'أدخل رمز التحقق المرسل إلى الرقم';

  @override
  String get enterOTPcodeSentToTheEmail =>
      'أدخل رمز التحقق المرسل إلى البريد الإلكتروني';

  @override
  String get enterOTPVerificationCodeToResetYourPassword =>
      'أدخل رمز التحقق لإعادة تعيين كلمة المرور الخاصة بك';

  @override
  String get codeSuccessfullySentKindlyWait =>
      'تم إرسال الرمز بنجاح، يرجى الانتظار';

  @override
  String get youCanRequestAnotherOTPagainWithin =>
      'يمكنك طلب الرمز مرة أخرى خلال';

  @override
  String get resendCode => 'أعد إرسال الرمز';

  @override
  String get validate => 'تحقق';

  @override
  String get newPasswordMustContainAtLeastEightLetters =>
      'يجب أن تحتوي كلمة المرور الجديدة على ثمانية أحرف على الأقل!';

  @override
  String get newPasswordAndConfirmPasswordDoesNotMatch =>
      'كلمة السر الجديدة وتأكيد كلمة السر غير متطابقين!';

  @override
  String get enterCode => 'ادخل الرمز';

  @override
  String get recipientCountryUnavailableAtTheMoment =>
      'بلد المستلم غير متوفر في الوقت الحالي';

  @override
  String get passwordSuccessfullyChangedPleaseLoginToContinue =>
      'تم تغيير كلمة السر بنجاح، يرجى تسجيل الدخول للمتابعة';

  @override
  String get pleaseloginToContinue => 'الرجاء تسجيل الدخول ';

  @override
  String get incorrectPassword => 'كلمة السر خاطئة';

  @override
  String get newPasswordCannotBeTheSameAsTheCurrentPassword =>
      'لا يمكن أن تكون كلمة السر الجديدة هي نفسها كلمة السر الحالية';

  @override
  String get recipientHasBeenDeletedSuccessfully => 'تم حذف المستلم بنجاح';

  @override
  String get accountHasBeenDeletedSuccessfully => 'تم حذف الحساب بنجاح';

  @override
  String get invalidMobileNumber => 'رقم الجوال غير صالح';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get wrongEmail => 'بريد إلكتروني خاطئ';

  @override
  String get mobileAlreadyExist => 'رقم الجوال موجود مسبقاً';

  @override
  String get emailAlreadyExist => 'البريد الالكتروني موجود مسبقاً';

  @override
  String get accountDeactivated => 'الحساب معطل';

  @override
  String get youHaveTriedThreeWrongAttemptsYouCanTryAgainNext24h =>
      'لقد حاولت ثلاث محاولات خاطئة. يمكنك المحاولة مرة أخرى خلال24 ساعة القادمة';

  @override
  String get iDExpireDateAlreadyExpired => 'بطاقة الهوية انتهت بالفعل';

  @override
  String get iDIssuedDateIsInvalid => 'تاريخ إصدار الهوية غير صحيح';

  @override
  String get accountIsUnderReview => 'الحساب قيد المراجعة';

  @override
  String get accountIsAlreadyVerified => 'تم التحقق من الحساب بالفعل';

  @override
  String get mobileWallet => 'محفظة الجوال';

  @override
  String get bankTransfer => 'حوالة بنكية';

  @override
  String get startSendingMoney => 'ابدأ بإرسال الأموال';

  @override
  String get pressBackAgainToExit => 'اضغط مرة أخرى للخروج';

  @override
  String get sent => 'مرسل';

  @override
  String get youAskedToSend => 'أنت طلبت إرسال';

  @override
  String get youSent => 'انت ارسلت';

  @override
  String get exchangeRate => 'سعر الصرف';

  @override
  String get editProfile => 'تعديل الحساب';

  @override
  String get language => 'اللغة';

  @override
  String get themeMode => 'وضع السمة';

  @override
  String get contactSupportTeam => 'اتصل بفريق الدعم';

  @override
  String get inviteFriends => 'ادعُ الأصدقاء';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get currentPassword => 'كلمة السر الحالية';

  @override
  String get newPassword => 'كلمة السر الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة السر الجديدة';

  @override
  String get deleteMyAccount => 'حذف حسابي';

  @override
  String get mainInformation => 'المعلومات الرئيسية';

  @override
  String get firstNameFatherNameLastName =>
      'الاسم الأول - اسم الأب - اسم العائلة';

  @override
  String get address => 'العنوان *';

  @override
  String get enterCity => 'أدخل المدينة';

  @override
  String get enterFullName => 'ادخل الاسم الكامل';

  @override
  String get city => 'المدينة';

  @override
  String get back => 'رجوع';

  @override
  String get fullName => 'الاسم الكامل *';

  @override
  String get enterPostCode => 'أدخل الرمز البريدي';

  @override
  String get enterStreet => 'أدخل الشارع';

  @override
  String get enterHouseNumber => 'أدخل رقم المنزل';

  @override
  String get pleaseUploadProofOfAddress => 'يرجى رفع إثبات العنوان';

  @override
  String get enterIdentityNumber => 'أدخل رقم الهوية';

  @override
  String get pleaseUploadIdentityImage => 'يرجى رفع صورة الهوية';

  @override
  String get pleaseUploadSelfie => 'يرجى رفع صورة شخصية';

  @override
  String get updateRequired => 'التحديث مطلوب للمتابعة';

  @override
  String get newVersionIsAvailable => 'إصدار جديد متاح للتحديث';

  @override
  String
      get thereIsANewVersionAvailableToDownloadPleaseUpdateAmanaSendToContinue =>
          'هناك إصدار جديد متاح للتنزيل! يرجى تحديث تطبيق امانة للمتابعة';

  @override
  String get updateAmanaSend => 'تحديث تطبيق امانة';

  @override
  String get postCode => 'الرمز البريدي';

  @override
  String get street => 'الشارع';

  @override
  String get buildingOptional => 'المبنى (اختياري)';

  @override
  String get houseNumber => 'رقم المنزل';

  @override
  String get proofOfAddress => 'إثبات العنوان';

  @override
  String get documentProvingYourPlaceOfResidenceWithYourAddressWrittenOnItSuchAsUtilityBillLeaseContractResidencePermit =>
      'وثيقة تثبت مكان إقامتك مع عنوانك المكتوب عليها، مثل (فاتورة خدمات / عقد إيجار / تصريح إقامة)';

  @override
  String get birthday => 'تاريخ الميلاد *';

  @override
  String get selectBirthdayDate => 'حدد تاريخ الميلاد';

  @override
  String get identity => 'الهوية *';

  @override
  String get privacyPolicyAndPersonalDataProtection =>
      'سياسة الخصوصية وحماية البيانات الشخصية';

  @override
  String get inOrderToBeAbleToUseOurServicesWeMustVerifyYourIdentityUploadClearCopyOfIdentificationCardAndProofOfResidenceAddressInAdditionToTakeSelfieWithoutHatOrSunglassesOnTheEye =>
      'لكي نتمكن من استخدام خدماتنا، يجب علينا التحقق من هويتك. قم بتحميل نسخة واضحة من بطاقة الهوية وإثبات عنوان الإقامة، بالإضافة إلى التقاط صورة سيلفي بدون قبعة أو نظارة شمسية على العين.';

  @override
  String get identityNumber => 'رقم الهوية';

  @override
  String get issuedDate => 'تاريخ الإصدار';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get uploadClearCopyOfIdentityDocumentSuchAsPassportDrivingLicenseResidencePermit =>
      'قم بتحميل نسخة واضحة من وثيقة الهوية مثل جواز السفر - رخصة القيادة - تصريح الإقامة';

  @override
  String get fullNameArabic => 'الاسم الكامل (عربي)';

  @override
  String get enterFullAddress => 'ادخل العنوان الكامل';

  @override
  String get selfie => 'صورة شخصية *';

  @override
  String get takeSelfie => 'التقط صورة شخصية';

  @override
  String get takeSelfieWithoutHatOrSunglassesOnTheEyeToCompareYourPhotoOnTheIdentificationDocument =>
      'التقط صورة سيلفي بدون قبعة أو نظارة شمسية على العين لمقارنة صورتك في وثيقة الهوية';

  @override
  String get otherDocuments => 'المستندات الأخرى';

  @override
  String get noteYourTransferLimitWillIncreaseIfYouProvideSecondID =>
      'ملاحظة: سيتم زيادة حد التحويل الخاص بك إذا قدمت معرفاً ثانياً.';

  @override
  String get uploadDocumentImage => 'تحميل صورة الوثيقة';

  @override
  String get changeImage => 'تغيير الصورة';

  @override
  String get uploadImage => 'رفع صورة';

  @override
  String get submit => 'إرسال';

  @override
  String get sendingAmount => 'مبلغ التحويل';

  @override
  String get estimatedValueInLocalCurrency =>
      'القيمة التقريبية بالعملة المحلية';

  @override
  String get currenciesExchangeRate => 'سعر صرف العملات';

  @override
  String get providerIsInactiveForTheReceivingCity =>
      'الموفر غير نشط للمدينة المستقبلة';

  @override
  String get oncePaymentHasBeenConfirmedInOurSystemYouWillGetNotifiedAndTheTransactionWillStartToProcessedWithin24hours =>
      'بمجرد تأكيد الدفع في نظامنا، سيتم إعلامك وستبدأ معالجة المعاملة خلال 24 ساعة';

  @override
  String get areYouSureYouWantToDeleteYourAccount =>
      'هل انت متأكد انك تريد حذف حسابك!؟';

  @override
  String get support => 'الدعم';

  @override
  String get cannotSendThisTransferDueToRecipientDetailsHasBeenModifiedOrDeleteKindlyMakeNewTransfer =>
      'لا يمكن إرسال هذه الحوالة بسبب تعديل أو حذف معلومات المستلم، يرجى إرسال حوالة جديدة';

  @override
  String get amanaSendSupportTeam => 'فريق دعم تطبيق امانة';

  @override
  String get dearValuedCustomerAmanaSendSupportTeamIsHereToHelpYouPleaseFeelFreeToContactUsViaTheFollowing =>
      'عزيزي العميل، فريق دعم تطبيق امانة هنا لمساعدتك، لا تتردد في الاتصال بنا عبر ما يلي:';

  @override
  String get enterMobileNumber => 'ادخل رقم الجوال';

  @override
  String get website => 'الموقع الإلكتروني';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get instagram => 'انستغرام';

  @override
  String get whatsApp => 'واتساب';

  @override
  String get map => 'الخريطة';

  @override
  String get rate => 'تقييم';

  @override
  String get wouldYouLikeToRateOurApp => 'هل ترغب في تقييم تطبيقنا؟';

  @override
  String get thankYouForUsingAmanaSend => 'شكرا لك على استخدام تطبيق امانة';

  @override
  String get workingHours => 'ساعات العمل';

  @override
  String get mondayToFriday => 'من الإثنين إلى الجمعة';

  @override
  String get mondayToSaturday => 'من الإثنين إلى السبت';

  @override
  String get saturdayAndSunday => 'السبت والأحد';

  @override
  String get sunday => 'الأحد';

  @override
  String get dispute => 'خلاف';

  @override
  String get telegram => 'تلغرام';

  @override
  String get verifyAccount => 'التحقق من الحساب';

  @override
  String get verificationInProcess => 'التحقق قيد المعالجة';

  @override
  String get verificationCodeWhatsApp => 'سيتم إرسال كود التحقق عبر الواتساب';

  @override
  String get accountVerificationInProcessOnceAccountIsVerifiedYouWillBeAbleToTransferMoneyWorldwide =>
      'التحقق من الحساب قيد المعالجة، بمجرد التحقق من الحساب، ستتمكن من تحويل الأموال حول العالم';

  @override
  String get toEnsureThatYouCanSendMoneyWorldwidePleaseVerifyYourAccount =>
      'للتأكد من أنه يمكنك إرسال الأموال إلى جميع أنحاء العالم، يرجى التحقق من حسابك.';

  @override
  String get pleasePayTheBalanceForThisTransactionWithin3DaysAtYourNearestApprovedCashPaymentAddress =>
      'الرجاء القيام بدفع مبلغ التحويل في اقرب مركز للدفع معتمد لدى شركتنا خلال ثلاث ايام من تاريخ التحويل.';

  @override
  String get verified => 'تم التحقق';

  @override
  String get verifiedAccount => 'حساب موثّق';

  @override
  String get verificationFailed => 'فشل التحقق';

  @override
  String get amountWeWillConvert => 'المبلغ الذي سنقوم بتحويله';

  @override
  String get totalPaid => 'إجمالي المبلغ المدفوع';

  @override
  String get recipientGets => 'يحصل المستلم';

  @override
  String get closed => 'مغلق';

  @override
  String get close => 'أغلق';

  @override
  String get search => 'بحث';

  @override
  String get firstNameOne => 'الاسم (عربي)';

  @override
  String get lastNameOne => 'الكنية (عربي)';

  @override
  String get fatherNameOne => 'اسم الأب (عربي)';

  @override
  String get notes => 'ملاحظات';

  @override
  String get english => 'انكليزي';

  @override
  String get optional => 'اختياري';

  @override
  String get suggestionsAndComplaints => 'الاقتراحات والشكاوى';

  @override
  String get chooseTheCity => 'اختر المدينة';

  @override
  String get pleaseChooseTheCity => 'الرجاء اختر المدينة';
}
