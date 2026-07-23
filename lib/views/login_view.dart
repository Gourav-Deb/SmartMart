import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class LoginView extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  final Function(String role, String email) onLoginSuccess;

  const LoginView({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onLoginSuccess,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String selectedRole = "ADMIN"; // "ADMIN" or "RIDER"
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isPasswordVisible = false;
  bool rememberMe = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "admin@smartmart.ai");
    passwordController = TextEditingController(text: "admin123");
  }

  void _updateDefaultCredentials(String role) {
    setState(() {
      selectedRole = role;
      if (role == "ADMIN") {
        emailController.text = "admin@smartmart.ai";
        passwordController.text = "admin123";
      } else if (role == "RIDER") {
        emailController.text = "rider.rohan@smartmart.ai";
        passwordController.text = "rider123";
      } else {
        emailController.text = "customer.riya@smartmart.ai";
        passwordController.text = "customer123";
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bgGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A0C), Color(0xFF000000), Color(0xFF0A0A0C)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
          );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: Column(
          children: [
            // Top Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primary, Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(LucideIcons.zap, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "SmartMart",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: widget.onToggleTheme,
                        icon: Icon(
                          isDark ? LucideIcons.sun : LucideIcons.moon,
                          color: isDark ? const Color(0xFFF59E0B) : const Color(0xFF0F172A),
                          size: 18,
                        ),
                        tooltip: "Toggle Light/Dark Theme",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Login Content Area
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 480),
                    padding: const EdgeInsets.all(36),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Subtitle
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Sign in to access your SmartMart Workspace",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Role Selector Pills
                        Text(
                          "Select Workspace Role",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _rolePill(
                                role: "ADMIN",
                                label: "Super Admin",
                                icon: LucideIcons.shield,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _rolePill(
                                role: "RIDER",
                                label: "Rider Partner",
                                icon: LucideIcons.bike,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _rolePill(
                                role: "CUSTOMER",
                                label: "Customer App",
                                icon: LucideIcons.shoppingBag,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Email Input
                        Text(
                          "Email Address",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.cardDarkElevated : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: TextField(
                            controller: emailController,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                LucideIcons.mail,
                                size: 18,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                              hintText: "Enter email",
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password Input
                        Text(
                          "Password",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.cardDarkElevated : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                LucideIcons.lock,
                                size: 18,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible ? LucideIcons.eyeOff : LucideIcons.eye,
                                  size: 18,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                                onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                              ),
                              hintText: "Enter password",
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Remember Me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: rememberMe,
                                    activeColor: AppTheme.primary,
                                    onChanged: (val) => setState(() => rememberMe = val ?? true),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Remember me",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Main Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onLoginSuccess(selectedRole, emailController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedRole == "ADMIN" ? AppTheme.primary : const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sign In as ${selectedRole == "ADMIN" ? "Super Admin" : "Rider Partner"}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(LucideIcons.arrowRight, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Divider & One-Click Quick Demo Login Shortcuts
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "ONE-CLICK QUICK DEMO LOGIN",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Quick Login Buttons
                        _quickLoginTile(
                          role: "ADMIN",
                          title: "Quick Login: Super Admin",
                          email: "admin@smartmart.ai",
                          icon: LucideIcons.layoutDashboard,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(height: 10),
                        _quickLoginTile(
                          role: "RIDER",
                          title: "Quick Login: Rider Partner",
                          email: "rider.rohan@smartmart.ai",
                          icon: LucideIcons.bike,
                          color: const Color(0xFF10B981),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rolePill({required String role, required String label, required IconData icon}) {
    final bool isActive = selectedRole == role;
    final isDark = widget.isDark;

    return InkWell(
      onTap: () => _updateDefaultCredentials(role),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? (role == "ADMIN" ? AppTheme.primary : const Color(0xFF10B981))
              : (isDark ? AppTheme.cardDarkElevated : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : (isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickLoginTile({
    required String role,
    required String title,
    required String email,
    required IconData icon,
    required Color color,
  }) {
    final isDark = widget.isDark;
    return InkWell(
      onTap: () => widget.onLoginSuccess(role, email),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDarkElevated : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppTheme.borderDarkActive : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    email,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
