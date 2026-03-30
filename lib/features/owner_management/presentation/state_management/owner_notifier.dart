import 'package:flutter/foundation.dart';

import '../../domain/entities/owner.dart';
import '../../domain/usecases/create_owner_usecase.dart';
import '../../domain/usecases/get_owners_usecase.dart';
import '../../domain/usecases/update_owner_usecase.dart';

class OwnerNotifier extends ChangeNotifier{
  final GetOwnersUseCase _getOwnersUseCase;
  final CreateOwnerUseCase _createOwnerUseCase;
  final UpdateOwnerUseCase _updateOwnerUseCase;

  OwnerNotifier({
    required GetOwnersUseCase getOwnersUseCase,
    required CreateOwnerUseCase createOwnerUseCase,
    required UpdateOwnerUseCase updateOwnerUseCase,
  })  : _getOwnersUseCase = getOwnersUseCase,
        _createOwnerUseCase = createOwnerUseCase,
        _updateOwnerUseCase = updateOwnerUseCase;

  // State variables
  List<OwnerEntity> _owners = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<OwnerEntity> get owners => _owners;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadOwners() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();  // ← widgets rebuild here (shows spinner)
    try {
      _owners = await _getOwnersUseCase.call();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // ← widgets rebuild here (shows list or error)
    }
  }

  Future<bool> createOwner(OwnerEntity owner) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _createOwnerUseCase.call(owner);
      final bool isSuccess = response.containsKey('id');
      if (isSuccess) {
        await loadOwners();
      }
      return isSuccess;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> editOwner(OwnerEntity owner) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _updateOwnerUseCase.call(owner);
      final bool isSuccess = response.containsKey('id');
      if (isSuccess) {
        await loadOwners();
      }
      return isSuccess;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

}
