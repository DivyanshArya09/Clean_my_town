import 'dart:io';

import 'package:app/core/helpers/firebase_storage_helper/firebase_storage_helpers.dart';
import 'package:app/core/helpers/image_picker_helper/image_picker_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  FireBaseStorageHelper _fireBaseStorageHelper = FireBaseStorageHelper();
  ProfileBloc() : super(ProfileInitial()) {
    on<PickImageEvent>(
      (event, emit) async {
        emit(ImagePickerLoading());
        final result =
            await ImagePickerhelper.pickImage(source: event.imageSource);
        result.fold(
          (l) => emit(
            ImagePickerError(message: l.message ?? 'Failed to pick image'),
          ),
          (r) {
            if (r != null) {
              result.fold(
                  (l) => emit(
                        ImagePickerError(
                            message: l.message ?? 'Failed to pick image'),
                      ), (r) {
                if (r != null) {
                  emit(ImagePickerSuccessState(image: r));
                } else {
                  emit(ImagePickerError(message: 'Failed to pick image'));
                }
              });
              emit(ImagePickerSuccessState(image: r));
            } else {
              emit(
                ImagePickerError(message: 'Failed to pick image'),
              );
            }
          },
        );
      },
    );
    on<SaveProfile>(
      (event, emit) async {
        emit(ProfileLoading());
        final result =
            await _fireBaseStorageHelper.uploadProfilePicture(event.image);
        result.fold(
          (l) => emit(
            ProfileError(message: l.message ?? 'Failed to upload image'),
          ),
          (r) {
            if (r.isNotEmpty) {
              emit(ProfileSuccess());
            } else {
              emit(ProfileError(message: 'Failed to upload image'));
            }
          },
        );
      },
    );
  }
}
