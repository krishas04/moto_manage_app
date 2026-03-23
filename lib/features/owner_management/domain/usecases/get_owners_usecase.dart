import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/domain/repository_interfaces/owner_repository_interface.dart';

class GetOwnersUseCase{
  final OwnerRepository ownerRepository;

  GetOwnersUseCase(this.ownerRepository);

  Future<List<OwnerEntity>> call() async{
    return await ownerRepository.getOwners();
  }
}