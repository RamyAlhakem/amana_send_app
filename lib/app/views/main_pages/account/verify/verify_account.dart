import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/account/verify/components/date_pick.dart';
import '/app/views/main_pages/account/verify/components/multiple_image_pick.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/general/general_widgets.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';
import '/database/injector.dart';
import '/graphql/api/verify_account.dart';
import '/helper/helper.dart';
import '/models/user.dart';
import '/services/lang_service.dart';
import 'components/image_pick.dart';

class VerifyAccount extends StatefulWidget {
  const VerifyAccount({super.key});

  @override
  State<VerifyAccount> createState() => VerifyAccountState();
}

class VerifyAccountState extends State<VerifyAccount> {
  late AppLocalizations? _arb;

  late final UserModel user;

  late final TextEditingController _fullName, _city, _postCode, _street;
  late final TextEditingController _building, _houseNumber, _identityNumber;
  int? mainIdPicId, addressPicId, selfiePicId;
  List<int?> filesIds = <int?>[];

  late DateTime _birthday, _issuedDate, _expireDate;

  // Previously submitted attachments is stored below, from server on [initState].
  String mainIdPic = '', addressPic = '', selfiePic = '';
  List<String> savedAttachments = <String>[]; // Optional attachments

  LoadingButtonController buttonCtrl = LoadingButtonController();

