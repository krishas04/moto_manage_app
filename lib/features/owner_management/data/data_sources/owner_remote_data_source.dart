import 'package:flutter/material.dart';
import '../../../../core/api/api_service.dart';
import '../models/owner_model.dart';

class OwnerRemoteDataSource extends BaseRemoteDataSource<OwnerModel>{
  OwnerRemoteDataSource({required super.client});

  // fetch all users
  Future<List<OwnerModel>> fetchOwners(String token) {
    try{
      return getList(
        endpoint: '/users/',
        fromJson: (json) => OwnerModel.fromJson(json),
        token: token
      );
    }catch (e, stackTrace) {
      debugPrint('Error in fetchOwners: $e');  // log
      debugPrintStack(stackTrace: stackTrace); // log location
      rethrow; // pass error upward
    }
  }

  Future<Map<String, dynamic>> createOwner(OwnerModel owner, String token) {
    try{
      return post(
        endpoint: '/users/',
        body: owner.toJson(),
        token: token
      );
    }catch (e, stackTrace) {
      debugPrint('Error in createOwner: $e');  // log
      debugPrintStack(stackTrace: stackTrace); // log location
      rethrow; // pass error upward
    }
  }


  Future<Map<String, dynamic>> editOwner(OwnerModel owner, String token) {
    try{
      return put(
        endpoint: '/users/${owner.id}',
        body: owner.toJson(),
        token: token
      );
    }catch (e, stackTrace) {
      debugPrint('Error in editOwner: $e');  // log
      debugPrintStack(stackTrace: stackTrace); // log location
      rethrow; // pass error upward
    }
  }


}