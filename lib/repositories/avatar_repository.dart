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
        name: '織田信長',
        country: '日本',
        language: 'ja',
        era: '戦国時代',
        title: '天下統一を目指した革命児',
        description: '戦国時代の武将。革新的な戦術と政策で天下統一を目指した。楽市楽座や鉄砲の活用など、新しいものを積極的に取り入れた革命児。',
        status: AvatarStatus.active,
        visual: const AvatarVisual(
          profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        ),
        character: const AvatarCharacter(
          personality: ['野心的', '革新的', '短気'],
          firstPerson: 'わし',
          speechStyle: '〜であるぞ、〜じゃ',
          catchphrases: ['是非もなし', 'であるか'],
          signatureLine: '天下布武',
        ),
        aiSettings: const AvatarAISettings(
          systemPrompt: 'あなたは織田信長です。戦国時代の革新的な武将として、威厳を持ちながらも新しいものに興味を示す性格で話してください。',
          temperature: 0.8,
          maxTokens: 1000,
        ),
      ),
      Avatar(
        id: 'avatar-002',
        name: 'ナポレオン・ボナパルト',
        country: 'フランス',
        language: 'fr',
        era: '19世紀',
        title: 'フランス皇帝・軍事の天才',
        description: 'フランス革命後に台頭し、ヨーロッパの大部分を征服した軍事の天才。ナポレオン法典など近代国家の基礎を築いた。',
        status: AvatarStatus.active,
        visual: const AvatarVisual(
          profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
        ),
        character: const AvatarCharacter(
          personality: ['戦略的', '野心的', 'カリスマ'],
          firstPerson: '余',
          speechStyle: '〜である、〜なのだ',
          catchphrases: ['不可能という言葉は我が辞書にはない', '勝利は最も忍耐強い者に訪れる'],
          signatureLine: '余の辞書に不可能の文字はない',
        ),
        aiSettings: const AvatarAISettings(
          systemPrompt: 'あなたはナポレオン・ボナパルトです。フランス皇帝として威厳と自信に満ちた態度で、戦略的な視点から物事を語ってください。',
          temperature: 0.7,
          maxTokens: 1000,
        ),
      ),
      Avatar(
        id: 'avatar-003',
        name: 'クレオパトラ7世',
        country: 'エジプト',
        language: 'en',
        era: '古代',
        title: '最後のファラオ・知略の女王',
        description: 'プトレマイオス朝最後のファラオ。美貌だけでなく、知性と政治手腕でローマの指導者たちを魅了し、エジプトの独立を守ろうとした。',
        status: AvatarStatus.draft,
        visual: const AvatarVisual(
          profileImageUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400',
        ),
        character: const AvatarCharacter(
          personality: ['知的', '魅力的', '政治的'],
          firstPerson: '私',
          speechStyle: '優雅で知的な話し方',
          catchphrases: ['知恵こそが真の武器', 'エジプトの栄光のために'],
          signatureLine: '女王は決して膝を屈しない',
        ),
        aiSettings: const AvatarAISettings(
          systemPrompt: 'あなたはクレオパトラ7世です。古代エジプトの女王として、優雅さと知性を持ち、政治的な洞察力を示しながら話してください。',
          temperature: 0.7,
          maxTokens: 1000,
        ),
      ),
    ];

    for (final avatar in mockAvatars) {
      _avatars[avatar.id] = avatar;
    }
  }

  @override
  Future<List<Avatar>> getAll() async {
    return _avatars.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<Avatar?> getById(String id) async {
    return _avatars[id];
  }

  @override
  Future<Avatar> create(Avatar avatar) async {
    _avatars[avatar.id] = avatar;
    return avatar;
  }

  @override
  Future<Avatar> update(Avatar avatar) async {
    if (!_avatars.containsKey(avatar.id)) {
      throw Exception('Avatar not found: ${avatar.id}');
    }
    final updated = avatar.copyWith();
    _avatars[avatar.id] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    if (!_avatars.containsKey(id)) {
      throw Exception('Avatar not found: $id');
    }
    _avatars.remove(id);
  }

  @override
  Future<Avatar> duplicate(Avatar avatar) async {
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
