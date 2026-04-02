import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/reusable_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/reusable_widgets/custom_text_field.dart';
import '../../../../core/reusable_widgets/wide_elevated_button.dart';
import '../../../../core/utils/validators.dart';
import '../../../authentication/presentation/statemanagement/auth_notifier.dart';
import '../../domain/entities/owner.dart';
import '../../domain/usecases/get_owners_usecase.dart';
import '../../domain/usecases/update_owner_usecase.dart';

class UpdateOwnerScreen extends StatefulWidget {
  final String ownerId;
  const UpdateOwnerScreen({super.key, required this.ownerId});

  @override
  State<UpdateOwnerScreen> createState() => _UpdateOwnerScreenState();
}

class _UpdateOwnerScreenState extends State<UpdateOwnerScreen> {
  // Form controllers
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedGender = "male";
  bool _isLoading = true;
  bool _isSaving = false;
  OwnerEntity? _originalOwner;

  final _formKey = GlobalKey<FormState>();
  late final UpdateOwnerUseCase _updateOwnerUseCase = getIt<UpdateOwnerUseCase>();
  late final GetOwnersUseCase _getOwnersUseCase = getIt<GetOwnersUseCase>();

  // initState can't use context.read safely before build — use didChangeDependencies:
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {  // only run once
      final token = context.read<AuthNotifier>().accessToken!;
      _loadOwnerData(token);
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _userNameController.dispose();
    _emailController.dispose();
    _mobileNumController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Load owner data from API
  Future<void> _loadOwnerData(String token) async {
    try {
      final owners = await _getOwnersUseCase.call(token);
      // Convert widget.ownerId to int for comparison
      final ownerIdInt = int.tryParse(widget.ownerId);
      final owner = owners.firstWhere(
            (owner) => owner.id == ownerIdInt,
        orElse: () => throw Exception('Owner with ID ${widget.ownerId} not found'),
      );

      setState(() {
        _originalOwner = owner;
        _isLoading = false;

        // Fill form fields with existing data
        _userNameController.text = owner.username;
        _emailController.text = owner.email;
        _mobileNumController.text = owner.mobileNumber;
        _fNameController.text = owner.firstName;
        _lNameController.text = owner.lastName;
        _ageController.text = owner.age.toString();
        _selectedGender = owner.gender;
      });
    } catch (e) {
      debugPrint('Error loading owner: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading owner: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );

        // Go back after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.pop();
          }
        });
      }
    }
  }

  // Validate and submit the form
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form validation failed'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_originalOwner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Owner data not loaded properly'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Show saving indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updating owner...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Create updated owner entity
      final updatedOwner = OwnerEntity(
        id: _originalOwner!.id,
        username: _userNameController.text.trim(),
        email: _emailController.text.trim(),
        mobileNumber: _mobileNumController.text.trim(),
        firstName: _fNameController.text.trim(),
        lastName: _lNameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        gender: _selectedGender,
        // Preserve existing optional fields
        fullName: _originalOwner!.fullName,
        isActive: _originalOwner!.isActive,
        dateJoined: _originalOwner!.dateJoined,
        phoneNumber: _originalOwner!.phoneNumber,
        address: _originalOwner!.address,
      );

      // Call update use case
      final token= context.read<AuthNotifier>().accessToken;
      final response = await _updateOwnerUseCase.call(updatedOwner,token!);
      final bool isSuccess = response.containsKey('id');

      // Hide loading snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Owner updated successfully!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back with success flag
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        throw Exception('API returned false');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating owner: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Update Owner'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          :Form(
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
                  CustomTextField(
                    controller: _fNameController,
                    label: 'First name',
                    validator: (value) => Validators.validateRequired(value, "First name"),
                  ),
                  CustomTextField(
                    controller: _lNameController,
                    label: 'Last name',
                    validator: (value) => Validators.validateRequired(value, "Last name"),
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
                          text: _isSaving ? 'Updating...' : 'Update Owner',
                          onPressed: _submitForm,
                  ),
                  ),


              ]
              ),
            ),
          )),
    );
  }
}
