import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:qwiker_rider/core/global_functions.dart';
import 'package:qwiker_rider/features/profile/data/user_model/rider_model.dart';
import 'package:qwiker_rider/features/profile/data/user_repo_imple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/exptions/error_handeler.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  final UserRepoImple _userRepoImple;
  UserDataCubit(this._userRepoImple) : super(UserDataInitial());

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController extraPhoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addNewUser(RiderModel user) async {
    emit(UserDataLoading());

    Either<Falure, Future<void>> result = _userRepoImple.addNewUser(user);

    result.fold(
        (faluer) => emit(
              UserDataFalure(errorMessage: faluer.errorMessage),
            ), (success) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('hasProfile', true);
      emit(UserDataAddedSuccess());
    });
  }

  Future<void> getUserProfileData() async {
    emit(UserDataLoading());
    final String userId = await getPhoneNumber();
    Either<Falure, Future<RiderModel>> result =
        _userRepoImple.getUserProfileData(userId);

    result.fold(
        (faluer) => emit(
              UserDataFalure(errorMessage: faluer.errorMessage),
            ), (success) async {
      final RiderModel userData = await success;
      emailController.text = userData.email;
      nameController.text = userData.riderName;
      phoneController.text = userData.riderPhone;
      extraPhoneController.text = userData.extraPhoneNumber ?? '';
      emit(UserDataAddedSuccess());
    });
  }

  Future<void> updateUserProfileData(RiderModel user) async {
    emit(UserDataLoading());

    Either<Falure, Future<void>> result = _userRepoImple.addNewUser(user);

    result.fold(
        (faluer) => emit(
              UserDataFalure(errorMessage: faluer.errorMessage),
            ), (success) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('hasProfile', true);
      emit(UserDataAddedSuccess());
    });
  }
}
