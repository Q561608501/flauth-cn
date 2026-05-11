import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate({String localizedReason = ''}) async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return true;
      }

      final reason = localizedReason.isNotEmpty
          ? localizedReason
          : 'Please authenticate to access Flauth';

      return await _auth.authenticate(localizedReason: reason);
    } on PlatformException {
      return false;
    } catch (e) {
      return false;
    }
  }
}
