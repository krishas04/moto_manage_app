import 'package:flutter/widgets.dart';

import '../../domain/entities/vehicle.dart';
import '../../domain/usecases/vehicles_usecase.dart';

class VehicleNotifier extends ChangeNotifier{
  final GetVehiclesUseCase _getVehiclesUseCase;
  final GetVehiclesByOwnerUseCase _getVehiclesByOwnerUseCase;
  final GetVehicleByIdUseCase _getVehicleByIdUseCase;
  final CreateVehicleUseCase _createVehicleUseCase;
  final UpdateVehicleUseCase _updateVehicleUseCase;
  final DeleteVehicleUseCase _deleteVehicleUseCase;
  final GetMyVehiclesUseCase _getMyVehiclesUseCase;
  final CreateMyVehicleUseCase _createMyVehicleUseCase;
  final UpdateMyVehicleUseCase _updateMyVehicleUseCase;
  final DeleteMyVehicleUseCase _deleteMyVehicleUseCase;

  VehicleNotifier({
    required GetVehiclesUseCase getVehiclesUseCase,
    required GetVehiclesByOwnerUseCase getVehiclesByOwnerUseCase,
    required GetVehicleByIdUseCase getVehicleByIdUseCase,
    required CreateVehicleUseCase createVehicleUseCase,
    required UpdateVehicleUseCase updateVehicleUseCase,
    required DeleteVehicleUseCase deleteVehicleUseCase,
    required GetMyVehiclesUseCase getMyVehiclesUseCase,
    required CreateMyVehicleUseCase createMyVehicleUseCase,
    required UpdateMyVehicleUseCase updateMyVehicleUseCase,
    required DeleteMyVehicleUseCase deleteMyVehicleUseCase,
    }): _getVehiclesUseCase = getVehiclesUseCase,
        _getVehiclesByOwnerUseCase = getVehiclesByOwnerUseCase,
        _getVehicleByIdUseCase= getVehicleByIdUseCase,
        _createVehicleUseCase = createVehicleUseCase,
        _updateVehicleUseCase = updateVehicleUseCase,
        _deleteVehicleUseCase = deleteVehicleUseCase,
        _getMyVehiclesUseCase = getMyVehiclesUseCase,
        _createMyVehicleUseCase = createMyVehicleUseCase,
        _updateMyVehicleUseCase = updateMyVehicleUseCase,
        _deleteMyVehicleUseCase = deleteMyVehicleUseCase;

  // State variables
  List<VehicleEntity> _vehicles = [];
  List<VehicleEntity> _myVehicles = [];
  VehicleEntity? _selectedVehicle;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<VehicleEntity> get vehicles => _vehicles;
  List<VehicleEntity> get myVehicles => _myVehicles;
  VehicleEntity? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool v) {
    _isLoading = v;
  }

  // Admin Methods
  Future<void> loadVehicles(String token) async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();
    try {
      _vehicles = await _getVehiclesUseCase.call(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> loadVehiclesByOwner(int ownerId,String token) async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();
    try {
      _myVehicles = await _getVehiclesByOwnerUseCase.call(ownerId,token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> loadVehicleById(int id, String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _selectedVehicle = await _getVehicleByIdUseCase.call(id, token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createVehicle(
      VehicleEntity vehicle,
      String token, {
        String? imagePath,
      }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final created = await _createVehicleUseCase.call(
        vehicle,
        token,
        imagePath: imagePath,
      );
      _vehicles = [created, ..._vehicles];
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateVehicle(
      VehicleEntity vehicle,
      String token, {
        String? imagePath,
      }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final updated = await _updateVehicleUseCase.call(
        vehicle,
        token,
        imagePath: imagePath,
      );
      _vehicles = _vehicles.map((x) => x.id == updated.id ? updated : x).toList();
      if (_selectedVehicle?.id == updated.id) {
        _selectedVehicle = updated;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteVehicle(int id, String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _deleteVehicleUseCase.call(id, token);
      _vehicles = _vehicles.where((v) => v.id != id).toList();
      if (_selectedVehicle?.id == id) {
        _selectedVehicle = null;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Regular user methods

  Future<void> loadMyVehicles(String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _myVehicles = await _getMyVehiclesUseCase.call(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createMyVehicle(
      VehicleEntity vehicle,
      String token, {
        String? imagePath,
      }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final created = await _createMyVehicleUseCase.call(
        vehicle,
        token,
        imagePath: imagePath,
      );
      _myVehicles = [created, ..._myVehicles];
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateMyVehicle(
      VehicleEntity vehicle,
      String token, {
        String? imagePath,
      }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final updated = await _updateMyVehicleUseCase.call(
        vehicle,
        token,
        imagePath: imagePath,
      );
      _myVehicles = _myVehicles.map((x) => x.id == updated.id ? updated : x).toList();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteMyVehicle(int id, String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _deleteMyVehicleUseCase.call(id, token);
      _myVehicles = _myVehicles.where((v) => v.id != id).toList();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //  Utility Methods

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelectedVehicle() {
    _selectedVehicle = null;
    notifyListeners();
  }

  void reset() {
    _vehicles = [];
    _myVehicles = [];
    _selectedVehicle = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}