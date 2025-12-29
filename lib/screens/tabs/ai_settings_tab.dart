import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/avatar.dart';
import '../../config/theme.dart';

class AISettingsTab extends StatefulWidget {
  final Avatar avatar;
  final Function(Avatar) onUpdate;

  const AISettingsTab({
    super.key,
    required this.avatar,
    required this.onUpdate,
  });

  @override
  State<AISettingsTab> createState() => _AISettingsTabState();
}

class _AISettingsTabState extends State<AISettingsTab> {
  late TextEditingController _systemPromptController;
  late double _temperature;
  late int _maxTokens;
  bool _isTesting = false;
  String _testResponse = '';

  @override
  void initState() {
    super.initState();
    _systemPromptController = TextEditingController(
      text: widget.avatar.aiSettings.systemPrompt,
    );
    _temperature = widget.avatar.aiSettings.temperature;
    _maxTokens = widget.avatar.aiSettings.maxTokens;
  }

  @override
  void dispose() {
    _systemPromptController.dispose();
    super.dispose();
  }

  void _updateAISettings() {
    widget.onUpdate(widget.avatar.copyWith(
      aiSettings: AvatarAISettings(
        systemPrompt: _systemPromptController.text,
        temperature: _temperature,
        maxTokens: _maxTokens,
      ),
    ));
  }

  String _generateDefaultPrompt() {
    final avatar = widget.avatar;
    final character = avatar.character;
    
    return '''あなたは${avatar.name}として振る舞ってください。

【基本情報】
- 名前: ${avatar.name}
- 時代: ${avatar.era}
- 国: ${avatar.country}
- 肩書き: ${avatar.title}

【キャラクター設定】
- 一人称: ${character.firstPerson.isNotEmpty ? character.firstPerson : '私'}
- 性格: ${character.personality.isNotEmpty ? character.personality.join('、') : '未設定'}
- 口調: ${character.speechStyle.isNotEmpty ? character.speechStyle : '未設定'}
${character.catchphrases.isNotEmpty ? '- 口癖: ${character.catchphrases.join('、')}' : ''}
${character.signatureLine.isNotEmpty ? '- 決め台詞: ${character.signatureLine}' : ''}

【行動指針】
1. 常に${avatar.name}としての視点で回答してください
2. 現代の悩みに対して、${avatar.era}の経験と知恵を活かしてアドバイスしてください
3. キャラクターの性格と口調を一貫して維持してください
4. 適度に口癖や決め台詞を使用してください
5. 回答は親しみやすく、かつ示唆に富んだものにしてください''';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // システムプロンプトセクション
          _buildSectionHeader(
            icon: LucideIcons.fileCode,
            title: 'システムプロンプト',
            subtitle: 'AIの振る舞いを定義するプロンプト',
          ),
          const SizedBox(height: 16),
          _buildPromptEditor(),
          const SizedBox(height: 32),

          // パラメータセクション
          _buildSectionHeader(
            icon: LucideIcons.sliders,
            title: 'AIパラメータ',
            subtitle: '応答の特性を調整',
          ),
          const SizedBox(height: 16),
          _buildParameterSliders(),
          const SizedBox(height: 32),

          // テストセクション
          _buildSectionHeader(
            icon: LucideIcons.beaker,
            title: 'プロンプトテスト',
            subtitle: '設定したプロンプトで応答を確認',
          ),
          const SizedBox(height: 16),
          _buildTestSection(),
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

  Widget _buildPromptEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 自動生成ボタン
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _systemPromptController.text = _generateDefaultPrompt();
                  });
                  _updateAISettings();
                },
                icon: const Icon(LucideIcons.wand2, size: 18),
                label: const Text('キャラ設定から自動生成'),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {
                _systemPromptController.clear();
                _updateAISettings();
              },
              icon: const Icon(LucideIcons.trash2, size: 18),
              label: const Text('クリア'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // プロンプトテキストエリア
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Column(
            children: [
              // ヘッダー
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withOpacity(0.5),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.code, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    const Text(
                      'system_prompt',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_systemPromptController.text.length} 文字',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // テキストエリア
              TextField(
                controller: _systemPromptController,
                maxLines: 15,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'システムプロンプトを入力...\n\n例:\nあなたは織田信長として振る舞ってください。\n戦国時代の知恵を活かして、現代人の悩みに答えてください。',
                ),
                onChanged: (_) => _updateAISettings(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParameterSliders() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        children: [
          // Temperature
          _buildSliderRow(
            label: 'Temperature',
            value: _temperature,
            min: 0.0,
            max: 2.0,
            description: _getTemperatureDescription(_temperature),
            onChanged: (value) {
              setState(() => _temperature = value);
              _updateAISettings();
            },
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.surfaceLight),
          const SizedBox(height: 24),
          
          // Max Tokens
          _buildSliderRow(
            label: 'Max Tokens',
            value: _maxTokens.toDouble(),
            min: 100,
            max: 4000,
            description: '応答の最大長: $_maxTokens トークン',
            onChanged: (value) {
              setState(() => _maxTokens = value.round());
              _updateAISettings();
            },
            divisions: 39,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required String description,
    required Function(double) onChanged,
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceLight,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getTemperatureDescription(double temp) {
    if (temp < 0.3) {
      return '非常に一貫性が高い（決まった応答）';
    } else if (temp < 0.7) {
      return 'バランスの取れた応答';
    } else if (temp < 1.2) {
      return '創造的で多様な応答';
    } else {
      return '非常に創造的（予測不能な応答も）';
    }
  }

  Widget _buildTestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // テスト実行ボタン
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isTesting ? null : _runTest,
            icon: _isTesting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.play, size: 18),
            label: Text(_isTesting ? 'テスト中...' : 'テスト実行'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        // テスト結果
        if (_testResponse.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.messageSquare,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'テスト応答',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => setState(() => _testResponse = ''),
                      icon: const Icon(LucideIcons.x, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _testResponse,
                  style: const TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _runTest() async {
    if (_systemPromptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('システムプロンプトを入力してください')),
      );
      return;
    }

    setState(() {
      _isTesting = true;
      _testResponse = '';
    });

    // TODO: 実際のGemini API呼び出しを実装
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isTesting = false;
      _testResponse = '''ふむ、なかなか面白い質問であるな。

わしが思うに、人生とは常に戦いの連続じゃ。しかし、その戦いを恐れてはならぬ。

「是非もなし」とはよく言ったものよ。やると決めたら迷わず進むのみ。

天下布武！''';
    });
  }
}