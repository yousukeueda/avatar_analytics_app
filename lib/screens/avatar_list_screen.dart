import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/avatar.dart';
import '../config/theme.dart';
import 'avatar_edit_screen.dart';

/// アバター一覧画面
class AvatarListScreen extends ConsumerStatefulWidget {
  const AvatarListScreen({super.key});

  @override
  ConsumerState<AvatarListScreen> createState() => _AvatarListScreenState();
}

class _AvatarListScreenState extends ConsumerState<AvatarListScreen> {
  AvatarStatus? _filterStatus;
  
  // TODO: Replace with actual data from Riverpod provider
  final List<Avatar> _mockAvatars = [
    Avatar(
      id: '1',
      name: '織田信長',
      country: '日本',
      language: 'ja',
      era: '戦国時代',
      title: '天下統一を目指した革命児',
      status: AvatarStatus.active,
      visual: AvatarVisual(
        profileImageUrl: 'https://picsum.photos/200?random=1',
      ),
      character: AvatarCharacter(
        personality: ['野心的', '革新的', '短気'],
        firstPerson: 'わし',
        catchphrases: ['是非もなし', 'であるか'],
      ),
    ),
    Avatar(
      id: '2',
      name: 'Napoleon Bonaparte',
      country: 'フランス',
      language: 'fr',
      era: '19世紀',
      title: 'フランス皇帝',
      status: AvatarStatus.draft,
      visual: AvatarVisual(
        profileImageUrl: 'https://picsum.photos/200?random=2',
      ),
      character: AvatarCharacter(
        personality: ['戦略的', '野心的', 'カリスマ'],
        firstPerson: 'Je',
      ),
    ),
    Avatar(
      id: '3',
      name: 'Cleopatra',
      country: 'エジプト',
      language: 'en',
      era: '古代',
      title: '最後のファラオ',
      status: AvatarStatus.inactive,
      visual: AvatarVisual(
        profileImageUrl: 'https://picsum.photos/200?random=3',
      ),
      character: AvatarCharacter(
        personality: ['知的', '魅力的', '政治的'],
      ),
    ),
  ];

  List<Avatar> get _filteredAvatars {
    if (_filterStatus == null) return _mockAvatars;
    return _mockAvatars.where((a) => a.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ヘッダー
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          
          // フィルターチップ
          SliverToBoxAdapter(
            child: _buildFilterChips(),
          ),
          
          // アバターグリッド
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMD),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildAvatarCard(_filteredAvatars[index]),
                childCount: _filteredAvatars.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreate(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('新規作成'),
      ),
    );
  }

  Widget _buildHeader() {
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
                    '${_mockAvatars.length}体のアバターを管理中',
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
          _buildFilterChip(AvatarStatus.active, '公開中', LucideIcons.checkCircle),
          const SizedBox(width: 8),
          _buildFilterChip(AvatarStatus.draft, '準備中', LucideIcons.pencil),
          const SizedBox(width: 8),
          _buildFilterChip(AvatarStatus.inactive, '停止中', LucideIcons.pauseCircle),
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
            // 画像エリア
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // プロフィール画像
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
                            errorWidget: (context, url, error) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  
                  // グラデーションオーバーレイ
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
                  
                  // ステータスバッジ
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _buildStatusBadge(avatar.status),
                  ),
                  
                  // 言語バッジ
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildLanguageBadge(avatar.language),
                  ),
                  
                  // 名前（画像上）
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
            
            // 情報エリア
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 時代と国
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // タイトル/説明
                    Text(
                      avatar.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    // 性格タグ
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

  ({Color color, IconData icon, String label}) _getStatusConfig(AvatarStatus status) {
    switch (status) {
      case AvatarStatus.active:
        return (color: AppColors.success, icon: LucideIcons.checkCircle, label: '公開中');
      case AvatarStatus.draft:
        return (color: AppColors.warning, icon: LucideIcons.pencil, label: '準備中');
      case AvatarStatus.inactive:
        return (color: AppColors.textMuted, icon: LucideIcons.pauseCircle, label: '停止中');
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

  void _navigateToCreate() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AvatarEditScreen(),
      ),
    );
  }

  void _navigateToEdit(Avatar avatar) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AvatarEditScreen(avatar: avatar),
      ),
    );
  }
}