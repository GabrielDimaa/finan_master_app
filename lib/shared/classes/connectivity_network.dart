import 'dart:io';

import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';

class ConnectivityNetwork {
  static Future<void> hasInternet() async {
    try {
      List<InternetAddress>? result;

      Future.delayed(const Duration(seconds: 20), () {
        if (result == null) throw const SocketException("error");
      });

      result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return;

      throw const SocketException("error");
    } on SocketException catch (_) {
      throw Exception(R.strings.noInternetConnection);
    }
  }
}
