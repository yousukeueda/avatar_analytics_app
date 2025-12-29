import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/avatar.dart';
import '../repositories/avatar_repository.dart';

/// リポジトリプロバイダー
final avatarRepositoryProvider = Provider<AvatarRepository>((ref) {
  return InMemoryAvatarRepository();
});

/// アバター一覧の状態
class AvatarListState {
  final List<Avatar> avatars;
  final bool isLoading;
  final String? error;

  const AvatarListState({
    this.avatars = const [],
    this.isLoading = false,
    this.error,
  });

  AvatarListState copyWith({
    List<Avatar>? avatars,
    bool? isLoading,
    String? error,
  }) {
    return AvatarListState(
      avatars: avatars ?? this.avatars,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// アバター一覧のNotifier
class AvatarListNotifier extends StateNotifier<AvatarListState> {
  final AvatarRepository _repository;
  final Uuid _uuid = const Uuid();

  AvatarListNotifier(this._repository) : super(const AvatarListState()) {
    loadAvatars();
  }

  /// アバター一覧を読み込む
  Future<void> loadAvatars() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final avatars = await _repository.getAll();
      state = state.copyWith(avatars: avatars, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 新規アバターを作成
  Future<Avatar> createAvatar({String? name}) async {
    final avatar = Avatar(
      id: _uuid.v4(),
      name: name ?? '新規アバター',
      status: AvatarStatus.draft,
    );
    try {
      final created = await _repository.create(avatar);
      state = state.copyWith(avatars: [created, ...state.avatars]);
      return created;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// アバターを更新
  Future<void> updateAvatar(Avatar avatar) async {
    try {
      final updated = await _repository.update(avatar);
      final index = state.avatars.indexWhere((a) => a.id == avatar.id);
      if (index != -1) {
        final newList = [...state.avatars];
        newList[index] = updated;
        state = state.copyWith(avatars: newList);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// アバターを削除
  Future<void> deleteAvatar(String id) async {
    try {
      await _repository.delete(id);
      state = state.copyWith(
        avatars: state.avatars.where((a) => a.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// アバターを複製
  Future<Avatar> duplicateAvatar(Avatar avatar) async {
    try {
      final duplicated = await _repository.duplicate(avatar);
      state = state.copyWith(avatars: [duplicated, ...state.avatars]);
      return duplicated;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// ステータスでフィルター
  List<Avatar> filterByStatus(AvatarStatus? status) {
    if (status == null) return state.avatars;
    return state.avatars.where((a) => a.status == status).toList();
  }
}

/// アバター一覧プロバイダー
final avatarListProvider =
    StateNotifierProvider<AvatarListNotifier, AvatarListState>((ref) {
  final repository = ref.watch(avatarRepositoryProvider);
  return AvatarListNotifier(repository);
});

/// 単一アバター取得プロバイダー
final avatarProvider = FutureProvider.family<Avatar?, String>((ref, id) async {
  final repository = ref.watch(avatarRepositoryProvider);
  return repository.getById(id);
});

/// 編集中のアバター状態
class AvatarEditState {
  final Avatar? original;
  final Avatar? current;
  final bool isSaving;
  final bool hasChanges;
  final String? error;

  const AvatarEditState({
    this.original,
    this.current,
    this.isSaving = false,
    this.hasChanges = false,
    this.error,
  });

  AvatarEditState copyWith({
    Avatar? original,
    Avatar? current,
    bool? isSaving,
    bool? hasChanges,
    String? error,
  }) {
    return AvatarEditState(
      original: original ?? this.original,
      current: current ?? this.current,
      isSaving: isSaving ?? this.isSaving,
      hasChanges: hasChanges ?? this.hasChanges,
      error: error,
    );
  }
}

/// アバター編集用Notifier
class AvatarEditNotifier extends StateNotifier<AvatarEditState> {
  final AvatarListNotifier _listNotifier;

  AvatarEditNotifier(this._listNotifier) : super(const AvatarEditState());

  /// 編集対象のアバターをセット
  void setAvatar(Avatar avatar) {
    state = AvatarEditState(
      original: avatar,
      current: avatar,
      hasChanges: false,
    );
  }

  /// アバターを更新（ローカル状態のみ）
  void updateAvatar(Avatar avatar) {
    state = state.copyWith(
      current: avatar,
      hasChanges: true,
    );
  }

  /// 変更を保存
  Future<void> save() async {
    if (state.current == null) return;

    state = state.copyWith(isSaving: true, error: null);
    try {
      await _listNotifier.updateAvatar(state.current!);
      state = state.copyWith(
        original: state.current,
        isSaving: false,
        hasChanges: false,
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      rethrow;
    }
  }

  /// 変更を破棄
  void discard() {
    state = state.copyWith(
      current: state.original,
      hasChanges: false,
    );
  }

  /// リセット
  void reset() {
    state = const AvatarEditState();
  }
}

/// アバター編集プロバイダー
final avatarEditProvider =
    StateNotifierProvider<AvatarEditNotifier, AvatarEditState>((ref) {
  final listNotifier = ref.watch(avatarListProvider.notifier);
  return AvatarEditNotifier(listNotifier);
});
