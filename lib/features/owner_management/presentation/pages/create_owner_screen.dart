import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/presentation/state_management/owner_notifier.dart';
import 'package:provider/provider.dart';

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
  final _phoneController = TextEditingController();
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
    _phoneController.dispose();
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
            phoneNumber: _phoneController.text.trim(),
            firstName: _fNameController.text.trim(),
            lastName: _lNameController.text.trim(),
            age: int.parse(_ageController.text.trim()),
            gender: _selectedGender,
            );

            final success= await context.read<OwnerNotifier>().createOwner(newOwner);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (!mounted) return;

            if(success){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Owner Created Successfully!"),
              backgroundColor: Colors.green,
              ));
            }else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed to create owner"),
              backgroundColor: Colors.red
              ));
            context.pop(true);
            }
          } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: $e"),
                    backgroundColor: Colors.red,
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
      appBar: AppBar(
        title: const Text('Create a owner'),
      ),
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
                      controller:_userNameController,
                      label:"Username",
                    validator:  (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                      controller:_emailController,
                      label:"Email",
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                  ),
                  CustomTextField(
                      controller:_fNameController,
                      label:"First Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                  ),
                  CustomTextField(
                      controller:_lNameController,
                      label:"Last Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                  ),
                  CustomTextField(
                      controller:_ageController,
                      label:"Age",
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Age is required';
                        }
                        final age = int.tryParse(value);
                        if (age == null) {
                          return 'Please enter a valid number';
                        }
                        if (age < 18 || age > 100) {
                          return 'Age must be between 18 and 100';
                        }
                        return null;
                      },
                  ),
                  CustomTextField(
                      controller:_phoneController,
                      label:"Phone Number",
                      type: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                  ),

                  // Gender Dropdown
                  Text("Gender :"),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    items: ["male", "female", "other"].map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedGender = val!),
                    decoration: InputDecoration(
                      enabledBorder: CustomTextField.buildOutlineInputBorder
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
