
import 'package:microsoft_authentication/infra_structure/selenium_extension.dart';
import 'package:microsoft_authentication/lab_api/b2c_provider.dart';
import 'package:microsoft_authentication/lab_api/lab/user_provider.dart';
import 'package:microsoft_authentication/lab_api/user/user_model.dart';
import 'package:webdriver/io.dart';

abstract class SeleniumTest
{
  LabUserProvider labUserProvider;
  WebDriver seleniumDriver;
  HttpListener httpListener;

  void setUpLapUserProvider()
  {
    labUserProvider = LabUserProvider.instance;
  }

  void cleanUp()
  {
    seleniumDriver.quit();
    if (httpListener != null) {
      httpListener.stopListener();
    }
  }

  void startUpBrowser()
  {
    seleniumDriver = SeleniumExtensions.createDefaultWebDriver();
  }

  void runSeleniumAutomatedLogin(User user, AbstractClientApplicationBase app)
  {
    AuthorityType authorityType = app.authenticationAuthority.authorityType;
    if (authorityType == AuthorityType_.B2C) {
      switch (user.b2cProvider.toLowerCase()) {
        case B2CProvider.LOCAL:
          SeleniumExtensions.performLocalLogin(seleniumDriver, user);
          break;
        case B2CProvider.GOOGLE:
          SeleniumExtensions.performGoogleLogin(seleniumDriver, user);
          break;
        case B2CProvider.FACEBOOK:
          SeleniumExtensions.performFacebookLogin(seleniumDriver, user);
          break;
      }
    } else {
      if (authorityType == AuthorityType_.AAD) {
        SeleniumExtensions.performADLogin(seleniumDriver, user);
      } else {
        if (authorityType == AuthorityType_.ADFS) {
          SeleniumExtensions.performADFS2019Login(seleniumDriver, user);
        }
      }
    }
  }
}