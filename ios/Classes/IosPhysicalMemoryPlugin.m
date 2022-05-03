#import "IosPhysicalMemoryPlugin.h"

@implementation IosPhysicalMemoryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"ios_physical_memory"
            binaryMessenger:[registrar messenger]];
  IosPhysicalMemoryPlugin* instance = [[IosPhysicalMemoryPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"getPhysicalMemory" isEqualToString:call.method]) {
      result([[NSNumber numberWithLong:[NSProcessInfo processInfo].physicalMemory] stringValue]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
