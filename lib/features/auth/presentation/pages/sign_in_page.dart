import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.signIn});

  final Future<void> Function(String email, String password) signIn;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await widget.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) context.go('/');
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      borderSide: BorderSide(color: AppColors.border),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: 'Back to welcome',
                      onPressed: () => context.go('/welcome'),
                      icon: Icon(LucideIcons.arrowLeft),
                    ),
                  ),
                  SizedBox(height: 44),
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.sage,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.music2, size: 32),
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Start practicing',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter anything to explore the app. No account is needed yet.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  SizedBox(height: 36),
                  Text(
                    'Name or email',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_submitting,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Your name or email',
                      filled: true,
                      fillColor: AppColors.card,
                      border: inputBorder,
                      enabledBorder: inputBorder,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Password (optional)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    enabled: !_submitting,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      filled: true,
                      fillColor: AppColors.card,
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? LucideIcons.eye
                              : LucideIcons.eyeOff,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    SizedBox(height: 16),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: TextStyle(color: AppColors.destructive),
                      ),
                    ),
                  ],
                  SizedBox(height: 28),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      onPressed: _submitting ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        foregroundColor: AppColors.primaryForeground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.full),
                        ),
                      ),
                      child: _submitting
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
