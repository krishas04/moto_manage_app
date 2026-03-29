import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/constants/app_colors.dart';

import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/domain/usecases/get_owners_usecase.dart';

import '../../../../core/di/service_locator.dart';


class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
 late final GetOwnersUseCase getOwnersUseCase = getIt<GetOwnersUseCase>();
  late Future<List<OwnerEntity>> futureOwners;

  @override
  void initState() {
    super.initState();
    _loadOwners();
  }

 void _loadOwners() {
   setState(() {
     futureOwners = getOwnersUseCase.call();
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vehicle Owners'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadOwners,
            ),
          ],
        ),
        body: FutureBuilder<
            List<OwnerEntity>>(
          future: futureOwners,
          builder: (context, snapshot) {
            // Waiting for data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error occurred
            else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // Data received successfully
            else if (snapshot.hasData) {
              final owners = snapshot.data!;

              // Handle empty list case
              if (owners.isEmpty) {
                return const Center(child: Text("No owners found."));
              }

              return ListView.separated(
                itemCount: owners.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final owner = owners[index];
                  return Container(
                    decoration:BoxDecoration(
                      color: AppColors.b,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundOffWhite,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/man.svg',
                          width: 50,
                          height: 50,
                          ),
                      ),
                      title: Text(owner.fullName!),
                      subtitle: Text(owner.phoneNumber),
                      trailing: GestureDetector(
                          child: Icon(Icons.edit_note_outlined),
                          onTap: () {
                            context.push('/user/edit/${owner.id}').then(
                                    (_){
                                      if (mounted) _loadOwners();
                                    });
                          },
                      ),
                      onTap: (){
                        context.push('/vehicles/${owner.id}');
                      },
                    ),
                  );
                },
              );
            }

            // If nothing matches
            return const Center(child: Text("Something went wrong"));
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            context.push('/users');
            },
          label: Text('+ Create User'),
        )
    );
  }
}