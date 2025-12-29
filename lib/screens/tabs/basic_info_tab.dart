import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/avatar.dart';
import '../../config/theme.dart';

class BasicInfoTab extends StatefulWidget {
  final Avatar avatar;
  final Function(Avatar) onUpdate;

  const BasicInfoTab({
    super.key,
    required this.avatar,
    required this.onUpdate,
  });

  @override
  State<BasicInfoTab> createState() => _BasicInfoTabState();
}

class _BasicInfoTabState extends State<BasicInfoTab> {
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _eraController;
  late String _selectedCountry;
  late String _selectedLanguage;

  final List<Map<String, String>> _countries = [
    {'code': '日本', 'flag': '🇯🇵'},
    {'code': 'アメリカ', 'flag': '🇺🇸'},
    {'code': 'イギリス', 'flag': '🇬🇧'},
    {'code': 'フランス', 'flag': '🇫🇷'},
    {'code': 'ドイツ', 'flag': '🇩🇪'},
    {'code': 'イタリア', 'flag': '🇮🇹'},
    {'code': 'スペイン', 'flag': '🇪🇸'},
    {'code': '中国', 'flag': '🇨🇳'},
    {'code': '韓国', 'flag': '🇰🇷'},
    {'code': 'ロシア', 'flag': '🇷🇺'},
    {'code': 'エジプト', 'flag': '🇪🇬'},
    {'code': 'ギリシャ', 'flag': '🇬🇷'},
    {'code': 'インド', 'flag': '🇮🇳'},
    {'code': 'ブラジル', 'flag': '🇧🇷'},
    {'code': 'メキシコ', 'flag': '🇲🇽'},
    {'code': 'その他', 'flag': '🌐'},
  ];

  final List<Map<String, String>> _languages = [
    {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
    {'code': 'en', 'name': '英語', 'flag': '🇺🇸'},
    {'code': 'fr', 'name': 'フランス語', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'ドイツ語', 'flag': '🇩🇪'},
    {'code': 'es', 'name': 'スペイン語', 'flag': '🇪🇸'},
    {'code': 'pt', 'name': 'ポルトガル語', 'flag': '🇧🇷'},
    {'code': 'zh', 'name': '中国語', 'flag': '🇨🇳'},
    {'code': 'ko', 'name': '韓国語', 'flag': '🇰🇷'},
    {'code': 'it', 'name': 'イタリア語', 'flag': '🇮🇹'},
    {'code': 'ru', 'name': 'ロシア語', 'flag': '🇷🇺'},
    {'code': 'ar', 'name': 'アラビア語', 'flag': '🇸🇦'},
    {'code': 'hi', 'name': 'ヒンディー語', 'flag': '🇮🇳'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.avatar.name);
    _titleController = TextEditingController(text: widget.avatar.title);
    _descriptionController = TextEditingController(text: widget.avatar.description);
    _eraController = TextEditingController(text: widget.avatar.era);
    _selectedCountry = widget.avatar.country.isNotEmpty 
        ? widget.avatar.country 
        : '日本';
    _selectedLanguage = widget.avatar.language.isNotEmpty 
        ? widget.avatar.language 
        : 'ja';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _eraController.dispose();
    super.dispose();
  }

  void _updateField() {
    widget.onUpdate(widget.avatar.copyWith(
      name: _nameController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      era: _eraController.text,
      country: _selectedCountry,
      language: _selectedLanguage,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // セクションヘッダー
          _buildSectionHeader(
            icon: LucideIcons.user,
            title: 'キャラクター情報',
            subtitle: 'アバターの基本的な情報を設定します',
          ),
          const SizedBox(height: 24),

          // 名前（必須）
          _buildTextField(
            controller: _nameController,
            label: '名前',
            hint: '例: 織田信長',
            icon: LucideIcons.userCircle,
            required: true,
            onChanged: (_) => _updateField(),
          ),
          const SizedBox(height: 20),

          // 肩書き
          _buildTextField(
            controller: _titleController,
            label: '肩書き・キャッチコピー',
            hint: '例: 天下統一を目指した革命児',
            icon: LucideIcons.badge,
            onChanged: (_) => _updateField(),
          ),
          const SizedBox(height: 20),

          // 説明
          _buildTextField(
            controller: _descriptionController,
            label: '説明',
            hint: 'このアバターについての詳しい説明...',
            icon: LucideIcons.fileText,
            maxLines: 3,
            onChanged: (_) => _updateField(),
          ),
          const SizedBox(height: 32),

          // セクションヘッダー
          _buildSectionHeader(
            icon: LucideIcons.globe,
            title: '地域・時代',
            subtitle: 'アバターの出身地と活躍した時代',
          ),
          const SizedBox(height: 24),

          // 国・地域
          _buildDropdown(
            label: '国・地域',
            icon: LucideIcons.mapPin,
            value: _selectedCountry,
            items: _countries.map((c) => 
              DropdownMenuItem(
                value: c['code'],
                child: Row(
                  children: [
                    Text(c['flag']!, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Text(c['code']!),
                  ],
                ),
              )
            ).toList(),
            onChanged: (value) {
              setState(() => _selectedCountry = value!);
              _updateField();
            },
          ),
          const SizedBox(height: 20),

          // 時代
          _buildTextField(
            controller: _eraController,
            label: '時代',
            hint: '例: 戦国時代、19世紀、古代ローマ',
            icon: LucideIcons.clock,
            onChanged: (_) => _updateField(),
          ),
          const SizedBox(height: 32),

          // セクションヘッダー
          _buildSectionHeader(
            icon: LucideIcons.languages,
            title: '使用言語',
            subtitle: 'このアバターが使用する言語',
          ),
          const SizedBox(height: 24),

          // 言語選択（グリッド形式）
          _buildLanguageSelector(),
          
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool required = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: AppColors.error),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textMuted),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    dropdownColor: AppColors.surface,
                    items: items,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _languages.map((lang) {
        final isSelected = _selectedLanguage == lang['code'];
        return GestureDetector(
          onTap: () {
            setState(() => _selectedLanguage = lang['code']!);
            _updateField();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primary.withOpacity(0.2)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(lang['flag']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  lang['name']!,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.check,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}