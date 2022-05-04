import 'dart:async';
import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/services.dart';

class IosPhysicalMemory {
  static const MethodChannel _channel = MethodChannel('ios_physical_memory');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get physicalMemory async {
    if (!Platform.isIOS) throw Exception("Platform not supported");
    final String physicalMemory =
        await _channel.invokeMethod('getPhysicalMemory') ?? '0';
    return filesize(int.tryParse(physicalMemory));
  }

  static Future<String?> get availableFreeMemory async {
    if (!Platform.isIOS) throw Exception("Platform not supported");
    final String freeMemory =
        await _channel.invokeMethod('getAvailableMemory') ?? '0';
    return filesize(int.tryParse(freeMemory));
  }
}
