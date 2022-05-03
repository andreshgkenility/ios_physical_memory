#import "IosPhysicalMemoryPlugin.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

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
  } else if ([@"getAvailableMemory" isEqualToString:call.method]) {
      mach_port_t host_port;
      mach_msg_type_number_t host_size;
      vm_size_t pagesize;

      host_port = mach_host_self();
      host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
      host_page_size(host_port, &pagesize);

      vm_statistics_data_t vm_stat;

      if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
          NSLog(@"Failed to fetch vm statistics");
      }

          /* Stats in bytes */
//      natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
      natural_t mem_free = vm_stat.free_count * pagesize;
//      natural_t mem_total = mem_used + mem_free;
      result([[NSNumber numberWithInt:mem_free] stringValue]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
