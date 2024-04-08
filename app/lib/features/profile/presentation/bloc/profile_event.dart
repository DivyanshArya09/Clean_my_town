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
  final ProfileModel profileModel;
  SaveProfile({required this.profileModel});
}

final class GetUserEvent extends ProfileEvent {}

class UpdateUserOnFireStore extends ProfileEvent {
  final ProfileModel profileModel;
  UpdateUserOnFireStore({required this.profileModel});
}
