import 'package:app/core/errors/failures.dart';
import 'package:app/core/helpers/helper.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class FireStoreHelpers {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Either<Failure, void>> saveUser(UserModel user) async {
    try {
      String? token = await SharedPreferencesHelper.getString();
      if (token != null) {
        await firestore.collection('users').doc(token).set(user.toMap());
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
    return const Right(null);
  }

  Future<String> updateMyRequestInFirestore(String request) async {
    String? docID = await SharedPreferencesHelper.getString();
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(docID);
    docRef.update({
      'requests': FieldValue.arrayUnion([request]),
    }).then((value) {
      print("String added to requests array--------------------------->");
    }).catchError((error) {
      print(
          "Error adding string to requests array: $error---------------------->");
    });

    return docID.toString();
  }

  Future<void> updatelocation(String town) async {
    String? token = await SharedPreferencesHelper.getString();
    if (token != null) {
      DocumentReference documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(token);
      documentSnapshot
          .update({'location': town})
          .then(
            (value) => {
              print(
                  "location updated---------------------------------------->"),
            },
          )
          .onError(
            (error, stackTrace) => {
              throw Exception(error.toString()),
            },
          );
    }
  }

  Future<UserModel> getUser() async {
    try {
      String? token = await SharedPreferencesHelper.getString();
      if (token != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(token)
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          return UserModel.fromMap(data);
        }
      } else {
        throw Exception('No user found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    throw Exception('No user found');
  }
}
