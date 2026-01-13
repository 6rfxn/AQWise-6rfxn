import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irfan/provider/tajweed_provider.dart';
import 'package:irfan/l10n/app_localizations.dart';

class TajweedPage extends StatefulWidget {
  const TajweedPage({super.key});

  @override
  State<TajweedPage> createState() => _TajweedPageState();
}

class _TajweedPageState extends State<TajweedPage> {
  final List<String> _words = [
    'من يقول',
    'من بعد',
    'أنعمت',
    'كنتم',
    'خوف',
  ];

  String? _activeWord;
  bool _isDropdownOpen = false;

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0A0F1C) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n?.tajweedTask ?? 'Tajweed Task'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildWordList()),
          if (_activeWord != null) _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildWordList() {
    final provider = Provider.of<TajweedProvider>(context);
    final l10n = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n?.chooseWordInstruction ?? 'Choose a word below, then assign its correct Tajweed rule',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._words.map((word) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildWordCard(word, provider.savedData[word], provider),
          )),
        ],
      ),
    );
  }

  Widget _buildWordCard(String word, String? savedRule, TajweedProvider provider) {
    final isActive = _activeWord == word;
    final l10n = AppLocalizations.of(context);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeWord = word;
          _isDropdownOpen = false;
        });
        provider.selectRule(savedRule);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1E2433) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isActive ? Border.all(color: const Color(0xFF4CAF50), width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF2D3142),
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              savedRule ?? (l10n?.assignRule ?? 'Assign a rule'),
              style: TextStyle(
                fontSize: 14,
                color: savedRule != null ? Theme.of(context).colorScheme.primary : Colors.grey[600]!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    final provider = Provider.of<TajweedProvider>(context);
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF0A0F1C) : const Color(0xFFF8FAFC),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            _buildDropdown(provider),
            const SizedBox(height: 16),
            _buildConfirmButton(provider, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(TajweedProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1E2433) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isDarkMode ? Colors.white24 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          _buildDropdownOptions(provider),
          if (_isDropdownOpen) _buildDivider(),
          _buildDropdownHeader(provider),
        ],
      ),
    );
  }

  Widget _buildDropdownOptions(TajweedProvider provider) {
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Container(
        constraints: const BoxConstraints(maxHeight: 180),
        child: SingleChildScrollView(
          child: Column(
            children: provider.tajweedRules.map((rule) => _buildDropdownOption(rule, provider)).toList(),
          ),
        ),
      ),
      crossFadeState: _isDropdownOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  Widget _buildDropdownOption(String rule, TajweedProvider provider) {
    final isSelected = provider.selectedRule == rule;
    
    return InkWell(
      onTap: () {
        provider.selectRule(rule);
        setState(() => _isDropdownOpen = false);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected
            ? (_isDarkMode ? Colors.white10 : Colors.grey.shade100)
            : Colors.transparent,
        child: Text(
          rule,
          style: TextStyle(
            fontSize: 15,
            color: _isDarkMode ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: _isDarkMode ? Colors.white24 : Colors.grey.shade300,
    );
  }

  Widget _buildDropdownHeader(TajweedProvider provider) {
    final l10n = AppLocalizations.of(context);
    
    return GestureDetector(
      onTap: () => setState(() => _isDropdownOpen = !_isDropdownOpen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              provider.selectedRule ?? (l10n?.selectTajweedRule ?? 'Select Tajweed Rule'),
              style: TextStyle(
                fontSize: 15,
                color: provider.selectedRule != null
                    ? (_isDarkMode ? Colors.white : Colors.black87)
                    : Colors.grey,
              ),
            ),
            AnimatedRotation(
              turns: _isDropdownOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_up,
                color: _isDarkMode ? Colors.white54 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(TajweedProvider provider, ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 14),
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.primary,
      onPressed: provider.selectedRule == null ? null : () => _handleConfirm(provider),
      child: Text(
        l10n?.confirm ?? 'Confirm',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleConfirm(TajweedProvider provider) {
    final l10n = AppLocalizations.of(context);
    
    provider.confirmSelection(_activeWord!);
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(l10n?.success ?? 'Success'),
        content: Text(l10n?.ruleSavedSuccessfully ?? 'Rule saved successfully!'),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n?.ok ?? 'OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}