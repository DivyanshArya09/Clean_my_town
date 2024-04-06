part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class AddProfilePicture extends ProfileEvent {}

final class RemoveProfilePicture extends ProfileEvent {}

final class UpdateProfile extends ProfileEvent {}

final class PickImageEvent extends ProfileEvent {
  final ImageSource imageSource;
  PickImageEvent({required this.imageSource});
}

final class SaveProfile extends ProfileEvent {
  final File image;
  SaveProfile({required this.image});
}
