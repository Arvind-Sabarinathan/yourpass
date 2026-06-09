import 'package:flutter/material.dart';
import 'package:yourpass/screens/unlock_vault/unlock_vault.dart';
import 'package:yourpass/services/theme/theme_service.dart';
import 'package:yourpass/services/vault/vault_session_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: primary,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                children: [
                  _sectionLabel("SECURITY", theme),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: "Lock Vault",
                    subtitle: "Lock your vault and return to unlock screen",
                    onTap: () {
                      VaultSessionService().lock();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const UnlockVault()),
                        (route) => false,
                      );
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.timer_rounded,
                    title: "Auto-lock",
                    subtitle: "Automatically lock after inactivity",
                    upcoming: true,
                  ),
                  const SizedBox(height: 32),
                  _sectionLabel("APPEARANCE", theme),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    icon: Icons.palette_rounded,
                    title: "Theme",
                    subtitle: "Switch between light, dark, or system",
                    onTap: () => _showThemePicker(context),
                  ),
                  const SizedBox(height: 32),
                  _sectionLabel("DATA", theme),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    icon: Icons.cloud_upload_rounded,
                    title: "Export / Import",
                    subtitle: "Backup or transfer your credentials",
                    upcoming: true,
                  ),
                  _SettingsTile(
                    icon: Icons.delete_outline_rounded,
                    title: "Delete Vault",
                    subtitle: "Permanently erase all data",
                    upcoming: true,
                  ),
                  const SizedBox(height: 32),
                  _sectionLabel("GENERAL", theme),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    icon: Icons.dashboard_rounded,
                    title: "Dashboard",
                    subtitle: "View vault statistics and insights",
                    upcoming: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    final theme = Theme.of(context);
    final current = ThemeService().mode.value;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Choose Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            final label = switch (mode) {
              ThemeMode.system => "System",
              ThemeMode.light => "Light",
              ThemeMode.dark => "Dark",
            };
            final icon = switch (mode) {
              ThemeMode.system => Icons.brightness_auto_rounded,
              ThemeMode.light => Icons.light_mode_rounded,
              ThemeMode.dark => Icons.dark_mode_rounded,
            };
            final isSelected = current == mode;

            return ListTile(
              leading: Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
              title: Text(label),
              trailing: isSelected
                  ? Icon(Icons.check_rounded, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                ThemeService().setTheme(mode);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, ThemeData theme) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: theme.colorScheme.primary.withValues(alpha: 0.5),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool upcoming;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.upcoming = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: upcoming ? null : onTap,
      child: Opacity(
        opacity: upcoming ? 0.35 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surface.withValues(alpha: 0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: primary.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 22, color: primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          if (upcoming) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "#upcoming",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: primary.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: primary.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: primary.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
