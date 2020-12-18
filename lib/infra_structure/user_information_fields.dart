
import 'package:microsoft_authentication/infra_structure/selenium_constats.dart';
import 'package:microsoft_authentication/lab_api/federation_provider.dart';
import 'package:microsoft_authentication/lab_api/lab/lab_constants.dart';
import 'package:microsoft_authentication/lab_api/user/user_model.dart';

import 'package:microsoft_authentication/test/DeviceCodeIT.dart';


class UserInformationFields {
  final User user;
  String passwordInputId;
  String passwordSigInButtonId;

  UserInformationFields(this.user);


  String getPasswordInputId()
  {
    if (Strings.isNullOrEmpty(passwordInputId)) {
      determineFieldIds();
    }
    return passwordInputId;
  }

  String getPasswordSigInButtonId()
  {
    if (Strings.isNullOrEmpty(passwordSigInButtonId)) {
      determineFieldIds();
    }
    return passwordSigInButtonId;
  }

  String getAadSignInButtonId()
  {
    return SeleniumConstants.WEB_SUBMIT_ID;
  }

  String getAadUserNameInputId()
  {
    return SeleniumConstants.WEB_UPN_INPUT_ID;
  }

  String getADFS2019UserNameInputId()
  {
    return SeleniumConstants.ADFS2019_UPN_INPUT_ID;
  }

  void determineFieldIds()
  {
    switch (user.federationProvider) {
      case FederationProvider.ADFS_3:
      case FederationProvider.ADFS_2019:
        passwordInputId = SeleniumConstants.ADFS2019_PASSWORD_ID;
        passwordSigInButtonId = SeleniumConstants.ADFS2019_SUBMIT_ID;
        break;
      case FederationProvider.ADFS_2:
        if (LabConstants.ARLINGTON_LAB_NAME == user.labName) {
          passwordInputId = SeleniumConstants.ADFSV2_ARLINGTON_WEB_PASSWORD_INPUT_ID;
          passwordSigInButtonId = SeleniumConstants.ADFSV2_ARLINGTON_WEB_SUBMIT_BUTTON_ID;
        } else {
          passwordInputId = SeleniumConstants.ADFSV2_WEB_PASSWORD_INPUT_ID;
          passwordSigInButtonId = SeleniumConstants.ADFSV2_WEB_SUBMIT_BUTTON_ID;
        }
        break;
      case FederationProvider.ADFS_4:
        passwordInputId = SeleniumConstants.ADFSV4_WEB_PASSWORD_ID;
        passwordSigInButtonId = SeleniumConstants.ADFSV4_WEB_SUBMIT_ID;
        break;
      default:
        passwordInputId = SeleniumConstants.WEB_PASSWORD_ID;
        passwordSigInButtonId = SeleniumConstants.WEB_SUBMIT_ID;
    }
  }
}