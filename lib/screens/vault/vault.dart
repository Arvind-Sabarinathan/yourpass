import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yourpass/models/credential.dart';
import 'package:yourpass/widgets/app_logo.dart';
import '../add_credential/add_credential.dart';
import '../credential_details/credential_details.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/action_button.dart';

class Vault extends StatefulWidget {
  const Vault({super.key});

  @override
  State<Vault> createState() => _VaultState();
}

class _VaultState extends State<Vault> {
  final _searchController = TextEditingController();
  late List<Credential> _filteredCredentials;
  CredentialCategory? _selectedCategory;
  final Map<String, bool> _copyStatus = {};

  final List<Credential> _allCredentials = [
    Credential(
      id: '1',
      title: 'Google',
      username: 'john.doe@gmail.com',
      password: 'password123',
      category: CredentialCategory.web,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Credential(
      id: '2',
      title: 'Instagram',
      username: 'john_insta',
      password: 'insta_pass_456',
      category: CredentialCategory.app,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Credential(
      id: '3',
      title: 'Github',
      username: 'johndoe_dev',
      password: 'git_secure_789',
      category: CredentialCategory.web,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Credential(
      id: '4',
      title: 'Netflix',
      username: 'family_netflix',
      password: 'movie_time_321',
      category: CredentialCategory.web,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Credential(
      id: '5',
      title: 'Spotify',
      username: 'music_lover_99',
      password: 'beat_pass_654',
      category: CredentialCategory.app,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Credential(
      id: '6',
      title: 'Amazon',
      username: 'shopper_john',
      password: 'buy_all_the_things',
      category: CredentialCategory.web,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Credential(
      id: '7',
      title: 'Router Admin',
      username: 'admin',
      password: 'very_secret_router',
      category: CredentialCategory.other,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      updatedAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredCredentials = List.from(_allCredentials);
    _filterCredentials();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
            // List of Credentials
            _filteredCredentials.isEmpty
                ? _buildEmptyState(theme)
                : ShaderMask(
                    shaderCallback: (Rect rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Colors.transparent,
                          Colors.black,
                          Colors.black,
                          Colors.transparent,
                        ],
                        stops: [
                          170 / rect.height,
                          240 / rect.height,
                          (rect.height - 124 - bottomInset) / rect.height,
                          (rect.height - 64 - bottomInset) / rect.height,
                        ],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        210,
                        20,
                        104 + bottomInset,
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

            // Header
            Positioned(top: 0, left: 0, right: 0, child: _buildHeader(context)),

            // Top Pill (Categories)
            Positioned(top: 70, left: 0, right: 0, child: _buildTopPill(theme)),

            // Add Button
            Positioned(
              top: 130,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildAddButton(theme),
              ),
            ),

            // Search Pill (Bottom)
            Positioned(
              bottom: 20 + bottomInset,
              left: 0,
              right: 0,
              child: _buildSearchPill(theme),
            ),
          ],
        ),
      ),
    );
  }

  void _filterCredentials() {
    setState(() {
      _filteredCredentials = _allCredentials.where((cred) {
        final matchesSearch =
            cred.title.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            cred.username.toLowerCase().contains(
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
            ? theme.colorScheme.surface.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: isDark ? 0.1 : 0.05,
          ),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Title, Username (Subtle), and Badge
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
          // Row 2: Copy Actions and Details
          Row(
            children: [
              // Copy Username Section
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
              // Copy Password Section
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
              // Arrow Button
              ActionButton(
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CredentialDetailsScreen(credential: cred),
                    ),
                  );
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
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopPill(ThemeData theme) {
    final bool isDark = theme.brightness == Brightness.dark;
    final Color pillColor = isDark ? theme.colorScheme.surface : Colors.white;
    final Color borderColor = theme.colorScheme.primary.withValues(
      alpha: isDark ? 0.2 : 0.1,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: pillColor,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Row(
        children: [
          Expanded(child: _buildFilterChip(null, "All")),
          const SizedBox(width: 4),
          Expanded(child: _buildFilterChip(CredentialCategory.web, "Web")),
          const SizedBox(width: 4),
          Expanded(child: _buildFilterChip(CredentialCategory.app, "Apps")),
          const SizedBox(width: 4),
          Expanded(child: _buildFilterChip(CredentialCategory.other, "Others")),
        ],
      ),
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    return PrimaryButton(
      text: "Add New Credential",
      icon: Icons.add_rounded,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCredentialScreen()),
        );
      },
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.transparent, // Seamless with pill
      ),
      child: TextField(
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

  Widget _buildSearchPill(ThemeData theme) {
    final bool isDark = theme.brightness == Brightness.dark;
    final Color pillColor = isDark ? theme.colorScheme.surface : Colors.white;
    final Color borderColor = theme.colorScheme.primary.withValues(
      alpha: isDark ? 0.2 : 0.1,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: pillColor,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: _buildSearchField(theme),
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
