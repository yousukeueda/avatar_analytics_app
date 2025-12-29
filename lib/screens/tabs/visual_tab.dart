import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/avatar.dart';
import '../../config/theme.dart';

class VisualTab extends StatefulWidget {
  final Avatar avatar;
  final Function(Avatar) onUpdate;

  const VisualTab({
    super.key,
    required this.avatar,
    required this.onUpdate,
  });

  @override
  State<VisualTab> createState() => _VisualTabState();
}

class _VisualTabState extends State<VisualTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: LucideIcons.userCircle,
            title: 'プロフィール画像',
            subtitle: 'アバターのメイン画像（推奨: 500x500px以上）',
          ),
          const SizedBox(height: 16),
          _buildProfileImageUploader(),
          const SizedBox(height: 32),

          _buildSectionHeader(
            icon: LucideIcons.video,
            title: 'アバター動画',
            subtitle: 'Simliなどで生成したアバター動画',
          ),
          const SizedBox(height: 16),
          _buildVideoUploader(),
          const SizedBox(height: 32),

          _buildSectionHeader(
            icon: LucideIcons.image,
            title: 'サムネイル素材',
            subtitle: 'YouTube/TikTok用のサムネイル素材',
          ),
          const SizedBox(height: 16),
          _buildThumbnailGallery(),
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

  Widget _buildProfileImageUploader() {
    final imageUrl = widget.avatar.visual.profileImageUrl;
    return Center(
      child: GestureDetector(
        onTap: _pickProfileImage,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surfaceLight, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: imageUrl != null
                ? CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
                : _buildPlaceholder(LucideIcons.upload, '画像をアップロード'),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoUploader() {
    final videoUrl = widget.avatar.visual.avatarVideoUrl;
    return GestureDetector(
      onTap: _pickVideo,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: videoUrl != null
            ? Center(child: Icon(LucideIcons.playCircle, size: 64, color: AppColors.primary))
            : _buildPlaceholder(LucideIcons.video, '動画をアップロード'),
      ),
    );
  }

  Widget _buildPlaceholder(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 36, color: AppColors.textMuted),
        const SizedBox(height: 12),
        Text(text, style: const TextStyle(color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildThumbnailGallery() {
    final thumbnails = widget.avatar.visual.thumbnailAssets;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 16 / 9,
      ),
      itemCount: thumbnails.length + 1,
      itemBuilder: (context, index) {
        if (index == thumbnails.length) {
          return GestureDetector(
            onTap: _pickThumbnail,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceLight),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.plus, color: AppColors.textMuted),
                  Text('追加', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(imageUrl: thumbnails[index], fit: BoxFit.cover),
        );
      },
    );
  }

  void _pickProfileImage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('画像選択機能は実装予定です')),
    );
  }

  void _pickVideo() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('動画選択機能は実装予定です')),
    );
  }

  void _pickThumbnail() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('サムネイル追加機能は実装予定です')),
    );
  }
}