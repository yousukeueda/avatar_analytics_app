import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/avatar.dart';
import '../../config/theme.dart';

class CharacterTab extends StatefulWidget {
  final Avatar avatar;
  final Function(Avatar) onUpdate;

  const CharacterTab({
    super.key,
    required this.avatar,
    required this.onUpdate,
  });

  @override
  State<CharacterTab> createState() => _CharacterTabState();
}

class _CharacterTabState extends State<CharacterTab> {
  late TextEditingController _firstPersonController;
  late TextEditingController _speechStyleController;
  late TextEditingController _signatureLineController;
  late TextEditingController _newCatchphraseController;
  late List<String> _selectedPersonality;
  late List<String> _catchphrases;

  final List<String> _personalityOptions = [
    '野心的', '革新的', '短気', '冷静', '知的', '情熱的',
    '優しい', '厳格', 'ユーモア', 'カリスマ', '神秘的', '誠実',
    '勇敢', '慎重', '自信家', '謙虚', '社交的', '孤高',
    '楽観的', '現実的', '理想主義', '戦略的', '直感的', '論理的',
  ];

  @override
  void initState() {
    super.initState();
    _firstPersonController = TextEditingController(
      text: widget.avatar.character.firstPerson,
    );
    _speechStyleController = TextEditingController(
      text: widget.avatar.character.speechStyle,
    );
    _signatureLineController = TextEditingController(
      text: widget.avatar.character.signatureLine,
    );
    _newCatchphraseController = TextEditingController();
    _selectedPersonality = List.from(widget.avatar.character.personality);
    _catchphrases = List.from(widget.avatar.character.catchphrases);
  }

  @override
  void dispose() {
    _firstPersonController.dispose();
    _speechStyleController.dispose();
    _signatureLineController.dispose();
    _newCatchphraseController.dispose();
    super.dispose();
  }

  void _updateCharacter() {
    widget.onUpdate(widget.avatar.copyWith(
      character: AvatarCharacter(
        personality: _selectedPersonality,
        firstPerson: _firstPersonController.text,
        speechStyle: _speechStyleController.text,
        catchphrases: _catchphrases,
        signatureLine: _signatureLineController.text,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 性格セクション
          _buildSectionHeader(
            icon: LucideIcons.heart,
            title: '性格',
            subtitle: 'キャラクターの性格を選択（複数可）',
          ),
          const SizedBox(height: 16),
          _buildPersonalitySelector(),
          const SizedBox(height: 32),

          // 口調セクション
          _buildSectionHeader(
            icon: LucideIcons.messageCircle,
            title: '口調・話し方',
            subtitle: 'どんな言葉遣いで話すか',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _firstPersonController,
            label: '一人称',
            hint: '例: わし、私、俺、余',
            icon: LucideIcons.user,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _speechStyleController,
            label: '口調サンプル',
            hint: '例: 〜であるぞ、〜じゃ、〜ですわ',
            icon: LucideIcons.quote,
            maxLines: 2,
          ),
          const SizedBox(height: 32),

          // 口癖セクション
          _buildSectionHeader(
            icon: LucideIcons.repeat,
            title: '口癖',
            subtitle: 'よく使う言葉やフレーズ',
          ),
          const SizedBox(height: 16),
          _buildCatchphraseList(),
          const SizedBox(height: 12),
          _buildAddCatchphraseField(),
          const SizedBox(height: 32),

          // 決め台詞セクション
          _buildSectionHeader(
            icon: LucideIcons.star,
            title: '決め台詞',
            subtitle: 'キャラクターを象徴する一言',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _signatureLineController,
            label: '決め台詞',
            hint: '例: 天下布武！、勝利あるのみ！',
            icon: LucideIcons.zap,
          ),
          const SizedBox(height: 32),

          // プレビューセクション
          _buildSectionHeader(
            icon: LucideIcons.eye,
            title: 'プレビュー',
            subtitle: '設定した内容のサンプル',
          ),
          const SizedBox(height: 16),
          _buildPreviewCard(),
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
              Text(title, style: Theme.of(context).textTheme.titleMedium),
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

  Widget _buildPersonalitySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _personalityOptions.map((personality) {
        final isSelected = _selectedPersonality.contains(personality);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedPersonality.remove(personality);
              } else {
                _selectedPersonality.add(personality);
              }
            });
            _updateCharacter();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.2)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              personality,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
          ),
          onChanged: (_) => _updateCharacter(),
        ),
      ],
    );
  }

  Widget _buildCatchphraseList() {
    if (_catchphrases.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: const Center(
          child: Text(
            '口癖がまだ登録されていません',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return Column(
      children: _catchphrases.asMap().entries.map((entry) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.quote,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _catchphrases.removeAt(entry.key);
                  });
                  _updateCharacter();
                },
                icon: const Icon(LucideIcons.x, size: 18),
                color: AppColors.textMuted,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddCatchphraseField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _newCatchphraseController,
            decoration: const InputDecoration(
              hintText: '新しい口癖を入力...',
              prefixIcon: Icon(LucideIcons.plus, size: 20),
            ),
            onSubmitted: (_) => _addCatchphrase(),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _addCatchphrase,
          child: const Text('追加'),
        ),
      ],
    );
  }

  void _addCatchphrase() {
    final text = _newCatchphraseController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _catchphrases.add(text);
        _newCatchphraseController.clear();
      });
      _updateCharacter();
    }
  }

  Widget _buildPreviewCard() {
    final name = widget.avatar.name.isNotEmpty ? widget.avatar.name : 'キャラクター名';
    final firstPerson = _firstPersonController.text.isNotEmpty
        ? _firstPersonController.text
        : '私';
    final speechStyle = _speechStyleController.text.isNotEmpty
        ? _speechStyleController.text
        : '〜です';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  name.isNotEmpty ? name[0] : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '「$firstPersonが思うに、それは非常に興味深い問いかけ$speechStyle」',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ),
          if (_signatureLineController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(LucideIcons.star, size: 16, color: AppColors.warning),
                const SizedBox(width: 8),
                Text(
                  _signatureLineController.text,
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}