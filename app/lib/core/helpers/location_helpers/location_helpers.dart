import 'dart:convert';

import 'package:app/core/constants/api_contant.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/features/add_request/presentation/models/location_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  Future<Either<Failure, LocationModel>> fetchPlace(
      double lat, double lon) async {
    String url = '$BASE_URL?lat=$lat&lon=$lon&format=json&api_Key=$API_Key';
    print('-============================> $url');
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final model = LocationModel.fromJson(jsonDecode(response.body));
      return Right(model);
    } else if (response.statusCode == 401) {
      return Left(NormalFailure(message: response.body));
    } else {
      return Left(ServerFailure(message: response.body));
    }
  }
}
