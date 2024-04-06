part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

final class ImagePickerError extends ProfileState {
  final String message;
  ImagePickerError({required this.message});
}

final class ImagePickerLoading extends ProfileState {}

final class ImagePickerSuccessState extends ProfileState {
  final File image;
  ImagePickerSuccessState({required this.image});
}
