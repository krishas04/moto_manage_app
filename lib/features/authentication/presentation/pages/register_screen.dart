import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/reusable_widgets/custom_text_field.dart';
import 'package:moto_manage/core/utils/validators.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/reusable_widgets/wide_elevated_button.dart';
import '../statemanagement/auth_notifier.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'male';

  @override
  void dispose(){
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = context.read<AuthNotifier>();
    final success = await notifier.register({
      'username': _userNameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      'confirm_password': _confirmPasswordController.text.trim(),
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'phone_number': _phoneController.text.trim(),
      'mobile_number': _mobileController.text.trim(),
      'age': int.tryParse(_ageController.text.trim()) ?? 0,
      'address': _addressController.text.trim(),
      'gender': _selectedGender,
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please log in.'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notifier.errorMessage ?? 'Registration failed'),
          backgroundColor: Colors.red,
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
      appBar: AppBar(
        title: Text('Create Account',style: AppTextStyles.heading,),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                    controller: _userNameController,
                    label: 'Username',
                    validator:Validators.validateUsername,
                ),
                CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    validator: Validators.validateEmail,
                ),
                CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    isPassword: true,
                    validator: (value)=> Validators.validatePassword(value),
                ),
                CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    isPassword: true,
                    validator: (value)=> Validators.validateConfirmPassword(value,_passwordController.text.trim()),
                ),
                CustomTextField(
                    controller: _firstNameController,
                    label: 'First name',
                    validator: (value) => Validators.validateRequired(value, "First name"),
                ),
                CustomTextField(
                    controller: _lastNameController,
                    label: 'Last name',
                    validator: (value) => Validators.validateRequired(value, "Last name"),
                ),
                CustomTextField(
                    controller: _phoneController,
                    label: 'Phone number',
                    type: TextInputType.phone,
                    validator: Validators.validatePhoneNum,
                ),
                CustomTextField(
                    controller: _mobileController,
                    label: 'Mobile number',
                    type: TextInputType.phone,
                    validator: Validators.validateMobileNum,
                ),
                CustomTextField(
                    controller: _ageController,
                    label: 'Age',
                    type: TextInputType.number,
                    validator: Validators.validateAge,
                ),
                CustomTextField(
                    controller: _addressController,
                    label: 'Address',
                    validator: (value) =>Validators.validateRequired(value, 'Address')
                ),
                Text("Gender :"),
                DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    items: ["male", "female", "other"].map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedGender = val!),
                    decoration: InputDecoration(
                        enabledBorder: CustomTextField.buildOutlineInputBorder,
                        focusedBorder: CustomTextField.buildOutlineInputBorder,
                        focusedErrorBorder: CustomTextField.buildOutlineInputBorder,
                        errorBorder: CustomTextField.buildOutlineInputBorder,
                    )
                ),

                SizedBox(height: 10,),

                Center(
                    child: WideElevatedButton(
                        text: isLoading ? 'Creating...' : 'Create Account',
                        onPressed: (){
                          _submit();
                        })
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',style: AppTextStyles.body,),
                    GestureDetector(
                      child: Text(' Sign in',style: AppTextStyles.bodyBold,),
                      onTap:()=> context.go('/login') ,
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
