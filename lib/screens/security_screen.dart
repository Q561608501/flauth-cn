import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/pin_pad.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _isSettingPin = false;
  String _tempPin = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    // If user is in the process of setting a new PIN
    if (_isSettingPin) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_tempPin.isEmpty ? l10n.setNewPin : l10n.confirmPin),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSettingPin = false;
                _tempPin = '';
              });
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _tempPin.isEmpty ? l10n.enterSixDigitPin : l10n.reEnterToConfirm,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: PinPad(
                  pinLength: 6,
                  onSubmit: (pin) {
                    if (_tempPin.isEmpty) {
                      // First entry
                      setState(() {
                        _tempPin = pin;
                      });
                    } else {
                      // Confirmation
                      if (pin == _tempPin) {
                        // Success
                        auth.setSecurity(
                          pin,
                          enableBiometrics: auth.isBiometricEnabled,
                        );
                        setState(() {
                          _isSettingPin = false;
                          _tempPin = '';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.pinSetSuccessfully)),
                        );
                      } else {
                        // Mismatch
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.pinsDoNotMatch),
                          ),
                        );
                        setState(() {
                          _tempPin = ''; // Reset
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Main Security Settings List
    return Scaffold(
      appBar: AppBar(title: Text(l10n.security)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.pinProtection),
            subtitle: Text(auth.hasPin ? l10n.enabled : l10n.disabled),
            trailing: Switch(
              value: auth.hasPin,
              onChanged: (val) {
                if (val) {
                  // Enable -> Go to Set PIN
                  setState(() {
                    _isSettingPin = true;
                  });
                } else {
                  // Disable -> Clear Security
                  // Ideally, ask for current PIN before disabling.
                  // For simplicity:
                  auth.clearSecurity();
                }
              },
            ),
          ),
          if (auth.hasPin) ...[
            const Divider(),
            ListTile(
              title: Text(l10n.changePin),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _isSettingPin = true;
                });
              },
            ),
            SwitchListTile(
              title: Text(l10n.biometricUnlock),
              subtitle: Text(l10n.biometricSubtitle),
              value: auth.isBiometricEnabled,
              onChanged: (val) {
                auth.toggleBiometrics(val);
              },
            ),
            const Divider(),
            SwitchListTile(
              title: Text(l10n.usePinForBackup),
              subtitle: Text(l10n.usePinForBackupSubtitle),
              value: auth.isUsePinForBackupEnabled,
              onChanged: (val) {
                auth.toggleUsePinForBackup(val);
              },
            ),
          ],
        ],
      ),
    );
  }
}
