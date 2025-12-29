import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/avatar.dart';
import '../config/theme.dart';
import '../providers/avatar_provider.dart';
import 'avatar_edit_screen.dart';

/// アバター一覧画面
class AvatarListScreen extends ConsumerStatefulWidget {
  const AvatarListScreen({super.key});

  @override
  ConsumerState<AvatarListScreen> createState() => _AvatarListScreenState();
}

class _AvatarListScreenState extends ConsumerState<AvatarListScreen> {
  AvatarStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final avatarState = ref.watch(avatarListProvider);
    final filteredAvatars = _filterStatus == null
        ? avatarState.avatars
        : avatarState.avatars.where((a) => a.status == _filterStatus).toList();

    return Scaffold(
      body: avatarState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : avatarState.error != null
              ? _buildErrorState(avatarState.error!)
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildHeader(avatarState.avatars.length),
                    ),
                    SliverToBoxAdapter(
                      child: _buildFilterChips(),
                    ),
                    if (filteredAvatars.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildEmptyState(),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.all(AppConstants.paddingMD),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _buildAvatarCard(filteredAvatars[index]),
                            childCount: filteredAvatars.length,
                          ),
                        ),
                      ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewAvatar(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('新規作成'),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.alertCircle,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'エラーが発生しました',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(avatarListProvider.notifier).loadAvatars();
            },
            icon: const Icon(LucideIcons.refreshCw),
            label: const Text('再読み込み'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.users,
              size: 64,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _filterStatus == null
                  ? 'アバターがありません'
                  : '該当するアバターがありません',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _filterStatus == null
                  ? '新しいアバターを作成してください'
                  : 'フィルターを変更してください',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int totalCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  LucideIcons.users,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'アバター管理',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalCount体のアバターを管理中',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(null, 'すべて', LucideIcons.layoutGrid),
          const SizedBox(width: 8),
          _buildFilterChip(
              AvatarStatus.active, '公開中', LucideIcons.checkCircle),
          const SizedBox(width: 8),
          _buildFilterChip(AvatarStatus.draft, '準備中', LucideIcons.pencil),
          const SizedBox(width: 8),
          _buildFilterChip(
              AvatarStatus.inactive, '停止中', LucideIcons.pauseCircle),
        ],
      ),
    );
  }

  Widget _buildFilterChip(AvatarStatus? status, String label, IconData icon) {
    final isSelected = _filterStatus == status;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      onSelected: (_) => setState(() => _filterStatus = status),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        decoration: TextDecoration.none,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
        ),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildAvatarCard(Avatar avatar) {
    return GestureDetector(
      onTap: () => _navigateToEdit(avatar),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.surfaceLight,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: avatar.visual.profileImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: avatar.visual.profileImageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) => Container(
                              color: AppColors.surfaceLight,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _buildStatusBadge(avatar.status),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildLanguageBadge(avatar.language),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      avatar.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.mapPin,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${avatar.country} · ${avatar.era}',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      avatar.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (avatar.character.personality.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: avatar.character.personality
                            .take(3)
                            .map((tag) => _buildTag(tag))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceLight,
      child: const Center(
        child: Icon(
          LucideIcons.user,
          size: 48,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AvatarStatus status) {
    final config = _getStatusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageBadge(String language) {
    final flag = _getLanguageFlag(language);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        flag,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.primaryLight,
        ),
      ),
    );
  }

  ({Color color, IconData icon, String label}) _getStatusConfig(
      AvatarStatus status) {
    switch (status) {
      case AvatarStatus.active:
        return (
          color: AppColors.success,
          icon: LucideIcons.checkCircle,
          label: '公開中'
        );
      case AvatarStatus.draft:
        return (
          color: AppColors.warning,
          icon: LucideIcons.pencil,
          label: '準備中'
        );
      case AvatarStatus.inactive:
        return (
          color: AppColors.textMuted,
          icon: LucideIcons.pauseCircle,
          label: '停止中'
        );
    }
  }

  String _getLanguageFlag(String language) {
    switch (language) {
      case 'ja':
        return '🇯🇵';
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'es':
        return '🇪🇸';
      case 'pt':
        return '🇧🇷';
      case 'zh':
        return '🇨🇳';
      case 'ko':
        return '🇰🇷';
      default:
        return '🌐';
    }
  }

  Future<void> _createNewAvatar() async {
    try {
      final newAvatar =
          await ref.read(avatarListProvider.notifier).createAvatar();
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AvatarEditScreen(avatar: newAvatar),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(LucideIcons.alertCircle, color: AppColors.error),
                const SizedBox(width: 12),
                Text('作成に失敗しました: $e'),
              ],
            ),
            backgroundColor: AppColors.surface,
          ),
        );
      }
    }
  }

  void _navigateToEdit(Avatar avatar) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AvatarEditScreen(avatar: avatar),
      ),
    );
  }
}