  @override
  void initState() {
    super.initState();
    user = Database().getUser;

    _fullName = TextEditingController(text: user.fullName);
    _city = TextEditingController(text: user.city);
    _postCode = TextEditingController(text: user.postCode);
    _street = TextEditingController(text: user.street);
    _building = TextEditingController(text: user.building);
    _houseNumber = TextEditingController(text: user.flat);
    _identityNumber = TextEditingController(text: user.idNumber);
    _birthday = DateTime.parse(user.birthday);
    _issuedDate = DateTime.parse(user.idIssuedDate);
    _expireDate = DateTime.parse(user.idExpireDate);

    if (user.mainIdPic.isNotEmpty) mainIdPic = user.mainIdPic;
    if (user.selfiePic.isNotEmpty) selfiePic = user.selfiePic;
    if (user.addressPic.isNotEmpty) addressPic = user.addressPic;

    if (user.doc1.isNotEmpty) savedAttachments.add(user.doc1);
    if (user.doc2.isNotEmpty) savedAttachments.add(user.doc3);
    if (user.doc3.isNotEmpty) savedAttachments.add(user.doc3);
    if (user.doc4.isNotEmpty) savedAttachments.add(user.doc4);
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _fullName.dispose();
    _city.dispose();
    _postCode.dispose();
    _street.dispose();
    _building.dispose();
    _houseNumber.dispose();
    _identityNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.unFocusCursor(context),
      child: Scaffold(
        appBar: AutoAppBar(
          title: _arb!.verifyAccount,
          bGColor: Theme.of(context).cardColor,
        ),
        body: ListView(
          addAutomaticKeepAlives: true,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 40),
          children: [
            TextX(
              _arb!.fullName,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextFieldX(
              controller: _fullName,
              hint: _arb!.firstNameFatherNameLastName,
              type: TextInputType.name,
              onChanged: (v) => TextFieldValidator.latin(context, _fullName),
            ),
            const SizedBox(height: 8),
            TextX(
              _arb!.address,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Row(
              children: [
                TextFieldX(
                  controller: _city,
                  hint: _arb!.city,
                  type: TextInputType.name,
                  width: 0.6,
                  onChanged: (v) => TextFieldValidator.latin(context, _city),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFieldX(
                    controller: _postCode,
                    hint: _arb!.postCode,
                    type: TextInputType.streetAddress,
                    onChanged: (v) =>
                        TextFieldValidator.latin(context, _postCode),
                  ),
                ),
              ],
            ),
            TextFieldX(
              controller: _street,
              hint: _arb!.street,
              type: TextInputType.streetAddress,
              onChanged: (v) => TextFieldValidator.latin(context, _street),
            ),
            Row(
              children: [
                TextFieldX(
                  controller: _building,
                  hint: _arb!.buildingOptional,
                  type: TextInputType.name,
                  width: 0.45,
                  onChanged: (v) =>
                      TextFieldValidator.latin(context, _building),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFieldX(
                    controller: _houseNumber,
                    hint: _arb!.houseNumber,
                    type: TextInputType.name,
                    onChanged: (v) =>
                        TextFieldValidator.latin(context, _houseNumber),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextX(
              _arb!.proofOfAddress,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextX(
              _arb!
                  .documentProvingYourPlaceOfResidenceWithYourAddressWrittenOnItSuchAsUtilityBillLeaseContractResidencePermit,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 5),

            // Proof of address
            ImagePick(
              url: addressPic,
              onChange: (id) => addressPicId = id,
            ),

            const SizedBox(height: 15),
            TextX(
              _arb!.birthday,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 10),
            DatePick(
              _birthday,
              _arb!.selectBirthdayDate,
              (DateTime value) => setState(() {
                _birthday = value;
              }),
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 15),
            TextX(
              _arb!.identity1,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            Container(
              decoration: Decorations.main(
                context,
                color: Theme.of(context).dividerColor,
                shadowColor: Colors.transparent,
              ),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: TextX(
                _arb!
                    .inOrderToBeAbleToUseOurServicesWeMustVerifyYourIdentityUploadClearCopyOfIdentificationCardAndProofOfResidenceAddressInAdditionToTakeSelfieWithoutHatOrSunglassesOnTheEye,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 4),

            // Privacy policy.
            GeneralWidgets.privacyPolicy(context),

            const SizedBox(height: 4),
            TextFieldX(
              controller: _identityNumber,
              hint: _arb!.identityNumber,
              onChanged: (v) =>
                  TextFieldValidator.latin(context, _identityNumber),
            ),
            Row(
              children: [
                DatePick(
                  _issuedDate,
                  _arb!.issuedDate,
                  (DateTime value) => setState(() => _issuedDate = value),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DatePick(
                    _expireDate,
                    _arb!.expiryDate,
                    (DateTime value) => setState(() => _expireDate = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextX(
              _arb!
                  .uploadClearCopyOfIdentityDocumentSuchAsPassportDrivingLicenseResidencePermit,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),

            Container(
              decoration: Decorations.main(
                context,
                color: Theme.of(context).dividerColor,
                shadowColor: Colors.transparent,
              ),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Text.rich(
                textScaleFactor: 1.0,
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '${_arb!.ifYourIDHasTwoSidesSuchAs} ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: _arb!.drivingLicense,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: ' ${_arb!.or} ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: _arb!.residentPermit,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: ' ${_arb!.please} ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: _arb!.upload.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: LangService.isAR() ? ' ' : ' the ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: _arb!.backside.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: MainColors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text:
                          ' ${_arb!.inTheOtherDocumentsSectionBelowOnThisPageOtherwiseYourAccountWillBeRejected}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Identity image
            ImagePick(
              url: mainIdPic,
              onChange: (id) => mainIdPicId = id,
            ),

            const SizedBox(height: 20),
            TextX(
              _arb!.takeSelfie,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            TextX(
              _arb!
                  .takeSelfieWithoutHatOrSunglassesOnTheEyeToCompareYourPhotoOnTheIdentificationDocument,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),

            // Take a selfie
            ImagePick(
              url: selfiePic,
              title: _arb!.takeSelfie,
              source: ImageSource.camera,
              asset: 'assets/images/selfie_icon.png',
              preferredCamera: CameraDevice.front,
              onChange: (id) => selfiePicId = id,
            ),

            const SizedBox(height: 15),
            TextX(
              _arb!.otherDocuments,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            Container(
              decoration: Decorations.main(
                context,
                color: Theme.of(context).dividerColor,
                shadowColor: Colors.transparent,
              ),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: TextX(
                _arb!.noteYourTransferLimitWillIncreaseIfYouProvideSecondID,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8),

            // Other documents
            MultipleImagePick(
              urls: savedAttachments,
              onChange: (id) {
                if (filesIds.contains(id)) {
                  filesIds.remove(id);
                } else {
                  filesIds.add(id);
                }
              },
            ),

            Container(
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              child: RoundedLoadingButton(
                controller: buttonCtrl,
                width: MediaQuery.of(context).size.width,
                animateOnTap: false,
                onPressed: () => VerifyAccountAPI(
                  context,
                  buttonCtrl,
                  fullName: _fullName.text,
                  city: _city.text,
                  postCode: _postCode.text,
                  street: _street.text,
                  building: _building.text,
                  flat: _houseNumber.text,
                  addressPicId: addressPicId,
                  birthday: '$_birthday'.substring(0, 10),
                  idNumber: _identityNumber.text,
                  idIssuedDate: '$_issuedDate'.substring(0, 10),
                  idExpireDate: '$_expireDate'.substring(0, 10),
                  mainIdPicId: mainIdPicId,
                  selfiePicId: selfiePicId,
                ).request(),
                child: TextX(
                  _arb!.submit,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
