import 'dart:io';

import 'package:microsoft_authentication/infra_structure/selenium_constats.dart';
import 'package:microsoft_authentication/infra_structure/user_information_fields.dart';
import 'package:microsoft_authentication/lab_api/federation_provider.dart';
import 'package:microsoft_authentication/lab_api/lab/lab_constants.dart';
import 'package:webdriver/core.dart';

class SeleniumExtensions {

  // private final static Logger LOG = LoggerFactory.getLogger(SeleniumExtensions.class);

  static WebDriver createDefaultWebDriver() {
    // ChromeOptions options = new ChromeOptions();
    // //no visual rendering, remove when debugging
    // options.addArguments("--headless");
    //
    // System.setProperty("webdriver.chrome.driver", "C:/Windows/chromedriver.exe");
    // ChromeDriver driver = new ChromeDriver(options);
    // driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

    return new WebDriver();
  }

  static WebElement waitForElementToBeVisibleAndEnable(WebDriver driver,
      By by) {
    //WebDriverWait webDriverWait = new WebDriverWait(driver, 15);
    return null;
    // return webDriverWait.until((dr) ->
    //     {
    //
    //     try {
    //     WebElement elementToBeDisplayed = driver.findElement(by);
    //     if(elementToBeDisplayed.isDisplayed() && elementToBeDisplayed.isEnabled()){
    //     return elementToBeDisplayed;
    //     }
    //     return null;
    //     } catch (StaleElementReferenceException e) {
    //     return null;
    //     }
    //     });
  }

  static void performADLogin(WebDriver driver, User user) {
    UserInformationFields fields = new UserInformationFields(user);

    //LOG.info("Loggin in ... Entering username");
    driver.findElement(new By.id(fields.getAadUserNameInputId())).sendKeys(
        user.getUpn());
    // driver.findElement(new By.ById(fields.getAadUserNameInputId())).sendKeys(user.getUpn());

    //LOG.info("Loggin in ... Clicking <Next> after username");
    //driver.findElement(new By.ById(fields.getAadSignInButtonId())).click();
    driver.findElement(new By.id(fields.getAadSignInButtonId())); //.click();

    if (user.getFederationProvider() == FederationProvider.ADFS_2 &&
        !user.getLabName().equals(LabConstants.ARLINGTON_LAB_NAME)) {
      //LOG.info("Loggin in ... ADFS-V2 - Entering the username in ADFSv2 form");
      driver.findElement(
          new By.id(SeleniumConstants.ADFSV2_WEB_USERNAME_INPUT_ID)).asStream();
      //sendKeys(user.getUpn());
    }

    //LOG.info("Loggin in ... Entering password");
    By by = new By.id(fields.getPasswordInputId());
    waitForElementToBeVisibleAndEnable(driver, by).sendKeys(user.getPassword());

    //LOG.info("Loggin in ... click submit");
    waitForElementToBeVisibleAndEnable(
        driver, new By.id(fields.getPasswordSigInButtonId())).
    click();
  }

  static void performADFS2019Login(WebDriver driver, User user) {
    //LOG.info("PerformADFS2019Login");

    UserInformationFields fields = new UserInformationFields(user);

    //LOG.info("Loggin in ... Entering username");
    driver.findElement(new By.id(fields.getADFS2019UserNameInputId())).sendKeys(
        user.getUpn());

    //LOG.info("Loggin in ... Entering password");
    By by = new By.id(fields.getPasswordInputId());
    waitForElementToBeVisibleAndEnable(driver, by).sendKeys(user.getPassword());

    //LOG.info("Loggin in ... click submit");
    waitForElementToBeVisibleAndEnable(
        driver, new By.id(fields.getPasswordSigInButtonId())).click();
  }

  static void performLocalLogin(WebDriver driver, User user) {
    //LOG.info("PerformLocalLogin");

    driver.findElement(new By.id(SeleniumConstants.B2C_LOCAL_ACCOUNT_ID))
        .click();

    //LOG.info("Loggin in ... Entering username");
    driver.findElement(new By.id(SeleniumConstants.B2C_LOCAL_USERNAME_ID))
        .sendKeys(user.getUpn());

    //LOG.info("Loggin in ... Entering password");
    By by = new By.id(SeleniumConstants.B2C_LOCAL_PASSWORD_ID);
    waitForElementToBeVisibleAndEnable(driver, by).sendKeys(user.getPassword());

    waitForElementToBeVisibleAndEnable(
        driver, new By.id(SeleniumConstants.B2C_LOCAL_SIGN_IN_BUTTON_ID)).
    click();
  }

  static void performGoogleLogin(WebDriver driver, User user) {
    // LOG.info("PerformGoogleLogin");
    driver.findElement(
        new By.id(SeleniumConstants.GOOGLE_ACCOUNT_ID)) //.click();

    //LOG.info("Loggin in ... Entering username");
    driver.findElement(new By.id(SeleniumConstants.GOOGLE_USERNAME_ID))
        .sendKeys(user.getUpn());

    //LOG.info("Loggin in ... Clicking <Next> after username");
    driver.findElement(new By.id(
        SeleniumConstants.GOOGLE_NEXT_AFTER_USERNAME_BUTTON)) //.click();

    //LOG.info("Loggin in ... Entering password");
    By by = new By.name(SeleniumConstants.GOOGLE_PASSWORD_ID);
    waitForElementToBeVisibleAndEnable(driver, by).sendKeys(user.getPassword());

    //LOG.info("Loggin in ... click submit");

    waitForElementToBeVisibleAndEnable(
        driver, new By.id(SeleniumConstants.GOOGLE_NEXT_BUTTON_ID)).click();
  }

  static void performFacebookLogin(WebDriver driver, User user) {
    // LOG.info("PerformFacebookLogin");

    driver.findElement(new By.id(SeleniumConstants.FACEBOOK_ACCOUNT_ID));
    //.click();

    //LOG.info("Loggin in ... Entering username");
    driver.findElement(new By.id(
        SeleniumConstants.FACEBOOK_USERNAME_ID)); //.sendKeys(user.getUpn());

    // LOG.info("Loggin in ... Entering password");
    By by = new By.id(SeleniumConstants.FACEBOOK_PASSWORD_ID);
    waitForElementToBeVisibleAndEnable(driver, by).sendKeys(user.getPassword());

    waitForElementToBeVisibleAndEnable(
        driver, new By.id(SeleniumConstants.FACEBOOK_LOGIN_BUTTON_ID)).
    click();
  }


  void takeScreenShot(WebDriver driver) {
    String file = System.getenv("BUILD_STAGINGDIRECTORY");
    File destination = new File(file + "" + "/SeleniumError.png");
    File scrFile = ((TakesScreenshot)driver).getScreenshotAs(OutputType.FILE);
    try {
      FileUtils.copyFile(scrFile, destination);
      // LOG.info("Screenshot can be found at: " + destination.path);
    }
    catch (e) {
      //LOG.error("Error taking screenshot: " + e.getMessage());
    }
  }
}
