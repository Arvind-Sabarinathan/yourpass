import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/credential.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/action_button.dart';

class CredentialDetailsScreen extends StatefulWidget {
  final Credential credential;

  const CredentialDetailsScreen({super.key, required this.credential});

  @override
  State<CredentialDetailsScreen> createState() =>
      _CredentialDetailsScreenState();
}

class _CredentialDetailsScreenState extends State<CredentialDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _notesController;
  late CredentialCategory _selectedCategory;

  bool _isEditingTitle = false;
  bool _isEditingUsername = false;
  bool _isEditingPassword = false;
  bool _isEditingNotes = false;
  bool _isEditingCategory = false;
  bool _obscurePassword = true;

  final Map<String, bool> _copyStatus = {};

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.credential.title);
    _usernameController = TextEditingController(
      text: widget.credential.username,
    );
    _passwordController = TextEditingController(
      text: widget.credential.password,
    );
    _notesController = TextEditingController(
      text: widget.credential.notes ?? "",
    );
    _selectedCategory = widget.credential.category;
  }

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
      backgroundColor: theme.scaffoldBackgroundColor,
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
                    "Details",
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
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: "Delete",
                      icon: Icons.delete_outline_rounded,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: "Save",
                      icon: Icons.check_circle_rounded,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created: ${_formatDate(widget.credential.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    'Last Updated: ${_formatDate(widget.credential.updatedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                    stops: [0.0, 0.05],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel("CATEGORY", theme),
                      const SizedBox(height: 12),
                      _buildCategoryRow(theme),

                      const SizedBox(height: 24),
                      _buildSectionLabel("SERVICE DETAILS", theme),
                      const SizedBox(height: 16),
                      _buildInteractiveField(
                        controller: _titleController,
                        label: "Service Name",
                        hint: "e.g. Google",
                        isEditing: _isEditingTitle,
                        onToggleEdit: () =>
                            setState(() => _isEditingTitle = !_isEditingTitle),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),
                      _buildInteractiveField(
                        controller: _usernameController,
                        label: "Username / Email",
                        hint: "yourname@email.com",
                        isEditing: _isEditingUsername,
                        onToggleEdit: () => setState(
                          () => _isEditingUsername = !_isEditingUsername,
                        ),
                        onCopy: () =>
                            _copyToClipboard(_usernameController.text, 'user'),
                        isCopied: _copyStatus['user'] == true,
                        theme: theme,
                      ),
                      const SizedBox(height: 16),
                      _buildInteractiveField(
                        controller: _passwordController,
                        label: "Password",
                        hint: "••••••••",
                        isEditing: _isEditingPassword,
                        isObscure: _obscurePassword,
                        onToggleEdit: () => setState(
                          () => _isEditingPassword = !_isEditingPassword,
                        ),
                        onCopy: () =>
                            _copyToClipboard(_passwordController.text, 'pass'),
                        isCopied: _copyStatus['pass'] == true,
                        onToggleObscure: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        theme: theme,
                      ),

                      const SizedBox(height: 24),
                      _buildSectionLabel("OPTIONAL", theme),
                      const SizedBox(height: 12),
                      _buildInteractiveField(
                        controller: _notesController,
                        label: "Notes",
                        hint: "No notes added",
                        isEditing: _isEditingNotes,
                        onToggleEdit: () =>
                            setState(() => _isEditingNotes = !_isEditingNotes),
                        theme: theme,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text, String key) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copyStatus[key] = true);
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copyStatus[key] = false);
      }
    });
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute $period';
  }

  Widget _buildSectionLabel(String label, ThemeData theme) {
    return Text(
      label,
      style: TextStyle(
        color: theme.colorScheme.primary.withValues(alpha: 0.5),
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildCategoryRow(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isEditingCategory
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CredentialCategory>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    items: CredentialCategory.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(
                          cat.name[0].toUpperCase() + cat.name.substring(1),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              )
            : Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _selectedCategory.name[0].toUpperCase() +
                      _selectedCategory.name.substring(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ActionButton(
              icon: _isEditingCategory
                  ? Icons.check_rounded
                  : Icons.edit_rounded,
              label: _isEditingCategory ? "Save" : "Edit",
              onPressed: () =>
                  setState(() => _isEditingCategory = !_isEditingCategory),
              isPrimary: _isEditingCategory,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isEditing,
    required VoidCallback onToggleEdit,
    VoidCallback? onCopy,
    bool isCopied = false,
    required ThemeData theme,
    bool isObscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: controller,
          label: label,
          hint: hint,
          isObscure: isObscure,
          readOnly: !isEditing,
          suffixIcon: onToggleObscure != null
              ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                    size: 20,
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onCopy != null) ...[
              ActionButton(
                icon: isCopied ? Icons.check_rounded : Icons.copy_rounded,
                label: isCopied ? "Copied" : "Copy",
                onPressed: isCopied ? () {} : onCopy,
                isPrimary: isCopied,
              ),
              const SizedBox(width: 12),
            ],
            ActionButton(
              icon: isEditing ? Icons.check_rounded : Icons.edit_rounded,
              label: isEditing ? "Done" : "Edit",
              onPressed: onToggleEdit,
              isPrimary: isEditing,
            ),
          ],
        ),
      ],
    );
  }
}
