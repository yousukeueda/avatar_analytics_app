import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/avatar.dart';
import '../config/theme.dart';
import '../providers/avatar_provider.dart';
import 'tabs/basic_info_tab.dart';
import 'tabs/visual_tab.dart';
import 'tabs/character_tab.dart';
import 'tabs/ai_settings_tab.dart';
import 'tabs/voice_settings_tab.dart';
import 'tabs/social_links_tab.dart';

/// アバター編集画面
class AvatarEditScreen extends ConsumerStatefulWidget {
  final Avatar? avatar;

  const AvatarEditScreen({super.key, this.avatar});

  @override
  ConsumerState<AvatarEditScreen> createState() => _AvatarEditScreenState();
}

class _AvatarEditScreenState extends ConsumerState<AvatarEditScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Avatar _editingAvatar;
  bool _hasChanges = false;
  bool _isSaving = false;

  final List<_TabDefinition> _tabs = [
    _TabDefinition(
      icon: LucideIcons.fileText,
      label: '基本情報',
    ),
    _TabDefinition(
      icon: LucideIcons.image,
      label: 'ビジュアル',
    ),
    _TabDefinition(
      icon: LucideIcons.sparkles,
      label: 'キャラ設定',
    ),
    _TabDefinition(
      icon: LucideIcons.brain,
      label: 'AI設定',
    ),
    _TabDefinition(
      icon: LucideIcons.mic,
      label: '音声設定',
    ),
    _TabDefinition(
      icon: LucideIcons.share2,
      label: 'SNS連携',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _editingAvatar = widget.avatar ??
        Avatar(
          id: '',
          name: '',
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isNewAvatar => widget.avatar == null || widget.avatar!.name.isEmpty;

  void _updateAvatar(Avatar updatedAvatar) {
    setState(() {
      _editingAvatar = updatedAvatar;
      _hasChanges = true;
    });
  }

  Future<void> _saveAvatar() async {
    if (_editingAvatar.name.isEmpty) {
      _showError('名前を入力してください');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(avatarListProvider.notifier);
      await notifier.updateAvatar(_editingAvatar);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(LucideIcons.checkCircle, color: AppColors.success),
                const SizedBox(width: 12),
                Text(_isNewAvatar ? 'アバターを作成しました' : '変更を保存しました'),
              ],
            ),
            backgroundColor: AppColors.surface,
          ),
        );
        setState(() => _hasChanges = false);
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError('保存に失敗しました: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.alertCircle, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: AppColors.success),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('変更を破棄しますか？'),
        content: const Text('保存されていない変更があります。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('破棄'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildAppBar(innerBoxIsScrolled),
              _buildTabBar(),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              BasicInfoTab(
                avatar: _editingAvatar,
                onUpdate: _updateAvatar,
              ),
              VisualTab(
                avatar: _editingAvatar,
                onUpdate: _updateAvatar,
              ),
              CharacterTab(
                avatar: _editingAvatar,
                onUpdate: _updateAvatar,
              ),
              AISettingsTab(
                avatar: _editingAvatar,
                onUpdate: _updateAvatar,
              ),
              VoiceSettingsTab(
                avatar: _editingAvatar,
                onUpdate: _updateAvatar,
              ),
              SocialLinksTab(
                avatar: _editingAvatar,
                onUpdate: _updateAvatar,
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      forceElevated: innerBoxIsScrolled,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft),
        onPressed: () async {
          if (!_hasChanges || await _onWillPop()) {
            if (mounted) Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        if (!_isNewAvatar)
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(LucideIcons.copy, size: 18),
                    SizedBox(width: 12),
                    Text('複製'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 18, color: AppColors.error),
                    SizedBox(width: 12),
                    Text('削除', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: Text(
          _isNewAvatar ? '新規アバター作成' : _editingAvatar.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.3),
                AppColors.background,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary.withOpacity(0.2),
          ),
          tabs: _tabs.map((tab) {
            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tab.icon, size: 18),
                  const SizedBox(width: 8),
                  Text(tab.label),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.surfaceLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (!_isNewAvatar)
            Expanded(
              child: _buildStatusSelector(),
            ),
          const SizedBox(width: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveAvatar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      children: [
                        const Icon(LucideIcons.save, size: 18),
                        const SizedBox(width: 8),
                        Text(_isNewAvatar ? '作成' : '保存'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AvatarStatus>(
          value: _editingAvatar.status,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          items: AvatarStatus.values.map((status) {
            final config = _getStatusConfig(status);
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  Icon(config.icon, size: 16, color: config.color),
                  const SizedBox(width: 8),
                  Text(config.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _updateAvatar(_editingAvatar.copyWith(status: value));
            }
          },
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

  void _handleMenuAction(String action) {
    switch (action) {
      case 'duplicate':
        _duplicateAvatar();
        break;
      case 'delete':
        _confirmDelete();
        break;
    }
  }

  Future<void> _duplicateAvatar() async {
    try {
      final duplicated = await ref
          .read(avatarListProvider.notifier)
          .duplicateAvatar(_editingAvatar);

      if (mounted) {
        _showSuccess('アバターを複製しました');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AvatarEditScreen(avatar: duplicated),
          ),
        );
      }
    } catch (e) {
      _showError('複製に失敗しました: $e');
    }
  }

  Future<void> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アバターを削除'),
        content: Text(
            '「${_editingAvatar.name}」を削除してもよろしいですか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      try {
        await ref
            .read(avatarListProvider.notifier)
            .deleteAvatar(_editingAvatar.id);

        if (mounted) {
          _showSuccess('アバターを削除しました');
          Navigator.of(context).pop();
        }
      } catch (e) {
        _showError('削除に失敗しました: $e');
      }
    }
  }
}

class _TabDefinition {
  final IconData icon;
  final String label;

  _TabDefinition({required this.icon, required this.label});
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
