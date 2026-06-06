import 'package:flutter/material.dart'
    '';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/constants/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/reusable_widgets/custom_text_field.dart';
import '../../../../core/reusable_widgets/wide_elevated_button.dart';
import '../../../../core/utils/validators.dart';
import '../statemanagement/auth_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = context.read<AuthNotifier>();
    final success = await notifier.login(
      username: _userNameController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      final isAdmin = context.read<AuthNotifier>().isAdmin;
      context.go(isAdmin ? '/dashboard' : '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notifier.errorMessage ?? 'Login failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthNotifier, bool>(
          (n) => n.status == AuthStatus.loading,
    );
    return Scaffold(
      body: Center(
        child: Form(
            key:_formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Welcome Back!!',style: AppTextStyles.heading,),
                    Text('Glad to see you again.',style: AppTextStyles.body,),
                    CustomTextField(
                      controller: _userNameController,
                      label: 'Username',
                      validator:Validators.validateUsername,
                    ),

                    //password textFormField
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      isPassword: true,
                      validator: (value)=> Validators.validatePassword(value),
                    ),

                    const SizedBox(height: 20,),

                    Center(
                        child: WideElevatedButton(
                            text: isLoading ? 'Logging in...' : 'Sign in',
                            onPressed: (){
                              _submit();
                            })
                    ),
                    const SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?',style: AppTextStyles.body,),
                        GestureDetector(
                            child: Text(' Sign up',style: AppTextStyles.bodyBold,),
                          onTap:()=> context.go('/register') ,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                  ],

                ),
              ),
            )),
      ),
    );
  }
}
