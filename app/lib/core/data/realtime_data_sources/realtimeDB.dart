import 'dart:io';

import 'package:app/core/data/firebase_storage_data_sources/firebase_storage.dart';
import 'package:app/core/data/firestore_datasources/firestore.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/helpers/user_helpers/user_helper.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDBdataSources {
  FireBaseStorageDataSources fireStorageHelpers = FireBaseStorageDataSources();
  FireStoreDataSources fireStoreHelpers = FireStoreDataSources();

  DatabaseReference db = FirebaseDatabase.instance.ref().child('requests');

  Future<Either<Failure, List<RequestModel>>> getOthersRquest(
      String area) async {
    try {
      final response = await db.orderByChild('area').equalTo(area).once();
      Map values = response.snapshot.value as Map;
      List<RequestModel> results = [];
      values.forEach(
        (key, value) {
          results.add(RequestModel.fromJson(value as Map));
        },
      );
      return right(results);
    } catch (e) {
      return left(NormalFailure(message: e.toString()));
    }
  }

  Stream<DatabaseEvent> getRealTimeData(String area) {
    return db.orderByChild('area').equalTo(area).onValue;
  }

  Future<Either<Failure, void>> addRequest(
      RequestModel data, File image) async {
    final uniquekey = DateTime.now().microsecondsSinceEpoch.toString();
    data = data.copyWith(docId: uniquekey);
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

  Future<Either<Failure, void>> UpdateRequest(
      Map<String, dynamic> data, String docId) async {
    try {
      await db.child(docId).update(data);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
    return const Right(null);
  }

  Future<Either<Failure, List<RequestModel>>> getRequests() async {
    try {
      String? token = await SharedPreferencesHelper.getUser();
      if (token == null)
        return const Left(
          ServerFailure(message: 'No user found with this token'),
        );

      UserModel? user = await fireStoreHelpers.getUser(token);
      if (user == null)
        return const Left(
          ServerFailure(message: 'No user found with this token'),
        );

      List<Future<DataSnapshot>> futures = await user.requests
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
      print('err occured here=========================>');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
