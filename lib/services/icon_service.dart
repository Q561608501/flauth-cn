import 'package:flutter/material.dart';

class IconService {
  static const Map<String, IconData> _issuerIcons = {
    'google': Icons.mail_outline,
    'github': Icons.code,
    'microsoft': Icons.window,
    'amazon': Icons.shopping_cart_outlined,
    'dropbox': Icons.cloud_outlined,
    'cloudflare': Icons.cloud,
    'facebook': Icons.facebook,
    'twitter': Icons.alternate_email,
    'instagram': Icons.camera_alt_outlined,
    'apple': Icons.apple,
    'slack': Icons.tag,
    'discord': Icons.headphones,
    'twitch': Icons.videogame_asset,
    'reddit': Icons.forum_outlined,
    'linkedin': Icons.business,
    'paypal': Icons.payment,
    'stripe': Icons.credit_card,
    'aws': Icons.cloud_queue,
    'digitalocean': Icons.dns_outlined,
    'heroku': Icons.cloud_circle_outlined,
    'netlify': Icons.web,
    'vercel': Icons.speed,
    'gitlab': Icons.merge_type,
    'bitbucket': Icons.source,
    'steam': Icons.games_outlined,
    'epic games': Icons.sports_esports_outlined,
    'battle.net': Icons.shield_outlined,
    'riot': Icons.security,
    'steam': Icons.games,
    'okta': Icons.vpn_key_outlined,
    '1password': Icons.key,
    'lastpass': Icons.lock_outline,
    'bitwarden': Icons.lock,
    'duo': Icons.phone_android,
    'authy': Icons.smartphone,
    'lastpass': Icons.password,
  };

  static IconData? getIconForIssuer(String issuer) {
    final normalizedIssuer = issuer.toLowerCase().trim();
    return _issuerIcons[normalizedIssuer];
  }

  static Color getColorForIssuer(String issuer) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];
    final hash = issuer.hashCode.abs();
    return colors[hash % colors.length];
  }

  static String getInitial(String issuer) {
    if (issuer.isEmpty) return '?';
    return issuer[0].toUpperCase();
  }
}
