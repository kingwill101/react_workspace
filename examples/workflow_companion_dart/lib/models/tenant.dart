/// Tenant records used by the organization and settings views.
enum MemberRole { admin, member, viewer }

class Organization {
  const Organization({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    this.logoUrl,
  });

  final String id;
  final String name;
  final String slug;
  final String createdAt;
  final String? logoUrl;
}

class TenantUser {
  const TenantUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.organizationId,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String name;
  final MemberRole role;
  final String organizationId;
  final String? avatarUrl;
}

class TeamMember {
  const TeamMember({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.status,
    this.invitedAt,
    this.joinedAt,
  });

  final String id;
  final String email;
  final String name;
  final MemberRole role;
  final String status;
  final String? invitedAt;
  final String? joinedAt;
}

class ApiKey {
  const ApiKey({
    required this.id,
    required this.name,
    required this.key,
    required this.maskedKey,
    required this.createdAt,
    this.lastUsed,
    this.expiresAt,
  });

  final String id;
  final String name;
  final String key;
  final String maskedKey;
  final String createdAt;
  final String? lastUsed;
  final String? expiresAt;
}

class NotificationSettings {
  const NotificationSettings({
    required this.workflowFailures,
    required this.jobRetriesExceeded,
    required this.weeklySummary,
  });

  final bool workflowFailures;
  final bool jobRetriesExceeded;
  final bool weeklySummary;
}

/// Organization security preferences.
class SecuritySettings {
  /// Creates security settings.
  const SecuritySettings({
    required this.twoFactorEnabled,
    required this.apiAccessLogging,
  });

  final bool twoFactorEnabled;
  final bool apiAccessLogging;
}
