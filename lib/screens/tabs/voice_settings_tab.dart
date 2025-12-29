import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/avatar.dart';
import '../../config/theme.dart';

class VoiceSettingsTab extends StatefulWidget {
  final Avatar avatar;
  final Function(Avatar) onUpdate;

  const VoiceSettingsTab({
    super.key,
    required this.avatar,
    required this.onUpdate,
  });

  @override
  State<VoiceSettingsTab> createState() => _VoiceSettingsTabState();
}

class _VoiceSettingsTabState extends State<VoiceSettingsTab> {
  late TextEditingController _voiceIdController;
  late double _stability;
  late double _similarityBoost;
  bool _isPlaying = false;

  // ElevenLabsのプリセット音声（例）
  final List<Map<String, String>> _presetVoices = [
    {'id': 'pNInz6obpgDQGcFmaJgB', 'name': 'Adam', 'description': '深みのある男性ボイス'},
    {'id': '21m00Tcm4TlvDq8ikWAM', 'name': 'Rachel', 'description': '落ち着いた女性ボイス'},
    {'id': 'AZnzlk1XvdvUeBnXmlld', 'name': 'Domi', 'description': '力強い男性ボイス'},
    {'id': 'EXAVITQu4vr4xnSDxMaL', 'name': 'Bella', 'description': '明るい女性ボイス'},
    {'id': 'ErXwobaYiN019PkySvjV', 'name': 'Antoni', 'description': '温かみのある男性ボイス'},
    {'id': 'MF3mGyEYCl7XYWbV9V6O', 'name': 'Elli', 'description': '若々しい女性ボイス'},
  ];

  @override
  void initState() {
    super.initState();
    _voiceIdController = TextEditingController(
      text: widget.avatar.voiceSettings.elevenLabsVoiceId,
    );
    _stability = widget.avatar.voiceSettings.stability;
    _similarityBoost = widget.avatar.voiceSettings.similarityBoost;
  }

  @override
  void dispose() {
    _voiceIdController.dispose();
    super.dispose();
  }

  void _updateVoiceSettings() {
    widget.onUpdate(widget.avatar.copyWith(
      voiceSettings: AvatarVoiceSettings(
        elevenLabsVoiceId: _voiceIdController.text,
        stability: _stability,
        similarityBoost: _similarityBoost,
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
          // Voice ID セクション
          _buildSectionHeader(
            icon: LucideIcons.mic,
            title: 'ElevenLabs Voice ID',
            subtitle: 'テキスト読み上げに使用する音声',
          ),
          const SizedBox(height: 16),
          _buildVoiceIdInput(),
          const SizedBox(height: 24),
          _buildPresetVoices(),
          const SizedBox(height: 32),

          // 音声パラメータセクション
          _buildSectionHeader(
            icon: LucideIcons.sliders,
            title: '音声パラメータ',
            subtitle: '音声の特性を調整',
          ),
          const SizedBox(height: 16),
          _buildVoiceParameters(),
          const SizedBox(height: 32),

          // 音声サンプルセクション
          _buildSectionHeader(
            icon: LucideIcons.volume2,
            title: '音声サンプル',
            subtitle: '参照用の音声ファイル',
          ),
          const SizedBox(height: 16),
          _buildSampleAudioSection(),
          const SizedBox(height: 32),

          // テスト再生セクション
          _buildSectionHeader(
            icon: LucideIcons.play,
            title: 'テスト再生',
            subtitle: '設定した音声でテスト',
          ),
          const SizedBox(height: 16),
          _buildTestPlaySection(),
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

  Widget _buildVoiceIdInput() {
    return TextField(
      controller: _voiceIdController,
      decoration: const InputDecoration(
        labelText: 'Voice ID',
        hintText: 'ElevenLabsのVoice IDを入力',
        prefixIcon: Icon(LucideIcons.key, size: 20),
      ),
      onChanged: (_) => _updateVoiceSettings(),
    );
  }

  Widget _buildPresetVoices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'プリセット音声',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetVoices.map((voice) {
            final isSelected = _voiceIdController.text == voice['id'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _voiceIdController.text = voice['id']!;
                });
                _updateVoiceSettings();
              },
              child: Container(
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
                    Icon(
                      isSelected ? LucideIcons.checkCircle : LucideIcons.circle,
                      size: 16,
                      color: isSelected ? AppColors.primary : AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voice['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          voice['description']!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVoiceParameters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        children: [
          // Stability
          _buildParameterSlider(
            label: 'Stability（安定性）',
            value: _stability,
            description: _stability < 0.3
                ? '感情豊かで変化に富む'
                : _stability < 0.7
                    ? 'バランスの取れた表現'
                    : '安定した一貫性のある音声',
            onChanged: (value) {
              setState(() => _stability = value);
              _updateVoiceSettings();
            },
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.surfaceLight),
          const SizedBox(height: 24),
          
          // Similarity Boost
          _buildParameterSlider(
            label: 'Similarity Boost（類似性）',
            value: _similarityBoost,
            description: _similarityBoost < 0.3
                ? '自然で柔軟な音声'
                : _similarityBoost < 0.7
                    ? 'バランスの取れた類似性'
                    : '元の音声に非常に近い',
            onChanged: (value) {
              setState(() => _similarityBoost = value);
              _updateVoiceSettings();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParameterSlider({
    required String label,
    required double value,
    required String description,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toStringAsFixed(2),
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
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            onChanged: onChanged,
          ),
        ),
        Text(
          description,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSampleAudioSection() {
    final sampleUrl = widget.avatar.voiceSettings.sampleAudioUrl;
    
    return GestureDetector(
      onTap: _uploadSampleAudio,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: sampleUrl != null
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.fileAudio,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'sample_audio.mp3',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'タップして変更',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.play),
                    color: AppColors.primary,
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.upload,
                      color: AppColors.textMuted,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '音声サンプルをアップロード',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'MP3, WAV (最大10MB)',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTestPlaySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        children: [
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'テスト用のテキストを入力...\n例: 天下布武！わしが織田信長である。',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _voiceIdController.text.isEmpty ? null : _playTestAudio,
              icon: Icon(
                _isPlaying ? LucideIcons.square : LucideIcons.play,
                size: 18,
              ),
              label: Text(_isPlaying ? '停止' : 'テスト再生'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (_voiceIdController.text.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Voice IDを入力してください',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  void _uploadSampleAudio() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('音声アップロード機能は実装予定です')),
    );
  }

  void _playTestAudio() {
    setState(() => _isPlaying = !_isPlaying);
    
    // TODO: 実際のElevenLabs API呼び出しを実装
    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _isPlaying = false);
      });
    }
  }
} 