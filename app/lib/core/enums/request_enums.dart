import 'dart:ui';

enum RequestType {
  others,
  my,
}

enum RequestStatus {
  pending,
  inProgress,
  completed,
}

extension RequestStatusExtension on RequestStatus {
  String get textValue {
    switch (this) {
      case RequestStatus.pending:
        return "Pending";
      case RequestStatus.inProgress:
        return "In Progress";
      case RequestStatus.completed:
        return "Completed";
    }
  }

  Color get colorValue {
    switch (this) {
      case RequestStatus.pending:
        return const Color.fromARGB(255, 255, 187, 0);
      case RequestStatus.inProgress:
        return const Color.fromARGB(255, 255, 187, 0);
      case RequestStatus.completed:
        return const Color.fromARGB(255, 0, 255, 0);
    }
  }
}

extension GetRequestStatus on String {
  RequestStatus get requestStatus {
    switch (this) {
      case 'Pending':
        return RequestStatus.pending;
      case 'In Progress':
        return RequestStatus.inProgress;
      case 'Completed':
        return RequestStatus.completed;
      default:
        return RequestStatus.pending;
    }
  }
}
