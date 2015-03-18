# HockeyApp PhoneGap/Cordova Plugin

### Platform Support

This plugin supports PhoneGap/Cordova apps running on both iOS and Android.

### Version Requirements

This plugin is meant to work with Cordova 3.5.0+ and the latest version of the HockeyApp library.

SDK documentation and integration guides for IOS and Android:  
http://support.hockeyapp.net/kb/client-integration-ios-mac-os-x/hockeyapp-for-ios  
http://support.hockeyapp.net/kb/client-integration-android-other-platforms/hockeyapp-for-android-sdk  

TODO - update plugin to latest SDK versions 

## Installation

#### Automatic Installation using PhoneGap/Cordova CLI (iOS and Android)
1. Make sure you update your projects to Cordova iOS version 3.5.0+ before installing this plugin.

        cordova platform update ios
        cordova platform update android

2. Install this plugin using PhoneGap/Cordova cli:

        cordova plugin add https://github.com/wnyc/cordova-plugin-hockeyapp.git

3. For iOS, you can supply a HockeyAppID.plist file with your cordova project *(inside the www folder)* that is structured in the following manner:
     
        {
			"<your.app.bundle.identifier>": "<your hockey app id>",
			"<your.alternative.app.bundle.identifier>": "<your alternative hockey app id>",
		}

   This file can contain multiple bundle IDs (e.g. for testing and production). Be aware that the Hockey App ID will be shipped with your Cordova application since it is located inside the `www` directory.

   For Android, modify HockeyAppPlugin.java, replacing with your configuration setting:

        String hockeyAppId="__HOCKEY_APP_KEY__";

   Todo: better way to turn update check on/off (Android only) than having build script comment out code between __HOCKEY_APP_UPDATE_ACTIVE_START__ and __HOCKEY_APP_UPDATE_ACTIVE_END__ in HockeyAppPlugin.java 

   Todo: pull GA key from configuration setting

