import 'package:app/core/entities/fcm_entity.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/helpers/user_helpers/user_helper.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class FireStoreDataSources {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Either<Failure, bool>> updateFCMToken(FCMUpdateEntity entity) async {
    try {
      String? token = await SharedPreferencesHelper.getUser();
      if (token != null) {
        await firestore
            .collection('users')
            .doc(token)
            .update({'fcmToken': entity.token});
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
    return const Right(true);
  }

  Future<Either<Failure, void>> saveUser(UserModel user) async {
    try {
      String? token = await SharedPreferencesHelper.getUser();
      if (token != null) {
        await firestore.collection('users').doc(token).set(user.toMap());
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
    return const Right(null);
  }

  Future<String> updateMyRequestInFirestore(String request) async {
    try {
      String? docID = await SharedPreferencesHelper.getUser();
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(docID);
      docRef.update({
        'requests': FieldValue.arrayUnion([request]),
      });
      return docID.toString();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> updateAcceptedRequestInFirestore(
      String request, String token) async {
    try {
      String? docID = await SharedPreferencesHelper.getUser();

      print('======================================> docID $docID');
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(docID);
      docRef.update({
        'acceptedrequest': FieldValue.arrayUnion([
          {'request': request, 'fcmtoken': token}
        ]),
      });
      return docID.toString();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Either<Failure, bool>> updateUser(Map<String, dynamic> data) async {
    try {
      String? docID = await SharedPreferencesHelper.getUser();
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(docID);
      docRef.update(data);

      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<void> updatelocation(String town) async {
    String? token = await SharedPreferencesHelper.getUser();
    if (token != null) {
      try {
        DocumentReference documentSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(token);
        documentSnapshot.update({'location': town});
      } catch (e) {
        throw Exception(e.toString());
      }
    }
  }

  Future<UserModel?> getUser(String token) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(token).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      } else {
        throw Exception('No user found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
