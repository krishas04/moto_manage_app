import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/domain/repository_interfaces/owner_repository_interface.dart';

class CreateOwnerUseCase{
  final OwnerRepository ownerRepository;

  CreateOwnerUseCase(this.ownerRepository);

  Future<bool> call(OwnerEntity owner) async{
    return await ownerRepository.createOwner(owner);
  }
}