import 'dart:io';

import 'package:app/core/helpers/firebase_storage_helper/firebase_storage_helpers.dart';
import 'package:app/core/helpers/firestore_helpers/firestore_helpers.dart';
import 'package:app/core/helpers/image_picker_helper/image_picker_helper.dart';
import 'package:app/core/helpers/user_helper.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:app/features/profile/presentation/model/profile_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  BuildContext context;
  FireStoreHelpers _fireStoreHelpers = FireStoreHelpers();
  FireBaseStorageHelper _fireBaseStorageHelper = FireBaseStorageHelper();
  ProfileBloc({required this.context}) : super(ProfileInitial()) {
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
        if (event.profileModel.image != null &&
            event.profileModel.image is File) {
          final result = await _fireBaseStorageHelper.uploadProfilePicture(
            event.profileModel.image!,
          );
          result.fold((l) {
            emit(
              ProfileError(message: l.message ?? 'Failed to upload image'),
            );
          }, (r) async {
            if (r.isNotEmpty) {
              event.profileModel.image = r;
              add(UpdateUserOnFireStore(profileModel: event.profileModel));
            }
          });
        } else {
          add(UpdateUserOnFireStore(profileModel: event.profileModel));
        }
      },
    );

    on<UpdateUserOnFireStore>((event, emit) async {
      final result = await _fireStoreHelpers.updateUser(
        event.profileModel.toMap(),
      );
      result.fold(
        (l) {
          emit(
            ProfileError(message: l.message ?? 'Failed to upload image'),
          );
        },
        (r) {
          if (r) {
            emit(ProfileSuccess());
          } else {
            emit(ProfileError(message: 'Failed to upload image'));
          }
        },
      );
    });

    on<GetUserEvent>(
      (event, emit) async {
        print('event================> called');
        emit(GetUserLoadingState());
        String? token = await SharedPreferencesHelper.getUser();

        if (token == null)
          return emit(GetUserErrorState(message: 'User not found'));

        try {
          final result = await _fireStoreHelpers.getUser(token);

          if (result == null) {
            return emit(GetUserErrorState(message: 'User not found'));
          }
          emit(GetUserSuccessState(user: result));
        } catch (e) {
          emit(GetUserErrorState(message: e.toString()));
        }
      },
    );
  }
}
