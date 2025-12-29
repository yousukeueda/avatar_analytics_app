import 'dart:convert';

import '../models/avatar.dart';

/// アバターデータへのアクセスを抽象化するリポジトリ
abstract class AvatarRepository {
  /// 全アバターを取得
  Future<List<Avatar>> getAll();

  /// IDでアバターを取得
  Future<Avatar?> getById(String id);

  /// アバターを作成
  Future<Avatar> create(Avatar avatar);

  /// アバターを更新
  Future<Avatar> update(Avatar avatar);

  /// アバターを削除
  Future<void> delete(String id);

  /// アバターを複製
  Future<Avatar> duplicate(Avatar avatar);
}

/// メモリ内ストレージを使用したリポジトリ実装
/// 開発・テスト用。本番ではAPIリポジトリに置き換え
class InMemoryAvatarRepository implements AvatarRepository {
  final Map<String, Avatar> _avatars = {};

  InMemoryAvatarRepository() {
    // モックデータで初期化
    _initializeMockData();
  }

  void _initializeMockData() {
    final mockAvatars = [
      Avatar(
        id: 'avatar-001',
        name: 'ソフィア',
        country: 'アメリカ',
        language: 'en',
        era: '現代',
        title: 'AIアシスタント',
        description: 'フレンドリーで知識豊富なAIアシスタント。テクノロジーとクリエイティブな話題が得意。',
        status: AvatarStatus.active,
        visual: const AvatarVisual(
          profileImageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
        ),
        character: const AvatarCharacter(
          personality: ['フレンドリー', 'クリエイティブ', '知的'],
          firstPerson: 'I',
          speechStyle: 'casual',
          catchphrases: ['Let me help you with that!', 'Interesting question!'],
          signatureLine: 'Making tech accessible for everyone.',
        ),
        aiSettings: const AvatarAISettings(
          systemPrompt: 'You are Sophia, a friendly AI assistant.',
          temperature: 0.7,
          maxTokens: 1000,
        ),
      ),
      Avatar(
        id: 'avatar-002',
        name: '健太',
        country: '日本',
        language: 'ja',
        era: '現代',
        title: 'ゲーム実況者',
        description: '明るく元気なゲーム実況者。FPSとRPGが得意で、視聴者との交流を大切にしている。',
        status: AvatarStatus.active,
        visual: const AvatarVisual(
          profileImageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
        ),
        character: const AvatarCharacter(
          personality: ['元気', 'ポジティブ', '熱血'],
          firstPerson: '俺',
          speechStyle: 'energetic',
          catchphrases: ['いくぜー！', 'ナイス！'],
          signatureLine: 'ゲームで世界をつなぐ！',
        ),
        aiSettings: const AvatarAISettings(
          systemPrompt: 'あなたは健太、元気なゲーム実況者です。',
          temperature: 0.9,
          maxTokens: 800,
        ),
      ),
      Avatar(
        id: 'avatar-003',
        name: 'エマ',
        country: 'イギリス',
        language: 'en',
        era: 'ヴィクトリア朝',
        title: '歴史ガイド',
        description: 'ヴィクトリア朝時代の知識が豊富な歴史ガイド。上品で教養のある話し方が特徴。',
        status: AvatarStatus.draft,
        visual: const AvatarVisual(
          profileImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
        ),
        character: const AvatarCharacter(
          personality: ['上品', '教養', '穏やか'],
          firstPerson: 'I',
          speechStyle: 'formal',
          catchphrases: ['How fascinating!', 'Allow me to explain...'],
          signatureLine: 'History shapes our future.',
        ),
        aiSettings: const AvatarAISettings(
          systemPrompt: 'You are Emma, a Victorian-era history guide.',
          temperature: 0.6,
          maxTokens: 1200,
        ),
      ),
    ];

    for (final avatar in mockAvatars) {
      _avatars[avatar.id] = avatar;
    }
  }

  @override
  Future<List<Avatar>> getAll() async {
    // 実際のAPIコールをシミュレート
    await Future.delayed(const Duration(milliseconds: 300));
    return _avatars.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<Avatar?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _avatars[id];
  }

  @override
  Future<Avatar> create(Avatar avatar) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _avatars[avatar.id] = avatar;
    return avatar;
  }

  @override
  Future<Avatar> update(Avatar avatar) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_avatars.containsKey(avatar.id)) {
      throw Exception('Avatar not found: ${avatar.id}');
    }
    final updated = avatar.copyWith();
    _avatars[avatar.id] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_avatars.containsKey(id)) {
      throw Exception('Avatar not found: $id');
    }
    _avatars.remove(id);
  }

  @override
  Future<Avatar> duplicate(Avatar avatar) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newId = 'avatar-${DateTime.now().millisecondsSinceEpoch}';
    final duplicated = Avatar(
      id: newId,
      name: '${avatar.name} (コピー)',
      country: avatar.country,
      language: avatar.language,
      era: avatar.era,
      title: avatar.title,
      description: avatar.description,
      status: AvatarStatus.draft,
      visual: avatar.visual,
      character: avatar.character,
      aiSettings: avatar.aiSettings,
      voiceSettings: avatar.voiceSettings,
      socialLinks: avatar.socialLinks,
    );
    _avatars[newId] = duplicated;
    return duplicated;
  }
}

/// 将来のAPI実装用のプレースホルダー
class ApiAvatarRepository implements AvatarRepository {
  final String baseUrl;

  ApiAvatarRepository({required this.baseUrl});

  @override
  Future<List<Avatar>> getAll() async {
    // TODO: HTTP GET /avatars
    throw UnimplementedError('API repository not yet implemented');
  }

  @override
  Future<Avatar?> getById(String id) async {
    // TODO: HTTP GET /avatars/:id
    throw UnimplementedError('API repository not yet implemented');
  }

  @override
  Future<Avatar> create(Avatar avatar) async {
    // TODO: HTTP POST /avatars
    throw UnimplementedError('API repository not yet implemented');
  }

  @override
  Future<Avatar> update(Avatar avatar) async {
    // TODO: HTTP PUT /avatars/:id
    throw UnimplementedError('API repository not yet implemented');
  }

  @override
  Future<void> delete(String id) async {
    // TODO: HTTP DELETE /avatars/:id
    throw UnimplementedError('API repository not yet implemented');
  }

  @override
  Future<Avatar> duplicate(Avatar avatar) async {
    // TODO: HTTP POST /avatars/:id/duplicate
    throw UnimplementedError('API repository not yet implemented');
  }
}
