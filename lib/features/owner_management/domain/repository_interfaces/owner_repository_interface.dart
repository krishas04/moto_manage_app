import '../entities/owner.dart';

abstract class OwnerRepository {
  Future<List<OwnerEntity>> getOwners(String token);
  Future<Map<String, dynamic>> makeOwner(OwnerEntity owner,String token);
  Future<Map<String, dynamic>> updateOwner(OwnerEntity owner,String token);
}