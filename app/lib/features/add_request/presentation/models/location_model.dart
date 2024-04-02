class LocationModel {
  final int placeId;
  final String licence;
  final String osmType;
  final int osmId;
  final double lat;
  final double lon;
  final String displayName;
  final Address address;
  final List<String> boundingBox;

  LocationModel({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.address,
    required this.boundingBox,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      placeId: json['place_id'] ?? '',
      licence: json['licence'] ?? '',
      osmType: json['osm_type'] ?? '',
      osmId: json['osm_id'] ?? '',
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      displayName: json['display_name'] ?? '',
      address: Address.fromJson(json['address']),
      boundingBox: json['boundingbox'].cast<String>(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'place_id': placeId,
      'licence': licence,
      'osm_type': osmType,
      'osm_id': osmId,
      'lat': lat,
      'lon': lon,
      'display_name': displayName,
      'address': address.toMap(),
      'boundingbox': boundingBox,
    };
  }
}

class Address {
  final String amenity;
  final String road;
  final String town;
  final String county;
  final String stateDistrict;
  final String state;
  final String iso3166lvl4;
  final String postcode;
  final String country;
  final String countryCode;

  Address({
    required this.amenity,
    required this.road,
    required this.town,
    required this.county,
    required this.stateDistrict,
    required this.state,
    required this.iso3166lvl4,
    required this.postcode,
    required this.country,
    required this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      amenity: json['amenity'] ?? '',
      road: json['road'] ?? '',
      town: json['town'] ?? '',
      county: json['county'] ?? '',
      stateDistrict: json['state_district'] ?? '',
      state: json['state'] ?? '',
      iso3166lvl4: json['ISO3166-2-lvl4'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? '',
      countryCode: json['country_code'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amenity': amenity,
      'road': road,
      'town': town,
      'county': county,
      'state_district': stateDistrict,
      'state': state,
      'ISO3166-2-lvl4': iso3166lvl4,
      'postcode': postcode,
      'country': country,
      'country_code': countryCode,
    };
  }
}
