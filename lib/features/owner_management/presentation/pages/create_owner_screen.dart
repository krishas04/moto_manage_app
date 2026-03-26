import 'package:flutter/material.dart';

import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/domain/usecases/create_owner_usercase.dart';
import 'package:moto_manage/features/owner_management/presentation/widgets/custom_text_field.dart';
import 'package:moto_manage/features/owner_management/presentation/widgets/wide_elevated_button.dart';

import '../../../../core/di/service_locator.dart';


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
  late final CreateOwnerUseCase createOwnerUseCase= getIt<CreateOwnerUseCase>();


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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );

      final newOwner=OwnerEntity(
        username: _userNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        firstName: _fNameController.text,
        lastName: _lNameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
      );

      final success= await createOwnerUseCase.call(newOwner);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if(success){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Created!")));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error creating user")));
      }


    }
  }

  @override
  Widget build(BuildContext context) {
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
                  CustomTextField(controller:_userNameController, label:"Username"),
                  CustomTextField(controller:_emailController, label:"Email",type: TextInputType.emailAddress),
                  CustomTextField(controller:_fNameController, label:"First Name"),
                  CustomTextField(controller:_lNameController, label:"Last Name"),
                  CustomTextField(controller:_ageController, label:"Age",type: TextInputType.number),

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
                      ),
                    ),

                  SizedBox(height: 20,),

                  Center(
                    child: WideElevatedButton(
                        text: 'Submit',
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
