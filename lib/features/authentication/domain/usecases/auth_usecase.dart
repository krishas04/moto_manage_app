import '../entities/auth_entity.dart';
import '../repository_interfaces/auth_repository_interface.dart';

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<AuthEntity> call({required String username, required String password}) =>
      _repo.login(username: username, password: password);
}

class RegisterUseCase {
  final AuthRepository _repo;
  RegisterUseCase(this._repo);

  Future<void> call(Map<String, dynamic> data) => _repo.register(data: data);
}

class LogoutUseCase {
  final AuthRepository _repo;
  LogoutUseCase(this._repo);

  Future<void> call() => _repo.logout();
}

class RestoreSessionUseCase {
  final AuthRepository _repo;
  RestoreSessionUseCase(this._repo);

  Future<AuthEntity?> call() => _repo.restoreSession();
}