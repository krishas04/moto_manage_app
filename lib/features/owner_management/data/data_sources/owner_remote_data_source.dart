
import '../../../../core/api/api_service.dart';
import '../models/owner_model.dart';

class OwnerRemoteDataSource extends BaseRemoteDataSource<OwnerModel>{
  OwnerRemoteDataSource({required super.client});

  // fetch all users
  Future<List<OwnerModel>> fetchOwners() {
    return getList(
      endpoint: '/users/',
      fromJson: (json) => OwnerModel.fromJson(json),
    );
  }

  Future<bool> createOwner(OwnerModel owner) {
    return post(
      endpoint: '/users/',
      body: owner.toJson(),
    );
  }
  Future<bool> editOwner(OwnerModel owner) {
    return put(
      endpoint: '/users/${owner.id}',
      body: owner.toJson(),
    );
  }


}