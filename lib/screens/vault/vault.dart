import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yourpass/models/credential.dart';
import 'package:yourpass/services/storage/credential_storage_service.dart';
import 'package:yourpass/widgets/app_logo.dart';
import '../add_credential/add_credential.dart';
import '../credential_details/credential_details.dart';
import '../settings/settings.dart';
import '../../widgets/action_button.dart';

class Vault extends StatefulWidget {
  const Vault({super.key});

  @override
  State<Vault> createState() => _VaultState();
}

class _VaultState extends State<Vault> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _credentialStorage = CredentialStorageService();
  List<Credential> _allCredentials = [];
  late List<Credential> _filteredCredentials;
  CredentialCategory? _selectedCategory;
  final Map<String, bool> _copyStatus = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _filteredCredentials = [];
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final creds = await _credentialStorage.loadCredentials();
    if (!mounted) return;
    setState(() {
      _allCredentials = creds;
      _isLoading = false;
    });
    _filterCredentials();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredCredentials.isEmpty
                      ? _buildEmptyState(theme)
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 140,
                          ),
                          itemCount: _filteredCredentials.length,
                          itemBuilder: (context, index) {
                            return _buildCredentialCard(
                              _filteredCredentials[index],
                              theme,
                            );
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset,
              child: _buildBottomDock(theme),
            ),
          ],
        ),
      ),
    );
  }

  void _filterCredentials() {
    setState(() {
      _filteredCredentials = _allCredentials.where((cred) {
        final matchesSearch = cred.title.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        final matchesCategory =
            _selectedCategory == null || cred.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();

      // Sort by title by default
      _filteredCredentials.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  IconData _getCategoryIcon(CredentialCategory category) {
    switch (category) {
      case CredentialCategory.web:
        return Icons.language_rounded;
      case CredentialCategory.app:
        return Icons.phone_android_rounded;
      case CredentialCategory.other:
        return Icons.key_rounded;
    }
  }

  Widget _buildCategoryBadge(CredentialCategory category, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 10,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            category.name.toLowerCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialCard(Credential cred, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface.withValues(alpha: 0.15)
            : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                cred.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  cred.username,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.3,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildCategoryBadge(cred.category, theme),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  icon: _copyStatus['${cred.id}_u'] == true
                      ? Icons.check_rounded
                      : Icons.copy_rounded,
                  label: _copyStatus['${cred.id}_u'] == true
                      ? "Copied"
                      : "Username",
                  onPressed: _copyStatus['${cred.id}_u'] == true
                      ? null
                      : () {
                          Clipboard.setData(ClipboardData(text: cred.username));
                          setState(() => _copyStatus['${cred.id}_u'] = true);
                          Timer(const Duration(seconds: 2), () {
                            if (mounted) {
                              setState(
                                () => _copyStatus['${cred.id}_u'] = false,
                              );
                            }
                          });
                        },
                  isPrimary: _copyStatus['${cred.id}_u'] == true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  icon: _copyStatus['${cred.id}_p'] == true
                      ? Icons.check_rounded
                      : Icons.copy_rounded,
                  label: _copyStatus['${cred.id}_p'] == true
                      ? "Copied"
                      : "Password",
                  onPressed: _copyStatus['${cred.id}_p'] == true
                      ? null
                      : () {
                          Clipboard.setData(ClipboardData(text: cred.password));
                          setState(() => _copyStatus['${cred.id}_p'] = true);
                          Timer(const Duration(seconds: 2), () {
                            if (mounted) {
                              setState(
                                () => _copyStatus['${cred.id}_p'] = false,
                              );
                            }
                          });
                        },
                  isPrimary: _copyStatus['${cred.id}_p'] == true,
                ),
              ),
              const SizedBox(width: 12),
              ActionButton(
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: () async {
                  _searchFocusNode.unfocus();
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CredentialDetailsScreen(credential: cred),
                    ),
                  );
                  if (result == true && mounted) {
                    _loadCredentials();
                  }
                },
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppLogo(),
          Text(
            "Vault",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(CredentialCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _filterCredentials();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.primary.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildFilterChip(null, "All")),
        const SizedBox(width: 4),
        Expanded(child: _buildFilterChip(CredentialCategory.web, "Web")),
        const SizedBox(width: 4),
        Expanded(child: _buildFilterChip(CredentialCategory.app, "Apps")),
        const SizedBox(width: 4),
        Expanded(child: _buildFilterChip(CredentialCategory.other, "Others")),
      ],
    );
  }

  Widget _buildBottomDock(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = (isDark ? theme.colorScheme.surface : Colors.white);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(42),
          topRight: Radius.circular(42),
        ),
        border: Border(
          top: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: _buildFilterRow(theme)),
                const SizedBox(width: 8),
                _buildSettingsIcon(theme),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildSearchField(theme)),
                const SizedBox(width: 8),
                _buildAddIcon(theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddIcon(ThemeData theme) {
    return GestureDetector(
      onTap: () async {
        _searchFocusNode.unfocus();
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => const AddCredentialScreen()),
        );
        if (result == true && mounted) {
          _loadCredentials();
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildSettingsIcon(ThemeData theme) {
    return GestureDetector(
      onTap: () async {
        _searchFocusNode.unfocus();
        await Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        if (mounted) {
          _loadCredentials();
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(
          Icons.settings_rounded,
          size: 22,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: isDark ? 0.2 : 0.1,
          ),
        ),
      ),
      child: TextField(
        focusNode: _searchFocusNode,
        controller: _searchController,
        onChanged: (value) => _filterCredentials(),
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Search in vault...",
          hintStyle: TextStyle(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          Text(
            "No credentials found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
