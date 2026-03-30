import 'package:moto_manage/features/owner_management/data/data_sources/owner_remote_data_source.dart';
import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/domain/repository_interfaces/owner_repository_interface.dart';

import '../models/owner_model.dart';

class OwnerRepositoryImpl implements OwnerRepository{
  final OwnerRemoteDataSource remoteDataSource;

  OwnerRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OwnerEntity>> getOwners() async{
    return await remoteDataSource.fetchOwners();
  }

  @override
  Future<Map<String, dynamic>> makeOwner(OwnerEntity owner) async{
    final ownerModel = OwnerModel.fromEntity(owner);
    return await remoteDataSource.createOwner(ownerModel);
  }

  @override
  Future<Map<String, dynamic>> updateOwner(OwnerEntity owner) async{
    final ownerModel = OwnerModel.fromEntity(owner);
    return await remoteDataSource.editOwner(ownerModel);
  }


}