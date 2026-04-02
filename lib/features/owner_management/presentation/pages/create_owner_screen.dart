import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/reusable_widgets/custom_appbar.dart';
import 'package:moto_manage/core/utils/validators.dart';
import 'package:moto_manage/features/authentication/presentation/statemanagement/auth_notifier.dart';

import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/presentation/state_management/owner_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/reusable_widgets/custom_text_field.dart';
import '../../../../core/reusable_widgets/wide_elevated_button.dart';



class CreateOwnerScreen extends StatefulWidget {
  const CreateOwnerScreen({super.key});

  @override
  State<CreateOwnerScreen> createState() => _CreateOwnerScreenState();
}

class _CreateOwnerScreenState extends State<CreateOwnerScreen> {

  // Controllers for all fields
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedGender = "male";

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _userNameController.dispose();
    _emailController.dispose();
    _mobileNumController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {

      try{ final newOwner=OwnerEntity(
            username: _userNameController.text.trim(),
            email: _emailController.text.trim(),
            mobileNumber: _mobileNumController.text.trim(),
            firstName: _fNameController.text.trim(),
            lastName: _lNameController.text.trim(),
            age: int.parse(_ageController.text.trim()),
            gender: _selectedGender,
            );

        final token= context.read<AuthNotifier>().accessToken;
        final success= await context.read<OwnerNotifier>().createOwner(newOwner,token!);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (!mounted) return;

            if(success){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Owner Created Successfully!"),
              backgroundColor: AppColors.success,
              ));
            }else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed to create owner"),
              backgroundColor: AppColors.error
              ));
            context.pop(true);
            }
          } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: $e"),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<OwnerNotifier>().isLoading;
    return Scaffold(
      appBar: CustomAppBar(title: 'Create a new owner'),
      body: Form(
          key:_formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
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
                    controller: _mobileNumController,
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

                  SizedBox(height: 20,),

                  Center(
                    child: WideElevatedButton(
                        text: isLoading ? 'Creating...' : 'Create Owner',
                        onPressed: (){
                        _submitForm();
                      })
                  ),
                ],

              ),
            ),
          )),
    );
  }


}
