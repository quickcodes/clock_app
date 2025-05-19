import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:system_info2/system_info2.dart';

import '../../../main.dart';

class DeviceInfoWidget extends StatefulWidget {
  const DeviceInfoWidget({super.key});

  @override
  State<DeviceInfoWidget> createState() => _DeviceInfoWidgetState();
}

class _DeviceInfoWidgetState extends State<DeviceInfoWidget> {
  String deviceNetworkInfo = "";
  String deviceInfo = "N/A";
  late Timer _timer; // Timer for periodic fetching
  late Connectivity _connectivity;
  // late DeviceInfoPlugin _deviceInfoPlugin;
  String info = "";

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    // _deviceInfoPlugin = DeviceInfoPlugin();
    _fetchDeviceAndNetworkInfo(); // Initial fetch
    _startPeriodicFetch(); // Start periodic fetch
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  // Fetch system details using system_info2
  // Future<void> _fetchSystemInfo() async {
  //   info = '';
  //   // Kernel and OS Information
  //   info += '\n\n';
  //   info += "Kernel Architecture     : ${SysInfo.kernelArchitecture}\n";
  //   info += "Raw Kernel Architecture : ${SysInfo.rawKernelArchitecture}\n";
  //   info += "Kernel Bitness          : ${SysInfo.kernelBitness}\n";
  //   info += "Kernel Name             : ${SysInfo.kernelName}\n";
  //   info += "Kernel Version          : ${SysInfo.kernelVersion}\n";
  //   info += "Operating System Name   : ${SysInfo.operatingSystemName}\n";
  //   info += "Operating System Version: ${SysInfo.operatingSystemVersion}\n";
  //   info += "User Directory          : ${SysInfo.userDirectory}\n";
  //   info += "User ID                 : ${SysInfo.userId}\n";
  //   info += "User Name               : ${SysInfo.userName}\n";
  //   info += "User Space Bitness      : ${SysInfo.userSpaceBitness}\n";
  //   info += '\n\n';

  //   // CPU Information
  //   final cores = SysInfo.cores;
  //   info += "Number of Cores: ${cores.length}\n";
  //   // for (final core in cores) {
  //   //   info += "  Architecture: ${core.architecture}\n";
  //   //   info += "  Name: ${core.name}\n";
  //   //   info += "  Socket: ${core.socket}\n";
  //   //   info += "  Vendor: ${core.vendor}\n";
  //   // }
  //   info += '\n\n';

  //   // Memory Information
  //   const int megaByte = 1024 * 1024;
  //   info +=
  //       "Total Physical Memory   : ${SysInfo.getTotalPhysicalMemory() ~/ megaByte} MB\n";
  //   info +=
  //       "Free Physical Memory    : ${SysInfo.getFreePhysicalMemory() ~/ megaByte} MB\n";
  //   info +=
  //       "Total Virtual Memory    : ${SysInfo.getTotalVirtualMemory() ~/ megaByte} MB\n";
  //   info +=
  //       "Free Virtual Memory     : ${SysInfo.getFreeVirtualMemory() ~/ megaByte} MB\n";
  //   info +=
  //       "Virtual Memory Size     : ${SysInfo.getVirtualMemorySize() ~/ megaByte} MB\n";

  //   // Update the UI with the system info
  //   if (context.mounted && mounted) {
  //     setState(() {
  //       // info = info;
  //     });
  //   }
  // }
  Future<void> _fetchSystemInfo() async {
    const int megaByte = 1024 * 1024;

    info = '''
==============================
     📋 System Information     
==============================

🖥️  Operating System
• Name     : ${SysInfo.operatingSystemName}
• Version  : ${SysInfo.operatingSystemVersion}

⚙️  Kernel
• Name     : ${SysInfo.kernelName}
• Version  : ${SysInfo.kernelVersion}
• Bitness  : ${SysInfo.kernelBitness}

👤 User Info
• Username : ${SysInfo.userName}
• User ID  : ${SysInfo.userId}
• Home Dir : ${SysInfo.userDirectory}
• Bitness  : ${SysInfo.userSpaceBitness}

💾 Memory
• Total Physical : ${SysInfo.getTotalPhysicalMemory() ~/ megaByte} MB
• Free Physical  : ${SysInfo.getFreePhysicalMemory() ~/ megaByte} MB
• Total Virtual  : ${SysInfo.getTotalVirtualMemory() ~/ megaByte} MB
• Free Virtual   : ${SysInfo.getFreeVirtualMemory() ~/ megaByte} MB

==============================
''';

    if (context.mounted && mounted) {
      setState(() {
        // Update the UI with the cleaned-up info
      });
    }
  }

  // Fetch Device and Network Info combined into one method
  Future<void> _fetchDeviceAndNetworkInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String networkType = "Unknown";

    // Get current network status
    ConnectivityResult connectivityResult =
        (await _connectivity.checkConnectivity()).first;

    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        networkType = "Mobile Data 📱";
        break;
      case ConnectivityResult.wifi:
        networkType = "WiFi 🌐";
        break;
      case ConnectivityResult.ethernet:
        networkType = "Ethernet 🔌";
        break;
      default:
        networkType = "No Network 🚫";
    }

    // Get platform-specific device info
    String networkInfo = networkType;

    if (!mounted) return;
    // Fetch device information based on platform
    if (context.mounted && Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      if (!mounted) return;
      deviceInfo =
          "You're using an 🍏 ${iosInfo.name} (${iosInfo.model}), running iOS ${iosInfo.systemVersion}, With device ID ${iosInfo.identifierForVendor}.\n"
          "You're currently connected to $networkInfo, and everything seems smooth!";
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      if (!mounted) return;
      deviceInfo =
          "You're using a 🤖 ${androidInfo.name} (${androidInfo.model}) by ${androidInfo.brand}, running Android ${androidInfo.version.release}, With device ID ${androidInfo.id}.\n"
          "You're connected to $networkInfo, and everything seems smooth!";
    }

    if (!mounted) return;
    // Combine both device and network info
    setState(() {
      deviceNetworkInfo = networkInfo;
    });
  }

  // Start a periodic timer to fetch device and network info every 10 seconds
  void _startPeriodicFetch() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _fetchDeviceAndNetworkInfo(); // Fetch data periodically
      // _fetchSystemInfo();
    });
  }

  // Function to show the dialog with a dark theme and professional UI
  void _showDescriptionDialog() {
    _fetchSystemInfo();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87, // Dark background for the dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(16.0), // Add padding inside the dialog
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Device Info",
                      style: TextStyle(
                        color: Colors.white, // Light color for the title
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    deviceInfo,
                    style: TextStyle(
                      color: Colors.white70, // Lighter color for the text
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    info,
                    style: TextStyle(
                      color: Colors.white70, // Lighter color for the text
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Colors.blueAccent, // Blue background for the button
                      foregroundColor: Colors.white, // White text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Rounded button corners
                      ),
                    ),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDescriptionDialog, // Show dialog on tap of the title
      child: TweenAnimationBuilder<double>(
          duration: animationDuration,
          curve: animationCurve,
          tween: Tween(
            begin: darkMode ? 1 : 0.5,
            end: darkMode ? 0.5 : 1,
          ),
          builder: (context, animationAlpha, child) {
            return SizedBox(
              width: !isPortrait ? dynamicHeight * 0.3 : null,
              child: Text(
                deviceNetworkInfo,
                style: TextStyle(
                  fontSize: dynamicHeight * 0.04,
                  color: Colors.grey.shade500.withValues(alpha: animationAlpha),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
    );
  }
}
