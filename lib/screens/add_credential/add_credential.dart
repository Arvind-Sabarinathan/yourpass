import 'package:flutter/material.dart';
import '../../models/credential.dart';
import '../../services/storage/credential_storage_service.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class AddCredentialScreen extends StatefulWidget {
  const AddCredentialScreen({super.key});

  @override
  State<AddCredentialScreen> createState() => _AddCredentialScreenState();
}

class _AddCredentialScreenState extends State<AddCredentialScreen> {
  final _credentialStorage = CredentialStorageService();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _notesController = TextEditingController();
  CredentialCategory _selectedCategory = CredentialCategory.web;
  bool _obscurePassword = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      color: theme.colorScheme.primary,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    "Add New",
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: PrimaryButton(
                text: "Save Credential",
                icon: Icons.check_circle_rounded,
                onPressed: _isSaving ? null : _handleSave,
                isLoading: _isSaving,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel("Category", theme),
                      const SizedBox(height: 12),
                      _buildCategorySelector(theme),
                      const SizedBox(height: 32),
                      _buildSectionLabel("Credential Details", theme),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _titleController,
                        label: "Service Name",
                        hint: "e.g. Google, Amazon",
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _usernameController,
                        label: "Username / Email",
                        hint: "yourname@email.com",
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: "Password",
                        hint: "••••••••",
                        isObscure: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.4,
                            ),
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionLabel("Optional", theme),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _notesController,
                        label: "Notes",
                        hint: "Add any extra details here...",
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, ThemeData theme) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: theme.colorScheme.primary.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Row(
      children: CredentialCategory.values.map((cat) {
        final isSelected = _selectedCategory == cat;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: cat == CredentialCategory.other ? 0 : 8,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Center(
                child: Text(
                  cat.name[0].toUpperCase() + cat.name.substring(1),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (title.isEmpty || username.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            title.isEmpty
                ? 'Service name is required'
                : username.isEmpty
                    ? 'Username/Email is required'
                    : 'Password is required',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final credential = Credential(
      id: Credential.generateId(),
      title: title,
      username: username,
      password: password,
      category: _selectedCategory,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _credentialStorage.addCredential(credential);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e', style: const TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
