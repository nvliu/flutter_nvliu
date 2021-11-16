#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "AsrPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 10.0, *)) {
      [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
    }
  [GeneratedPluginRegistrant registerWithRegistry:self];
    [AsrPlugin registerWithRegistrar:[self registrarForPlugin:@"AsrPlugin"]];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
