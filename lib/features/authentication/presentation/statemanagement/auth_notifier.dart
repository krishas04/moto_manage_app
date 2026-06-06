import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:moto_manage/core/api/api_service.dart';
import '../../../../core/utils/jwt_decoder.dart';
import '../../../../core/utils/token_storage.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/auth_usecase.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthNotifier extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required RestoreSessionUseCase restoreSessionUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _restoreSessionUseCase = restoreSessionUseCase;

  AuthStatus _status = AuthStatus.initial;
  AuthEntity? _auth;
  String? _errorMessage;
  Map<String, String>? _fieldErrors;  // handle Server-Side Validation

  AuthStatus get status => _status;
  AuthEntity? get auth => _auth;
  String? get errorMessage => _errorMessage;
  Map<String, String>? get fieldErrors => _fieldErrors;

  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _auth?.isAdmin ?? false;
  String? get accessToken => _auth?.accessToken;

  Future<void> restoreSession() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final auth = await _restoreSessionUseCase.call();

      if (auth != null && !JwtDecoder.isExpired(auth.accessToken)) {
        _auth = auth;
        _status = AuthStatus.authenticated;
      } else {
        await TokenStorage.clear();
        _auth = null;
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<bool> login({required String username, required String password}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _auth = await _loginUseCase.call(username: username, password: password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    _fieldErrors = null;
    notifyListeners();
    try {
      await _registerUseCase.call(data);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;

      //As errors returned from the API are being wrapped into an ApiException
      if(e is ApiException){
        try{
          final decoded = jsonDecode(e.body);
          if (decoded is Map) {
            _fieldErrors = decoded.map((key, value) {
              if (value is List) return MapEntry(key, value.join(', '));
              return MapEntry(key, value.toString());
            }).cast<String, String>();
          }
        }catch(e){
          debugPrint('Failed to parse error JSON: $e');
        }
      }
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _logoutUseCase.call();
    _auth = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}