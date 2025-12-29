import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/avatar.dart';
import '../../config/theme.dart';

class SocialLinksTab extends StatefulWidget {
  final Avatar avatar;
  final Function(Avatar) onUpdate;

  const SocialLinksTab({
    super.key,
    required this.avatar,
    required this.onUpdate,
  });

  @override
  State<SocialLinksTab> createState() => _SocialLinksTabState();
}

class _SocialLinksTabState extends State<SocialLinksTab> {
  // YouTube
  late TextEditingController _youtubeChannelIdController;
  late TextEditingController _youtubeChannelNameController;
  
  // TikTok
  late TextEditingController _tiktokAccountIdController;
  late TextEditingController _tiktokAccountNameController;
  
  // Instagram
  late TextEditingController _instagramAccountIdController;
  late TextEditingController _instagramAccountNameController;
  
  // Threads
  late TextEditingController _threadsAccountIdController;
  late TextEditingController _threadsAccountNameController;
  
  // X (Twitter)
  late TextEditingController _xAccountIdController;
  late TextEditingController _xAccountNameController;

  @override
  void initState() {
    super.initState();
    final social = widget.avatar.socialLinks;
    
    _youtubeChannelIdController = TextEditingController(text: social.youtube.accountId);
    _youtubeChannelNameController = TextEditingController(text: social.youtube.accountName);
    
    _tiktokAccountIdController = TextEditingController(text: social.tiktok.accountId);
    _tiktokAccountNameController = TextEditingController(text: social.tiktok.accountName);
    
    _instagramAccountIdController = TextEditingController(text: social.instagram.accountId);
    _instagramAccountNameController = TextEditingController(text: social.instagram.accountName);
    
    _threadsAccountIdController = TextEditingController(text: social.threads.accountId);
    _threadsAccountNameController = TextEditingController(text: social.threads.accountName);
    
    _xAccountIdController = TextEditingController(text: social.x.accountId);
    _xAccountNameController = TextEditingController(text: social.x.accountName);
  }

  @override
  void dispose() {
    _youtubeChannelIdController.dispose();
    _youtubeChannelNameController.dispose();
    _tiktokAccountIdController.dispose();
    _tiktokAccountNameController.dispose();
    _instagramAccountIdController.dispose();
    _instagramAccountNameController.dispose();
    _threadsAccountIdController.dispose();
    _threadsAccountNameController.dispose();
    _xAccountIdController.dispose();
    _xAccountNameController.dispose();
    super.dispose();
  }

  void _updateSocialLinks() {
    widget.onUpdate(widget.avatar.copyWith(
      socialLinks: AvatarSocialLinks(
        youtube: SocialAccount(
          accountId: _youtubeChannelIdController.text,
          accountName: _youtubeChannelNameController.text,
        ),
        tiktok: SocialAccount(
          accountId: _tiktokAccountIdController.text,
          accountName: _tiktokAccountNameController.text,
        ),
        instagram: SocialAccount(
          accountId: _instagramAccountIdController.text,
          accountName: _instagramAccountNameController.text,
        ),
        threads: SocialAccount(
          accountId: _threadsAccountIdController.text,
          accountName: _threadsAccountNameController.text,
        ),
        x: SocialAccount(
          accountId: _xAccountIdController.text,
          accountName: _xAccountNameController.text,
        ),
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
          // 説明
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.info, color: AppColors.info, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'このアバターが担当するSNSアカウントを紐付けます。\n分析データの取得に使用されます。',
                    style: TextStyle(
                      color: AppColors.info.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // YouTube
          _buildPlatformSection(
            icon: LucideIcons.youtube,
            name: 'YouTube',
            color: AppColors.youtube,
            idController: _youtubeChannelIdController,
            nameController: _youtubeChannelNameController,
            idLabel: 'チャンネルID',
            idHint: 'UCxxxxxxxxxx',
            nameLabel: 'チャンネル名',
            nameHint: '信長の人生相談',
          ),
          const SizedBox(height: 24),

          // TikTok
          _buildPlatformSection(
            icon: LucideIcons.music,
            name: 'TikTok',
            color: Colors.black,
            idController: _tiktokAccountIdController,
            nameController: _tiktokAccountNameController,
            idLabel: 'ユーザー名',
            idHint: '@nobunaga_advice',
            nameLabel: '表示名',
            nameHint: '信長の人生相談',
          ),
          const SizedBox(height: 24),

          // Instagram
          _buildPlatformSection(
            icon: LucideIcons.instagram,
            name: 'Instagram',
            color: AppColors.instagram,
            idController: _instagramAccountIdController,
            nameController: _instagramAccountNameController,
            idLabel: 'ユーザー名',
            idHint: '@nobunaga_advice',
            nameLabel: '表示名',
            nameHint: '信長の人生相談',
          ),
          const SizedBox(height: 24),

          // Threads
          _buildPlatformSection(
            icon: LucideIcons.atSign,
            name: 'Threads',
            color: Colors.black,
            idController: _threadsAccountIdController,
            nameController: _threadsAccountNameController,
            idLabel: 'ユーザー名',
            idHint: '@nobunaga_advice',
            nameLabel: '表示名',
            nameHint: '信長の人生相談',
          ),
          const SizedBox(height: 24),

          // X (Twitter)
          _buildPlatformSection(
            icon: LucideIcons.twitter,
            name: 'X (Twitter)',
            color: AppColors.twitter,
            idController: _xAccountIdController,
            nameController: _xAccountNameController,
            idLabel: 'ユーザー名',
            idHint: '@nobunaga_advice',
            nameLabel: '表示名',
            nameHint: '信長の人生相談',
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildPlatformSection({
    required IconData icon,
    required String name,
    required Color color,
    required TextEditingController idController,
    required TextEditingController nameController,
    required String idLabel,
    required String idHint,
    required String nameLabel,
    required String nameHint,
  }) {
    final isConnected = idController.text.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected ? color.withOpacity(0.5) : AppColors.surfaceLight,
          width: isConnected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isConnected
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConnected ? LucideIcons.link : LucideIcons.unlink,
                      size: 12,
                      color: isConnected ? AppColors.success : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isConnected ? '連携中' : '未連携',
                      style: TextStyle(
                        fontSize: 11,
                        color: isConnected ? AppColors.success : AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // ID入力
          TextField(
            controller: idController,
            decoration: InputDecoration(
              labelText: idLabel,
              hintText: idHint,
              prefixIcon: const Icon(LucideIcons.hash, size: 18),
              filled: true,
              fillColor: AppColors.surfaceLight.withOpacity(0.5),
            ),
            onChanged: (_) => _updateSocialLinks(),
          ),
          const SizedBox(height: 12),
          
          // 名前入力
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: nameLabel,
              hintText: nameHint,
              prefixIcon: const Icon(LucideIcons.type, size: 18),
              filled: true,
              fillColor: AppColors.surfaceLight.withOpacity(0.5),
            ),
            onChanged: (_) => _updateSocialLinks(),
          ),
          
          // 連携中の場合は追加情報を表示
          if (isConnected) ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.surfaceLight),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatChip(
                  icon: LucideIcons.users,
                  label: '-- フォロワー',
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  icon: LucideIcons.fileVideo,
                  label: '-- 投稿',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '※ 分析データは連携後に取得されます',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}