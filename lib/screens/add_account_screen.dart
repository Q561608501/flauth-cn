import 'package:flutter/material.dart';
import 'package:flauth/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issuerController = TextEditingController();
  final _nameController = TextEditingController();
  final _secretController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _issuerController.dispose();
    _nameController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  bool _isValidBase32(String input) {
    final cleaned = input.replaceAll(' ', '').toUpperCase();
    if (cleaned.isEmpty) return false;
    final regex = RegExp(r'^[A-Z2-7]+=*$');
    if (!regex.hasMatch(cleaned)) return false;
    return cleaned.length % 8 == 0 || cleaned.contains('=');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<AccountProvider>(context, listen: false);

    final issuer = _issuerController.text.trim();
    final name = _nameController.text.trim();
    final secret = _secretController.text
        .trim()
        .replaceAll(' ', '')
        .toUpperCase();

    final success = await provider.addAccount(
      name.isNotEmpty ? name : issuer,
      secret,
      issuer: issuer,
    );

    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.addedAccount(issuer.isNotEmpty ? issuer : name)),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.accountAlreadyExists(issuer.isNotEmpty ? issuer : name),
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addManually)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _issuerController,
                decoration: InputDecoration(
                  labelText: l10n.issuerLabel,
                  hintText: l10n.issuerHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.business),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.accountName,
                  hintText: l10n.accountNameHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _secretController,
                decoration: InputDecoration(
                  labelText: l10n.secretKey,
                  hintText: l10n.secretKeyHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return l10n.secretKeyRequired;
                  }
                  if (!_isValidBase32(val.trim())) {
                    return l10n.invalidSecretKey;
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 36),
              FilledButton.icon(
                onPressed: _isProcessing ? null : _submit,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: Text(l10n.add),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
