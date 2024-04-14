import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomUrlLauncher {
  static Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri _phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunchUrl(_phoneUri)) await launchUrl(_phoneUri);
    } catch (error) {
      throw ("Cannot dial");
    }
  }

  static Future<void> openMapsForDirections(
    Coordinates start,
    Coordinates destination,
  ) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${start.lat},${start.lon}&destination=${destination.lat},${destination.lon}';
    try {
      if (!await launchUrl(Uri.parse(url))) {
        throw 'Could not launch $url';
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching Google Maps: $e');
    }
  }
}
