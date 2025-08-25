import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';

import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/loading_button.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/text_form_field/text_form.dart';
import '/app/widgets/text_form_field/tools/text_form_validator.dart';
import '/database/injector.dart';
import '/graphql/api/verify_account.dart';
import '/helper/helper.dart';
import '/models/user.dart';
import 'components/image_pick.dart';

class VerifyAccount extends StatefulWidget {
  const VerifyAccount({super.key});

  @override
  State<VerifyAccount> createState() => VerifyAccountState();
}

class VerifyAccountState extends State<VerifyAccount> {
  late AppLocalizations arb;
  late final UserModel user;
  late final TextEditingController _arFirstName, _arFatherName, _arLastName;
  late final TextEditingController _fullAddress, _city, _postCode;

  int? mainIdPicId, selfiePicId;

  // Previously submitted attachments is stored below, from server on [initState].
  String mainIdPic = '', selfiePic = '';

  LoadingButtonController buttonCtrl = LoadingButtonController();

  @override
  void initState() {
    super.initState();
    user = Database().getUser;

    _arFirstName = TextEditingController(text: user.arFirstName);
    _arFatherName = TextEditingController(text: user.arFatherName);
    _arLastName = TextEditingController(text: user.arLastName);
    _fullAddress = TextEditingController(text: user.fullAddress);
    _city = TextEditingController(text: user.city);
    _postCode = TextEditingController(text: user.postCode);

    if (user.mainIdPic.isNotEmpty) mainIdPic = user.mainIdPic;
    if (user.selfiePic.isNotEmpty) selfiePic = user.selfiePic;
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _fullAddress.dispose();
    _postCode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.unFocusCursor(context),
      child: Scaffold(
        appBar: AutoAppBar(
          title: arb.verifyAccount,
          bGColor: Theme.of(context).cardColor,
        ),
        body: ListView(
          addAutomaticKeepAlives: true,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 40),
          children: [
            TextX(
              '${arb.fullNameArabic} *',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Row(children: [
              Expanded(
                child: TextFieldX(
                  controller: _arFirstName,
                  hint: arb.firstName,
                  type: TextInputType.name,
                  filled: true,
                  onChanged: (v) =>
                      TextFieldValidator.arabic(context, _arFirstName),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextFieldX(
                  controller: _arLastName,
                  hint: arb.lastName,
                  type: TextInputType.name,
                  filled: true,
                  onChanged: (v) =>
                      TextFieldValidator.arabic(context, _arLastName),
                ),
              ),
            ]),
            TextFieldX(
              controller: _arFatherName,
              hint: arb.fatherName,
              type: TextInputType.name,
              filled: true,
              onChanged: (v) =>
                  TextFieldValidator.arabic(context, _arFatherName),
            ),
            const HDivider(height: 20),
            TextX(
              arb.address,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: TextFieldX(
                    controller: _city,
                    hint: arb.city,
                    type: TextInputType.streetAddress,
                    filled: true,
                  ),
                ),
                const SizedBox(width: 14),
                Flexible(
                  child: TextFieldX(
                    controller: _postCode,
                    hint: arb.postCode,
                    type: TextInputType.streetAddress,
                    filled: true,
                  ),
                ),
              ],
            ),
            TextFieldX(
              controller: _fullAddress,
              hint: arb.fullAddress,
              type: TextInputType.name,
              filled: true,
            ),
            const HDivider(height: 20),

            TextX(
              arb.identity,
              style: Theme.of(context).textTheme.labelMedium,
            ),

            const SizedBox(height: 4),
            TextX(
              arb.uploadClearCopyOfIdentityDocumentSuchAsPassportDrivingLicenseResidencePermit,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),

            // Identity image
            ImagePick(
              url: mainIdPic,
              onChange: (id) => mainIdPicId = id,
            ),

            const SizedBox(height: 20),
            TextX(
              arb.selfie,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            TextX(
              arb.takeSelfieWithoutHatOrSunglassesOnTheEyeToCompareYourPhotoOnTheIdentificationDocument,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),

            // Take a selfie
            ImagePick(
              url: selfiePic,
              title: arb.takeSelfie,
              asset: 'assets/images/selfie_icon.png',
              direction: 'front',
              onChange: (id) => selfiePicId = id,
            ),

            Container(
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              child: RoundedLoadingButton(
                controller: buttonCtrl,
                width: MediaQuery.of(context).size.width,
                animateOnTap: false,
                onPressed: () => VerifyAccountAPI(
                  buttonCtrl,
                  arFirstName: _arFirstName.text,
                  arFatherName: _arFatherName.text,
                  arLastName: _arLastName.text,
                  city: _city.text,
                  postCode: _postCode.text,
                  fullAddress: _fullAddress.text,
                  mainIdPicId: mainIdPicId,
                  selfiePicId: selfiePicId,
                ).request(),
                child: TextX(
                  arb.submit,
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
