import 'dart:io';

import 'package:app/core/errors/failures.dart';
import 'package:app/core/helpers/helper.dart';
import 'package:app/features/add_request/firebase_storage_helper/firebase_storage_helpers.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/home/firestore_helpers/firestore_helpers.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDBHelper {
  FireBaseStorageHelper fireStorageHelpers = FireBaseStorageHelper();
  FireStoreHelpers fireStoreHelpers = FireStoreHelpers();

  DatabaseReference db = FirebaseDatabase.instance.ref();

  Future<Either<Failure, List<RequestModel>>> getOthersRquest() async {
    String? town = await SharedPreferencesHelper.getLocation();
    List<RequestModel> results = [];
    print(town);
    try {
      DataSnapshot snapshot = await db.once().then((value) => value.snapshot);
      if (snapshot != null && snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value['town'].toString().toLowerCase() == town?.toLowerCase()) {
            // results.add({'key': key, 'data': value});
            RequestModel model = RequestModel(
                image: value['image'],
                town: value['town'],
                profilePic: value['profilePic'],
                description: value['description'],
                location: value['location'],
                title: value['title'],
                user: value['user'],
                status: value['status']);

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
    UserModel user = await fireStoreHelpers.getUser();
    List<String> requests = user.requests..add(uniquekey);
    fireStoreHelpers.saveUser(user.copyWith(requests: requests));
    // firstore store
    try {
      String imageUrl = await fireStorageHelpers.uploadImage(image);
      print(
          '===================================> ${data.copyWith(image: imageUrl, user: user.email)}');
      await db.child(uniquekey).set(
            data.copyWith(image: imageUrl, user: user.email).toJson(),
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
          if (snapshot.value is Map<String, dynamic>) {
            requests.add(
                RequestModel.fromJson(snapshot.value as Map<String, dynamic>));
          } else {
            Map value = snapshot.value as Map;
            RequestModel model = RequestModel(
                image: value['image'],
                town: value['town'],
                profilePic: value['profilePic'],
                description: value['description'],
                location: value['location'],
                title: value['title'],
                user: value['user'],
                status: value['status']);
            requests.add(model);
            // Handle the case where the value is not in the expected format
          }
        }
      }

      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
