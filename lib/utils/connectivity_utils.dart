import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtils {
  static const _domains = [
    'google.com',
    'cloudflare.com',
    '8.8.8.8',
  ];

  static Future<bool> hasRealInternetConnection() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return false;
      }

      // Try multiple domains
      for (final domain in _domains) {
        try {
          final result = await InternetAddress.lookup(domain)
              .timeout(const Duration(seconds: 3));
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (_) {
          continue;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
