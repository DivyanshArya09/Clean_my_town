import 'dart:io';

import 'package:app/core/errors/failures.dart';
import 'package:app/core/helpers/firebase_storage_helper/firebase_storage_helpers.dart';
import 'package:app/core/helpers/firestore_helpers/firestore_helpers.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDBHelper {
  FireBaseStorageHelper fireStorageHelpers = FireBaseStorageHelper();
  FireStoreHelpers fireStoreHelpers = FireStoreHelpers();

  DatabaseReference db = FirebaseDatabase.instance.ref().child('requests');

  Future<Either<Failure, List<RequestModel>>> getOthersRquest() async {
    // String? town = await SharedPreferencesHelper.getLocation();
    List<RequestModel> results = [];
    // print(town);
    try {
      DataSnapshot snapshot = await db.once().then((value) => value.snapshot);
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value['town'].toString().toLowerCase() == 'delhi'.toLowerCase()) {
            RequestModel model = RequestModel(
                image: value['image'],
                town: value['town'],
                profilePic: value['profilePic'],
                description: value['description'],
                location: value['location'],
                title: value['title'],
                user: value['user'],
                status: value['status'],
                dateTime: value['status']);

            results.add(model);
          }

          print('i am in block');
          print(results);
        });
      } else {
        print('Snapshot is empty');
      }
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
    print(results);
    return Right(results);
  }

  Future<Either<Failure, void>> addRequest(
      RequestModel data, File image) async {
    final uniquekey = DateTime.now().microsecondsSinceEpoch.toString();
    try {
      String imageUrl = await fireStorageHelpers.uploadImage(image);
      String id = await fireStoreHelpers.updateMyRequestInFirestore(uniquekey);
      await db.child(uniquekey).set(
            data.copyWith(image: imageUrl, user: id).toJson(),
          );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
    return const Right(null);
  }

  Future<Either<Failure, List<RequestModel>>> getRequests() async {
    try {
      UserModel user = await fireStoreHelpers.getUser();
      List<Future<DataSnapshot>> futures = user.requests
          .map((e) => db.child(e).once().then((event) => event.snapshot))
          .toList();
      List<DataSnapshot?> snapshots = await Future.wait(futures);
      List<RequestModel> requests = [];
      for (var snapshot in snapshots) {
        if (snapshot != null && snapshot.value != null) {
          requests.add(RequestModel.fromJson(snapshot.value as Map));
        }
      }
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
