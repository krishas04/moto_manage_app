import '../entities/owner.dart';
import '../repository_interfaces/owner_repository_interface.dart';

class UpdateOwnerUseCase{
  final OwnerRepository ownerRepository;

  UpdateOwnerUseCase(this.ownerRepository);

  Future<bool> call(OwnerEntity owner) async{
    return await ownerRepository.updateOwner(owner);
  }
}