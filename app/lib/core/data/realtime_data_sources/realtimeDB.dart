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

      final fireStoreResult = await fireStoreHelpers.getUser();

      print('fireStoreResult: ${fireStoreResult?.acceptedRequests}');

      if (fireStoreResult != null) {
        results = results
            .where((item) =>
                !fireStoreResult.acceptedRequests!.contains(item.docId))
            .toList();
      }
      return right(results);
    } catch (e) {
      return left(NormalFailure(message: e.toString()));
    }
  }

  Stream<DatabaseEvent> getRealTimeDataByArea(String area) {
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

  Future<Either<Failure, RequestModel>> getRequestByID(String docId) async {
    try {
      final response = await db.child(docId).once();
      Map values = response.snapshot.value as Map;
      return right(RequestModel.fromJson(values));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> setVolunteers(
      VolunteerModel data, String docId) async {
    try {
      final response = await db.child(docId).child('volunteers').once();

      List<VolunteerModel> results = [];
      if (response.snapshot.exists) {
        Map values = response.snapshot.value as Map;
        values.forEach(
          (key, value) {
            results.add(VolunteerModel.fromJson(value as Map));
          },
        );
      }
      results.add(data);

      print("result=================================> ${results.first}");
      await db
          .child(docId)
          .child('volunteers')
          .set(results.map((e) => e.toJson()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
    return const Right([]);
  }

  Future<Either<Failure, void>> deleteRequest(String docId) async {
    try {
      await db.child(docId).remove();
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

      UserModel? user = await fireStoreHelpers.getUser(token: token);
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
