import '../entities/owner.dart';

abstract class OwnerRepository {
  Future<List<OwnerEntity>> getOwners();
  Future<Map<String, dynamic>> makeOwner(OwnerEntity owner);
  Future<Map<String, dynamic>> updateOwner(OwnerEntity owner);
}