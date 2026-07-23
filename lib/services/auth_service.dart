enum UserRole { admin, rider, customer }

extension UserRoleExtension on UserRole {
  String toRoleString() {
    switch (this) {
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.rider:
        return 'RIDER';
      case UserRole.customer:
        return 'CUSTOMER';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
      case 'SUPER_ADMIN':
        return UserRole.admin;
      case 'RIDER':
        return UserRole.rider;
      case 'CUSTOMER':
      default:
        return UserRole.customer;
    }
  }
}

class AuthService {
  // In-memory authentication service
  static Future<UserRole> authenticate({
    required String email,
    required String password,
    required String selectedRole,
  }) async {
    return UserRoleExtension.fromString(selectedRole);
  }
}
