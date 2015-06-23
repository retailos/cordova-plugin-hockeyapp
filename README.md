# HockeyApp PhoneGap/Cordova Plugin

### Platform Support

This plugin supports PhoneGap/Cordova apps running on both iOS and Android.

### Version Requirements

This plugin is meant to work with Cordova 3.5.0+ and the latest version of the HockeyApp library.

SDK documentation and integration guides for IOS and Android:  
http://support.hockeyapp.net/kb/client-integration-ios-mac-os-x/hockeyapp-for-ios  
http://support.hockeyapp.net/kb/client-integration-android-other-platforms/hockeyapp-for-android-sdk  

####Hockey SDK Versions

	iOS - 3.5.4
	Android -  3.5.0

## Installation

#### Automatic Installation using PhoneGap/Cordova CLI (iOS and Android)
1. Make sure you update your projects to Cordova iOS version 3.5.0+ before installing this plugin.

        cordova platform update ios
        cordova platform update android

2. Install this plugin using PhoneGap/Cordova cli:

        cordova plugin add https://github.com/pradeepkumargali/cordova-plugin-hockeyapp.git  --variable DROID_APPID="YOUR_ANDROID_APP_KEY" --variable IOS_APPID="YOUR_IOS_HOCKEY_APP_KEY"
   
   Pass the empty string (""), if the plugin is being used for either iOS or Android.
   
#### Usage
1. Update & CrashReport service is being initialized on app startup or resume. 
2. Call feedback feature using JS function call.

        hockeyapp.feedback()
	
## TODO
   1. better way to turn update check on/off (Android only) than having build script comment out code between __HOCKEY_APP_UPDATE_ACTIVE_START__ and __HOCKEY_APP_UPDATE_ACTIVE_END__ in HockeyAppPlugin.java 
   2. Extend the plugin to Windows

