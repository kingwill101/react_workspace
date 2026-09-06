import 'dart:async';

import 'package:react_core/react.dart';

import '../models/tenant.dart';

final ReactContext<TenantContextValue?> _tenantContext = createContext(null);
int _nextTenantId = 0;

String _generateId(String prefix) {
  _nextTenantId++;
  return '$prefix-$_nextTenantId';
}

String _today() => DateTime.now().toIso8601String().split('T').first;

/// The tenant state and actions exposed by [useTenant].
final class TenantContextValue {
  /// Creates tenant state.
  const TenantContextValue({
    required this.currentOrganization,
    required this.organizations,
    required this.currentUser,
    required this.switchOrganization,
    required this.createOrganization,
    required this.updateOrganization,
    required this.isLoading,
    required this.hasCompletedOnboarding,
    required this.setHasCompletedOnboarding,
    required this.teamMembers,
    required this.inviteTeamMember,
    required this.removeTeamMember,
    required this.apiKeys,
    required this.generateApiKey,
    required this.revokeApiKey,
    required this.notificationSettings,
    required this.updateNotificationSettings,
    required this.securitySettings,
    required this.updateSecuritySettings,
    required this.isGatewayConnected,
    required this.setIsGatewayConnected,
  });

  final Organization? currentOrganization;
  final List<Organization> organizations;
  final TenantUser? currentUser;
  final void Function(String organizationId) switchOrganization;
  final Future<Organization> Function(String name, String slug)
  createOrganization;
  final void Function(String organizationId, Organization updates)
  updateOrganization;
  final bool isLoading;
  final bool hasCompletedOnboarding;
  final void Function(bool value) setHasCompletedOnboarding;
  final List<TeamMember> teamMembers;
  final Future<TeamMember> Function(String email, MemberRole role)
  inviteTeamMember;
  final void Function(String memberId) removeTeamMember;
  final List<ApiKey> apiKeys;
  final Future<ApiKey> Function(String name) generateApiKey;
  final void Function(String keyId) revokeApiKey;
  final NotificationSettings notificationSettings;
  final void Function(NotificationSettings settings) updateNotificationSettings;
  final SecuritySettings securitySettings;
  final void Function(SecuritySettings settings) updateSecuritySettings;
  final bool isGatewayConnected;
  final void Function(bool value) setIsGatewayConnected;
}

const _organizations = <Organization>[
  Organization(
    id: 'org-1',
    name: 'Acme Corp',
    slug: 'acme',
    createdAt: '2024-01-15',
  ),
  Organization(
    id: 'org-2',
    name: 'TechStart Inc',
    slug: 'techstart',
    createdAt: '2024-02-20',
  ),
  Organization(
    id: 'org-3',
    name: 'DataFlow Labs',
    slug: 'dataflow',
    createdAt: '2024-03-10',
  ),
];

const _user = TenantUser(
  id: 'user-1',
  email: 'admin@acme.com',
  name: 'Alex Morgan',
  role: MemberRole.admin,
  organizationId: 'org-1',
);

const _members = <TeamMember>[
  TeamMember(
    id: 'member-1',
    email: 'admin@acme.com',
    name: 'Alex Morgan',
    role: MemberRole.admin,
    status: 'active',
    joinedAt: '2024-01-15',
  ),
  TeamMember(
    id: 'member-2',
    email: 'dev@acme.com',
    name: 'Jordan Lee',
    role: MemberRole.member,
    status: 'active',
    joinedAt: '2024-02-01',
  ),
];

const _apiKeys = <ApiKey>[
  ApiKey(
    id: 'key-1',
    name: 'Production Key',
    key: 'wf_prod_a1b2c3d4e5f6g7h8i9j0',
    maskedKey: 'wf_prod_****************************',
    createdAt: '2025-01-05',
    lastUsed: '2025-01-18',
  ),
];

void _ignoreTenantString(String _) {}
void _ignoreTenantBool(bool _) {}
void _ignoreTenantOrganization(String _, Organization _) {}
void _ignoreTenantMember(String _) {}
void _ignoreTenantKey(String _) {}
void _ignoreTenantNotifications(NotificationSettings _) {}
void _ignoreTenantSecurity(SecuritySettings _) {}

Future<Organization> _standaloneCreateOrganization(String name, String slug) =>
    Future.value(
      Organization(
        id: 'standalone',
        name: name,
        slug: slug,
        createdAt: _today(),
      ),
    );

Future<TeamMember> _standaloneInviteMember(String email, MemberRole role) =>
    Future.value(
      TeamMember(
        id: 'standalone',
        email: email,
        name: email.split('@').first,
        role: role,
        status: 'pending',
      ),
    );

Future<ApiKey> _standaloneGenerateKey(String name) => Future.value(
  ApiKey(
    id: 'standalone',
    name: name,
    key: 'wf_standalone',
    maskedKey: 'wf_standalone_***',
    createdAt: _today(),
  ),
);

