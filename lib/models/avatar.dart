enum AvatarStatus { active, draft, inactive }

extension AvatarStatusExtension on AvatarStatus {
  String toJson() => name;

  static AvatarStatus fromJson(String json) {
    return AvatarStatus.values.firstWhere(
      (e) => e.name == json,
      orElse: () => AvatarStatus.draft,
    );
  }
}

class AvatarVisual {
  final String? profileImageUrl;
  final String? avatarVideoUrl;
  final List<String> thumbnailAssets;

  const AvatarVisual({
    this.profileImageUrl,
    this.avatarVideoUrl,
    this.thumbnailAssets = const [],
  });

  Map<String, dynamic> toJson() => {
        'profileImageUrl': profileImageUrl,
        'avatarVideoUrl': avatarVideoUrl,
        'thumbnailAssets': thumbnailAssets,
      };

  factory AvatarVisual.fromJson(Map<String, dynamic> json) {
    return AvatarVisual(
      profileImageUrl: json['profileImageUrl'] as String?,
      avatarVideoUrl: json['avatarVideoUrl'] as String?,
      thumbnailAssets: (json['thumbnailAssets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  AvatarVisual copyWith({
    String? profileImageUrl,
    String? avatarVideoUrl,
    List<String>? thumbnailAssets,
  }) {
    return AvatarVisual(
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      avatarVideoUrl: avatarVideoUrl ?? this.avatarVideoUrl,
      thumbnailAssets: thumbnailAssets ?? this.thumbnailAssets,
    );
  }
}

class AvatarCharacter {
  final List<String> personality;
  final String firstPerson;
  final String speechStyle;
  final List<String> catchphrases;
  final String signatureLine;

  const AvatarCharacter({
    this.personality = const [],
    this.firstPerson = '',
    this.speechStyle = '',
    this.catchphrases = const [],
    this.signatureLine = '',
  });

  Map<String, dynamic> toJson() => {
        'personality': personality,
        'firstPerson': firstPerson,
        'speechStyle': speechStyle,
        'catchphrases': catchphrases,
        'signatureLine': signatureLine,
      };

  factory AvatarCharacter.fromJson(Map<String, dynamic> json) {
    return AvatarCharacter(
      personality: (json['personality'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      firstPerson: json['firstPerson'] as String? ?? '',
      speechStyle: json['speechStyle'] as String? ?? '',
      catchphrases: (json['catchphrases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      signatureLine: json['signatureLine'] as String? ?? '',
    );
  }

  AvatarCharacter copyWith({
    List<String>? personality,
    String? firstPerson,
    String? speechStyle,
    List<String>? catchphrases,
    String? signatureLine,
  }) {
    return AvatarCharacter(
      personality: personality ?? this.personality,
      firstPerson: firstPerson ?? this.firstPerson,
      speechStyle: speechStyle ?? this.speechStyle,
      catchphrases: catchphrases ?? this.catchphrases,
      signatureLine: signatureLine ?? this.signatureLine,
    );
  }
}

class AvatarAISettings {
  final String systemPrompt;
  final double temperature;
  final int maxTokens;

  const AvatarAISettings({
    this.systemPrompt = '',
    this.temperature = 0.8,
    this.maxTokens = 1000,
  });

  Map<String, dynamic> toJson() => {
        'systemPrompt': systemPrompt,
        'temperature': temperature,
        'maxTokens': maxTokens,
      };

  factory AvatarAISettings.fromJson(Map<String, dynamic> json) {
    return AvatarAISettings(
      systemPrompt: json['systemPrompt'] as String? ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.8,
      maxTokens: json['maxTokens'] as int? ?? 1000,
    );
  }

  AvatarAISettings copyWith({
    String? systemPrompt,
    double? temperature,
    int? maxTokens,
  }) {
    return AvatarAISettings(
      systemPrompt: systemPrompt ?? this.systemPrompt,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
    );
  }
}

class AvatarVoiceSettings {
  final String elevenLabsVoiceId;
  final double stability;
  final double similarityBoost;
  final String? sampleAudioUrl;

  const AvatarVoiceSettings({
    this.elevenLabsVoiceId = '',
    this.stability = 0.5,
    this.similarityBoost = 0.8,
    this.sampleAudioUrl,
  });

  Map<String, dynamic> toJson() => {
        'elevenLabsVoiceId': elevenLabsVoiceId,
        'stability': stability,
        'similarityBoost': similarityBoost,
        'sampleAudioUrl': sampleAudioUrl,
      };

  factory AvatarVoiceSettings.fromJson(Map<String, dynamic> json) {
    return AvatarVoiceSettings(
      elevenLabsVoiceId: json['elevenLabsVoiceId'] as String? ?? '',
      stability: (json['stability'] as num?)?.toDouble() ?? 0.5,
      similarityBoost: (json['similarityBoost'] as num?)?.toDouble() ?? 0.8,
      sampleAudioUrl: json['sampleAudioUrl'] as String?,
    );
  }

  AvatarVoiceSettings copyWith({
    String? elevenLabsVoiceId,
    double? stability,
    double? similarityBoost,
    String? sampleAudioUrl,
  }) {
    return AvatarVoiceSettings(
      elevenLabsVoiceId: elevenLabsVoiceId ?? this.elevenLabsVoiceId,
      stability: stability ?? this.stability,
      similarityBoost: similarityBoost ?? this.similarityBoost,
      sampleAudioUrl: sampleAudioUrl ?? this.sampleAudioUrl,
    );
  }
}

class SocialAccount {
  final String? accountId;
  final String? accountName;
  final String? channelUrl;

  const SocialAccount({
    this.accountId,
    this.accountName,
    this.channelUrl,
  });

  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'accountName': accountName,
        'channelUrl': channelUrl,
      };

  factory SocialAccount.fromJson(Map<String, dynamic> json) {
    return SocialAccount(
      accountId: json['accountId'] as String?,
      accountName: json['accountName'] as String?,
      channelUrl: json['channelUrl'] as String?,
    );
  }

  SocialAccount copyWith({
    String? accountId,
    String? accountName,
    String? channelUrl,
  }) {
    return SocialAccount(
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      channelUrl: channelUrl ?? this.channelUrl,
    );
  }

  bool get isEmpty =>
      (accountId == null || accountId!.isEmpty) &&
      (accountName == null || accountName!.isEmpty) &&
      (channelUrl == null || channelUrl!.isEmpty);
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
  })  : youtube = youtube ?? const SocialAccount(),
        tiktok = tiktok ?? const SocialAccount(),
        instagram = instagram ?? const SocialAccount(),
        threads = threads ?? const SocialAccount(),
        x = x ?? const SocialAccount();

  Map<String, dynamic> toJson() => {
        'youtube': youtube.toJson(),
        'tiktok': tiktok.toJson(),
        'instagram': instagram.toJson(),
        'threads': threads.toJson(),
        'x': x.toJson(),
      };

  factory AvatarSocialLinks.fromJson(Map<String, dynamic> json) {
    return AvatarSocialLinks(
      youtube: json['youtube'] != null
          ? SocialAccount.fromJson(json['youtube'] as Map<String, dynamic>)
          : null,
      tiktok: json['tiktok'] != null
          ? SocialAccount.fromJson(json['tiktok'] as Map<String, dynamic>)
          : null,
      instagram: json['instagram'] != null
          ? SocialAccount.fromJson(json['instagram'] as Map<String, dynamic>)
          : null,
      threads: json['threads'] != null
          ? SocialAccount.fromJson(json['threads'] as Map<String, dynamic>)
          : null,
      x: json['x'] != null
          ? SocialAccount.fromJson(json['x'] as Map<String, dynamic>)
          : null,
    );
  }

  AvatarSocialLinks copyWith({
    SocialAccount? youtube,
    SocialAccount? tiktok,
    SocialAccount? instagram,
    SocialAccount? threads,
    SocialAccount? x,
  }) {
    return AvatarSocialLinks(
      youtube: youtube ?? this.youtube,
      tiktok: tiktok ?? this.tiktok,
      instagram: instagram ?? this.instagram,
      threads: threads ?? this.threads,
      x: x ?? this.x,
    );
  }
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
  })  : visual = visual ?? const AvatarVisual(),
        character = character ?? const AvatarCharacter(),
        aiSettings = aiSettings ?? const AvatarAISettings(),
        voiceSettings = voiceSettings ?? const AvatarVoiceSettings(),
        socialLinks = socialLinks ?? AvatarSocialLinks(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country': country,
        'language': language,
        'era': era,
        'title': title,
        'description': description,
        'status': status.toJson(),
        'visual': visual.toJson(),
        'character': character.toJson(),
        'aiSettings': aiSettings.toJson(),
        'voiceSettings': voiceSettings.toJson(),
        'socialLinks': socialLinks.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      language: json['language'] as String? ?? 'ja',
      era: json['era'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: AvatarStatusExtension.fromJson(json['status'] as String? ?? 'draft'),
      visual: json['visual'] != null
          ? AvatarVisual.fromJson(json['visual'] as Map<String, dynamic>)
          : null,
      character: json['character'] != null
          ? AvatarCharacter.fromJson(json['character'] as Map<String, dynamic>)
          : null,
      aiSettings: json['aiSettings'] != null
          ? AvatarAISettings.fromJson(json['aiSettings'] as Map<String, dynamic>)
          : null,
      voiceSettings: json['voiceSettings'] != null
          ? AvatarVoiceSettings.fromJson(json['voiceSettings'] as Map<String, dynamic>)
          : null,
      socialLinks: json['socialLinks'] != null
          ? AvatarSocialLinks.fromJson(json['socialLinks'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

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
