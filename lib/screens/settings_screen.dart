import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ThemeProvider>(
      builder: (context, languageProvider, themeProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(languageProvider.getText('settings')),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildLanguageCard(languageProvider),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageProvider.getText('appearance'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(languageProvider.getText('dark_mode')),
                        value: themeProvider.isDarkMode,
                        onChanged: (_) => themeProvider.toggleTheme(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    languageProvider.getText('logout'),
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () => _showLogoutDialog(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(languageProvider.getText('logout')),
        content: Text(languageProvider.getText('confirm_logout')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(languageProvider.getText('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(languageProvider.getText('logout')),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await Provider.of<UserProvider>(context, listen: false).logout();
    }
  }

  Widget _buildLanguageCard(LanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              languageProvider.getText('language'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildLanguageOptions(languageProvider, context),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOptions(LanguageProvider languageProvider, BuildContext context) {
    return Column(
      children: [
        _LanguageOption(
          languageCode: 'en',
          name: 'English',
          isSelected: languageProvider.isLanguage('en'),
          onTap: () => languageProvider.setLanguage('en'),
        ),
        const SizedBox(height: 8),
        _LanguageOption(
          languageCode: 'ta',
          name: 'தமிழ்',
          isSelected: languageProvider.isLanguage('ta'),
          onTap: () => languageProvider.setLanguage('ta'),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String languageCode;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.languageCode,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