final _standaloneTenant = TenantContextValue(
  currentOrganization: _organizations.first,
  organizations: _organizations,
  currentUser: _user,
  switchOrganization: _ignoreTenantString,
  createOrganization: _standaloneCreateOrganization,
  updateOrganization: _ignoreTenantOrganization,
  isLoading: false,
  hasCompletedOnboarding: false,
  setHasCompletedOnboarding: _ignoreTenantBool,
  teamMembers: _members,
  inviteTeamMember: _standaloneInviteMember,
  removeTeamMember: _ignoreTenantMember,
  apiKeys: _apiKeys,
  generateApiKey: _standaloneGenerateKey,
  revokeApiKey: _ignoreTenantKey,
  notificationSettings: NotificationSettings(
    workflowFailures: true,
    jobRetriesExceeded: true,
    weeklySummary: false,
  ),
  updateNotificationSettings: _ignoreTenantNotifications,
  securitySettings: SecuritySettings(
    twoFactorEnabled: false,
    apiAccessLogging: true,
  ),
  updateSecuritySettings: _ignoreTenantSecurity,
  isGatewayConnected: false,
  setIsGatewayConnected: _ignoreTenantBool,
);

/// Owns organization, access, and dashboard connection state.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode TenantProvider(({List<ReactNode> children}) props) {
  final (currentOrganization, setCurrentOrganization) = useState<Organization?>(
    _organizations.first,
  );
  final (organizations, setOrganizations) = useState<List<Organization>>(
    List.of(_organizations),
  );
  final (isLoading, setIsLoading) = useState(false);
  final (hasCompletedOnboarding, setOnboarding) = useState(false);
  final (teamMembers, setTeamMembers) = useState<List<TeamMember>>(
    List.of(_members),
  );
  final (apiKeys, setApiKeys) = useState<List<ApiKey>>(List.of(_apiKeys));
  final (notificationSettings, setNotificationSettings) = useState(
    const NotificationSettings(
      workflowFailures: true,
      jobRetriesExceeded: true,
      weeklySummary: false,
    ),
  );
  final (securitySettings, setSecuritySettings) = useState(
    const SecuritySettings(twoFactorEnabled: false, apiAccessLogging: true),
  );
  final (isGatewayConnected, setGatewayConnected) = useState(false);

  void switchOrganization(String organizationId) {
    setIsLoading(true);
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      final organization = organizations.where(
        (item) => item.id == organizationId,
      );
      if (organization.isNotEmpty) setCurrentOrganization(organization.first);
      setIsLoading(false);
    });
  }

  Future<Organization> createOrganization(String name, String slug) async {
    setIsLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final organization = Organization(
      id: _generateId('org'),
      name: name,
      slug: slug.toLowerCase().replaceAll(RegExp(r'\s+'), '-'),
      createdAt: _today(),
    );
    setOrganizations.update((items) => [...items, organization]);
    setCurrentOrganization(organization);
    setIsLoading(false);
    return organization;
  }

  void updateOrganization(String organizationId, Organization updates) {
    setOrganizations.update(
      (items) => items
          .map((item) => item.id == organizationId ? updates : item)
          .toList(),
    );
    if (currentOrganization?.id == organizationId) {
      setCurrentOrganization(updates);
    }
  }

  void setHasCompletedOnboarding(bool value) => setOnboarding(value);

  Future<TeamMember> inviteTeamMember(String email, MemberRole role) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final member = TeamMember(
      id: _generateId('member'),
      email: email,
      name: email.split('@').first,
      role: role,
      status: 'pending',
      invitedAt: DateTime.now().toIso8601String(),
    );
    setTeamMembers.update((items) => [...items, member]);
    return member;
  }

  void removeTeamMember(String memberId) {
    setTeamMembers.update(
      (items) => items.where((item) => item.id != memberId).toList(),
    );
  }

  Future<ApiKey> generateApiKey(String name) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final key = 'wf_${_generateId('key')}_${_nextTenantId.toRadixString(36)}';
    final apiKey = ApiKey(
      id: _generateId('key'),
      name: name,
      key: key,
      maskedKey:
          '${key.substring(0, key.length.clamp(0, 7))}****************************',
      createdAt: _today(),
    );
    setApiKeys.update((items) => [...items, apiKey]);
    return apiKey;
  }

  void revokeApiKey(String keyId) {
    setApiKeys.update(
      (items) => items.where((item) => item.id != keyId).toList(),
    );
  }

  void updateNotificationSettings(NotificationSettings settings) =>
      setNotificationSettings(settings);

  void updateSecuritySettings(SecuritySettings settings) =>
      setSecuritySettings(settings);

  void setIsGatewayConnected(bool value) => setGatewayConnected(value);

  return provideContext(
    _tenantContext,
    TenantContextValue(
      currentOrganization: currentOrganization,
      organizations: organizations,
      currentUser: _user,
      switchOrganization: switchOrganization,
      createOrganization: createOrganization,
      updateOrganization: updateOrganization,
      isLoading: isLoading,
      hasCompletedOnboarding: hasCompletedOnboarding,
      setHasCompletedOnboarding: setHasCompletedOnboarding,
      teamMembers: teamMembers,
      inviteTeamMember: inviteTeamMember,
      removeTeamMember: removeTeamMember,
      apiKeys: apiKeys,
      generateApiKey: generateApiKey,
      revokeApiKey: revokeApiKey,
      notificationSettings: notificationSettings,
      updateNotificationSettings: updateNotificationSettings,
      securitySettings: securitySettings,
      updateSecuritySettings: updateSecuritySettings,
      isGatewayConnected: isGatewayConnected,
      setIsGatewayConnected: setIsGatewayConnected,
    ),
    props.children,
  );
}

/// Reads tenant state from the nearest [TenantProvider].
TenantContextValue useTenant() {
  final value = useContext(_tenantContext);
  return value ?? _standaloneTenant;
}
