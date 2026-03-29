import '../entities/owner.dart';

abstract class OwnerRepository {
  Future<List<OwnerEntity>> getOwners();
  Future<bool> makeOwner(OwnerEntity owner);
  Future<bool> updateOwner(OwnerEntity owner);
}