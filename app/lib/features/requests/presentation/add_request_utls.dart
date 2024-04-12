import 'package:app/features/requests/presentation/models/location_model.dart';

class AddRequestUtils {
  static String getArea(Address address) {
    String area = '';
    if (address.town != '') {
      area = address.town;
    } else if (address.county != '') {
      area = address.county;
    } else if (address.stateDistrict != '') {
      area = address.stateDistrict;
    } else if (address.postcode != '') {
      area = address.postcode;
    }
    return area;
  }
}
