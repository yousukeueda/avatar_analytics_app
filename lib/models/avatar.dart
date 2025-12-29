enum AvatarStatus { active, draft, inactive }

class AvatarVisual {
  final String? profileImageUrl;
  final String? avatarVideoUrl;
  final List<String> thumbnailAssets;

  AvatarVisual({this.profileImageUrl, this.avatarVideoUrl, this.thumbnailAssets = const []});

  Map<String, dynamic> toMap() => {
    'profileImageUrl': profileImageUrl,
    'avatarVideoUrl': avatarVideoUrl,
    'thumbnailAssets': thumbnailAssets,
  };
}

class AvatarCharacter {
  final List<String> personality;
  final String firstPerson;
  final String speechStyle;
  final List<String> catchphrases;
  final String signatureLine;

  AvatarCharacter({
    this.personality = const [],
    this.firstPerson = '',
    this.speechStyle = '',
    this.catchphrases = const [],
    this.signatureLine = '',
  });

  Map<String, dynamic> toMap() => {
    'personality': personality,
    'firstPerson': firstPerson,
    'speechStyle': speechStyle,
    'catchphrases': catchphrases,
    'signatureLine': signatureLine,
  };
}

class AvatarAISettings {
  final String systemPrompt;
  final double temperature;
  final int maxTokens;

  AvatarAISettings({this.systemPrompt = '', this.temperature = 0.8, this.maxTokens = 1000});

  Map<String, dynamic> toMap() => {
    'systemPrompt': systemPrompt,
    'temperature': temperature,
    'maxTokens': maxTokens,
  };
}

class AvatarVoiceSettings {
  final String elevenLabsVoiceId;
  final double stability;
  final double similarityBoost;
  final String? sampleAudioUrl;

  AvatarVoiceSettings({
    this.elevenLabsVoiceId = '',
    this.stability = 0.5,
    this.similarityBoost = 0.8,
    this.sampleAudioUrl,
  });

  Map<String, dynamic> toMap() => {
    'elevenLabsVoiceId': elevenLabsVoiceId,
    'stability': stability,
    'similarityBoost': similarityBoost,
    'sampleAudioUrl': sampleAudioUrl,
  };
}

class SocialAccount {
  final String? accountId;
  final String? accountName;
  final String? channelUrl;

  SocialAccount({this.accountId, this.accountName, this.channelUrl});

  Map<String, dynamic> toMap() => {
    'accountId': accountId,
    'accountName': accountName,
    'channelUrl': channelUrl,
  };
}

class AvatarSocialLinks {
  final SocialAccount youtube;
  final SocialAccount tiktok;
  final SocialAccount instagram;
  final SocialAccount threads;
  final SocialAccount x;

  AvatarSocialLinks({
    SocialAccount? youtube,
    SocialAccount? tiktok,
    SocialAccount? instagram,
    SocialAccount? threads,
    SocialAccount? x,
  })  : youtube = youtube ?? SocialAccount(),
        tiktok = tiktok ?? SocialAccount(),
        instagram = instagram ?? SocialAccount(),
        threads = threads ?? SocialAccount(),
        x = x ?? SocialAccount();

  Map<String, dynamic> toMap() => {
    'youtube': youtube.toMap(),
    'tiktok': tiktok.toMap(),
    'instagram': instagram.toMap(),
    'threads': threads.toMap(),
    'x': x.toMap(),
  };
}

class Avatar {
  final String id;
  final String name;
  final String country;
  final String language;
  final String era;
  final String title;
  final String description;
  final AvatarStatus status;
  final AvatarVisual visual;
  final AvatarCharacter character;
  final AvatarAISettings aiSettings;
  final AvatarVoiceSettings voiceSettings;
  final AvatarSocialLinks socialLinks;
  final DateTime createdAt;
  final DateTime updatedAt;

  Avatar({
    required this.id,
    required this.name,
    this.country = '',
    this.language = 'ja',
    this.era = '',
    this.title = '',
    this.description = '',
    this.status = AvatarStatus.draft,
    AvatarVisual? visual,
    AvatarCharacter? character,
    AvatarAISettings? aiSettings,
    AvatarVoiceSettings? voiceSettings,
    AvatarSocialLinks? socialLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : visual = visual ?? AvatarVisual(),
        character = character ?? AvatarCharacter(),
        aiSettings = aiSettings ?? AvatarAISettings(),
        voiceSettings = voiceSettings ?? AvatarVoiceSettings(),
        socialLinks = socialLinks ?? AvatarSocialLinks(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Avatar copyWith({
    String? id,
    String? name,
    String? country,
    String? language,
    String? era,
    String? title,
    String? description,
    AvatarStatus? status,
    AvatarVisual? visual,
    AvatarCharacter? character,
    AvatarAISettings? aiSettings,
    AvatarVoiceSettings? voiceSettings,
    AvatarSocialLinks? socialLinks,
  }) {
    return Avatar(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      language: language ?? this.language,
      era: era ?? this.era,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      visual: visual ?? this.visual,
      character: character ?? this.character,
      aiSettings: aiSettings ?? this.aiSettings,
      voiceSettings: voiceSettings ?? this.voiceSettings,
      socialLinks: socialLinks ?? this.socialLinks,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}