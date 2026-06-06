import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/constants/app_colors.dart';
import 'package:moto_manage/core/reusable_widgets/custom_card.dart';
import 'package:moto_manage/core/reusable_widgets/custom_text_field.dart';
import 'package:moto_manage/core/reusable_widgets/wide_elevated_button.dart';
import 'package:moto_manage/core/utils/validators.dart';
import 'package:moto_manage/features/authentication/presentation/statemanagement/auth_notifier.dart';
import 'package:moto_manage/features/owner_management/presentation/state_management/owner_notifier.dart';
import 'package:moto_manage/features/vehicles_management/domain/entities/vehicle.dart';
import 'package:moto_manage/features/vehicles_management/presentation/state_management/vehicles_notifier.dart';
import 'package:provider/provider.dart';

class CreateVehicleScreen extends StatefulWidget {
  const CreateVehicleScreen({super.key});

  @override
  State<CreateVehicleScreen> createState() => _CreateVehicleScreenState();
}

class _CreateVehicleScreenState extends State<CreateVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  int? _selectedOwnerId;
  String _selectedVehicleType = VehicleEntity.vehicleTypes[0];  //two_wheeler
  String _selectedFuelType = VehicleEntity.fuelTypes[0];  //petrol

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOwners();
    });
  }

  void _loadOwners() {
    final token = context.read<AuthNotifier>().accessToken;
    if (token != null) {
      context.read<OwnerNotifier>().loadOwners(token);
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedOwnerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an owner first")),
      );
      return;
    }

    final authNotifier = context.read<AuthNotifier>();
    final ownerNotifier = context.read<OwnerNotifier>();
    final vehicleNotifier = context.read<VehicleNotifier>();

    final selectedOwner = ownerNotifier.owners.firstWhere((o) => o.id == _selectedOwnerId);

    final newVehicle = VehicleEntity(
      ownerId: _selectedOwnerId!,
      ownerUsername: selectedOwner.username,
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      vehicleType: _selectedVehicleType,
      fuelType: _selectedFuelType,
    );

    final success = await vehicleNotifier.createVehicle(
      newVehicle,
      authNotifier.accessToken!,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle added successfully!"), backgroundColor: AppColors.success),
      );
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vehicleNotifier.errorMessage ?? "Failed to add vehicle"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownerNotifier = context.watch<OwnerNotifier>();
    final vehicleNotifier = context.watch<VehicleNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Add Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            //  Section 1: Owner Selection
            CustomCard(
              title: 'Owner Information',
              icon: Icons.person_search_outlined,
              children: [
                const Text("Select Owner :", style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                ownerNotifier.isLoading
                    ? const LinearProgressIndicator()
                    : DropdownButtonFormField<int>(
                  initialValue: _selectedOwnerId,
                  hint: const Text('Choose an owner'),
                  items: ownerNotifier.owners.map((owner) {
                    return DropdownMenuItem<int>(
                      value: owner.id,
                      child: Text(owner.username),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedOwnerId = val),
                  validator: (v) => v == null ? "Owner is required" : null,
                  decoration: _dropdownDecoration(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Section 2: Vehicle Details
            CustomCard(
              title: 'Vehicle Details',
              icon: Icons.directions_car_outlined,
              children: [
                CustomTextField(
                  controller: _makeController,
                  label: 'Make',
                  validator: (v) => Validators.validateRequired(v, 'Make'),
                ),
                CustomTextField(
                  controller: _modelController,
                  label: 'Model',
                  validator: (v) => Validators.validateRequired(v, 'Model'),
                ),
                CustomTextField(
                  controller: _yearController,
                  label: 'Year',
                  type: TextInputType.number,
                  validator: (v) => Validators.validateRequired(v, 'Year'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Section 3: Configuration
            CustomCard(
              title: 'Type & Fuel',
              icon: Icons.settings_outlined,
              children: [
                const Text("Vehicle Type :", style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedVehicleType,
                  items: VehicleEntity.vehicleTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.replaceAll('_', ' ').toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedVehicleType = val!),
                  decoration: _dropdownDecoration(),
                ),
                const SizedBox(height: 16),
                const Text("Fuel Type :", style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedFuelType,
                  items: VehicleEntity.fuelTypes.map((fuel) {
                    return DropdownMenuItem(
                      value: fuel,
                      child: Text(fuel.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedFuelType = val!),
                  decoration: _dropdownDecoration(),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Submit Button
            WideElevatedButton(
              text: vehicleNotifier.isLoading ? 'Saving...' : 'Add Vehicle',
              onPressed: vehicleNotifier.isLoading ? null : _submitForm,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      enabledBorder: CustomTextField.buildOutlineInputBorder,
      focusedBorder: CustomTextField.buildOutlineInputBorder,
      focusedErrorBorder: CustomTextField.buildOutlineInputBorder,
      errorBorder: CustomTextField.buildOutlineInputBorder,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
