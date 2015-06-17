//
//  HockeyAppPlugin.m
//

#import <HockeySDK/HockeySDK.h>

#import "HockeyAppPlugin.h"

static NSString *const kHockeyAppPluginAppReachedTerminateEventKey = @"AppReachedTerminateEvent";

@interface HockeyAppPlugin ()
@property (copy, nonatomic) NSString *hockeyAppID;
@end

@implementation HockeyAppPlugin

#pragma mark Initialization

- (void)pluginInitialize {
    initialized=NO;
    NSString *hockeyAppKey = self.hockeyAppID;
    if(hockeyAppKey && ![hockeyAppKey isEqualToString:@""]) {
        // hack to prevent sending crash report for crashes that occur when app is shutting down
        // reference for deleting crash report file:
        // http://support.hockeyapp.net/discussions/problems/33370-is-there-a-way-to-manually-send-the-most-recent-crash-report-after-changing-the-crash-reporting-status
        BOOL appReachedTerminateEvent = [[[NSUserDefaults standardUserDefaults] valueForKey:kHockeyAppPluginAppReachedTerminateEventKey] boolValue];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHockeyAppPluginAppReachedTerminateEventKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if (appReachedTerminateEvent) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cacheDir = [paths objectAtIndex: 0];
            NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
            NSString *filePath = [cacheDir stringByAppendingPathComponent:@"com.plausiblelabs.crashreporter.data"];
            filePath = [filePath stringByAppendingPathComponent:bundleIdentifier];
            filePath = [filePath stringByAppendingPathComponent:@"live_report.plcrash"];
            BOOL fileExists = [fileManager fileExistsAtPath:filePath];
            NSError *error = nil;
            if (fileExists) {
                if (![fileManager removeItemAtPath:filePath error:&error]) {
					NSLog(@"Could not delete crash report file:  %@ (%@)", error, filePath);
                }
            }
        }
        
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:hockeyAppKey];
        [[BITHockeyManager sharedHockeyManager] startManager];
        [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
        initialized = YES;
    }
    
    NSLog(@"HockeyApp Plugin initialized");
}

#pragma mark Shutdown methods

- (void)onAppTerminate {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHockeyAppPluginAppReachedTerminateEventKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Plugin methods

- (void)forcecrash:(CDVInvokedUrlCommand *)command {
  NSLog(@"HockeyApp Plugin crashing the app!");
  __builtin_trap();
}

- (void) feedback:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    if(initialized == YES) {
        [[BITHockeyManager sharedHockeyManager].feedbackManager showFeedbackListView];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"hockeyapp cordova plugin is not started!"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Hockey app identifier methods

- (NSString *)hockeyAppID {
    if(!_hockeyAppID) {
        _hockeyAppID = [self hockeyAppIDFromPropertyList];
    }
    return _hockeyAppID;
}

- (NSString *)hockeyAppIDFromPropertyList {
    
    NSString *bundleHockeyApp = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"HockeyAppID"];
   
    if ([bundleHockeyApp length] > 0) {
        return bundleHockeyApp;
    } else {
        return nil;
    }
    
    return nil;
}

@end
