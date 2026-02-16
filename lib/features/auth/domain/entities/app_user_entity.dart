enum UserRole {
  admin,
  cashier,
  bartender,
  client,
}

class AppUserEntity {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? companyId;
  final String? venueId;
  final bool isActive;

  const AppUserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.companyId,
    this.venueId,
    required this.isActive,
  });
}