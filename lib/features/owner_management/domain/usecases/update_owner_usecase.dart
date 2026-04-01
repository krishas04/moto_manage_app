import '../entities/owner.dart';
import '../repository_interfaces/owner_repository_interface.dart';

class UpdateOwnerUseCase{
  final OwnerRepository ownerRepository;

  UpdateOwnerUseCase(this.ownerRepository);

  Future<Map<String, dynamic>> call(OwnerEntity owner,String token) async{
    return await ownerRepository.updateOwner(owner,token);
  }
}