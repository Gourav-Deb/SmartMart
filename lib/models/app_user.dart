import '../services/auth_service.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final UserRole role;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  bool get isAdmin => role == UserRole.admin;
  String get roleLabel {
    switch (role) {
      case UserRole.admin:
        return 'Super Admin';
      case UserRole.rider:
        return 'Delivery Partner';
      case UserRole.customer:
        return 'Customer';
    }
  }
}

class DemoAccount {
  final String email;
  final String password;
  final String name;
  final UserRole role;

  const DemoAccount({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  AppUser get user => AppUser(
        uid: email,
        email: email,
        name: name,
        role: role,
      );
}

class AuthAccounts {
  static const admin = DemoAccount(
    email: 'admin@smartmart.ai',
    password: 'admin123',
    name: 'Super Admin',
    role: UserRole.admin,
  );

  static const rider = DemoAccount(
    email: 'rider.rohan@smartmart.ai',
    password: 'rider123',
    name: 'Rohan Kumar',
    role: UserRole.rider,
  );

  static const customer = DemoAccount(
    email: 'customer.riya@smartmart.ai',
    password: 'customer123',
    name: 'Riya Sharma',
    role: UserRole.customer,
  );

  static List<DemoAccount> get defaults => [admin, rider, customer];
}
