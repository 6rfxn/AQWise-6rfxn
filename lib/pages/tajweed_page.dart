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

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  // Better
  final Map<String, Color> _ruleColors = {
    'Idgham': const Color(0xFF4CAF50),
    'Ikhfa': const Color(0xFF2196F3),
    'Iqlab': const Color(0xFFFF9800),
    'Izhar': const Color(0xFF9C27B0),
    'Madd': const Color(0xFFE91E63),
    'Qalqalah': const Color(0xFF00BCD4),
    'Ghunnah': const Color(0xFFFF5722),
  };

  Color _getRuleColor(String rule) {
    return _ruleColors[rule] ?? const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor:
      _isDarkMode ? const Color(0xFF0A0F1C) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n?.tajweedTask ?? 'Tajweed Task'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildWordList()),
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
            l10n?.chooseWordInstruction ??
                'Choose a word below, then assign its correct Tajweed rule',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._words.map((word) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child:
            _buildWordCard(word, provider.savedData[word], provider),
          )),
        ],
      ),
    );
  }

  Widget _buildWordCard(
      String word, List<String>? savedRules, TajweedProvider provider) {
    final isActive = _activeWord == word;
    final l10n = AppLocalizations.of(context);
    final hasRules = savedRules != null && savedRules.isNotEmpty;

    return GestureDetector(
      onTap: () {
        setState(() {
          _activeWord = word;
        });
        _showRuleBottomSheet(word, savedRules, provider);
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
          border: isActive
              ? Border.all(color: const Color(0xFF4CAF50), width: 2)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                      _isDarkMode ? Colors.white : const Color(0xFF2D3142),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  if (hasRules)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: savedRules
                          .map((rule) => _buildRuleChip(rule))
                          .toList(),
                    )
                  else
                    Text(
                      l10n?.assignRule ?? 'Tap to assign a rule',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleChip(String rule) {
    final color = _getRuleColor(rule);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        rule,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Future<void> _showRuleBottomSheet(
      String word,
      List<String>? savedRules,
      TajweedProvider provider,
      ) async {
    final l10n = AppLocalizations.of(context);
    final rules = provider.tajweedRules;

    // Set 2 track selected rules
    Set<String> selectedRules = savedRules != null
        ? Set<String>.from(savedRules)
        : <String>{};

    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E2433) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: Color(0xFF4CAF50),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n?.selectTajweedRule ?? 'Select Tajweed Rules',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode ? Colors.white : const Color(0xFF2D3142),
                                ),
                              ),
                              const SizedBox(height: 4)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: Colors.grey[200]),

                  // Selected rules preview
                  if (selectedRules.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      color: _isDarkMode
                          ? const Color(0xFF2A3142)
                          : const Color(0xFFF5F5F5),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedRules.map((rule) {
                          final color = _getRuleColor(rule);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  rule,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setSheetState(() {
                                      selectedRules.remove(rule);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // Rules list
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: rules.length,
                      itemBuilder: (context, index) {
                        final rule = rules[index];
                        final isSelected = selectedRules.contains(rule);
                        final color = _getRuleColor(rule);

                        return InkWell(
                          onTap: () {
                            setSheetState(() {
                              if (isSelected) {
                                selectedRules.remove(rule);
                              } else {
                                selectedRules.add(rule);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : Colors.grey.withValues(alpha: 0.2),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    rule,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      color: _isDarkMode ? Colors.white : const Color(0xFF2D3142),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isSelected ? color : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? color : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Action buttons
                  Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                    ),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? const Color(0xFF1E2433) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(bottomSheetContext),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFE53935),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: selectedRules.isNotEmpty
                                ? () => Navigator.pop(bottomSheetContext, selectedRules)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              disabledBackgroundColor: Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              l10n?.confirm ?? 'Confirm',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null && result.isNotEmpty && mounted) {
      await provider.confirmSelection(word, result.toList());
      _showSuccessSnackbar();
    }

    if (mounted) {
      setState(() {
        _activeWord = null;
      });
    }
  }

  void _showSuccessSnackbar() {
    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n?.ruleSavedSuccessfully ?? 'Rule saved successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}