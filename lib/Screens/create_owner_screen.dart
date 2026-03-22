import 'package:flutter/material.dart';
import 'package:moto_manage/Models/owner_model.dart';
import 'package:moto_manage/Services/api_service.dart';

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

  final ApiService apiService=ApiService();


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

      final newOwner=OwnerModel(
        username: _userNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        firstName: _fNameController.text,
        lastName: _lNameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
      );

      final success= await apiService.createOwner(newOwner);
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
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  _buildField(_userNameController, "Username"),
                  _buildField(_emailController, "Email", type: TextInputType.emailAddress),
                  _buildField(_phoneController, "Phone Number", type: TextInputType.phone),
                  _buildField(_fNameController, "First Name"),
                  _buildField(_lNameController, "Last Name"),
                  _buildField(_ageController, "Age", type: TextInputType.number),
              
                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGender,
                    items: ["male", "female", "other"].map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedGender = val!),
                    decoration: const InputDecoration(labelText: "Gender"),
                  ),
              
                  ElevatedButton(
                    onPressed:  _submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              
              ),
            ),
          )),
    );
  }

  Widget _buildField(TextEditingController controller, String label, {TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: type,
      validator: (value) => value!.isEmpty ? "Required" : null,
    );
  }
}
