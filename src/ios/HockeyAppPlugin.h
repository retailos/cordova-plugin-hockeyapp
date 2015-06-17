//
//  HockeyAppPlugin.h
//

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>

@interface HockeyAppPlugin : CDVPlugin <BITHockeyManagerDelegate, BITUpdateManagerDelegate,BITCrashManagerDelegate>{
    BOOL initialized;
}



- (void)forcecrash:(CDVInvokedUrlCommand*)command;
- (void) feedback:(CDVInvokedUrlCommand*)command;

@end
