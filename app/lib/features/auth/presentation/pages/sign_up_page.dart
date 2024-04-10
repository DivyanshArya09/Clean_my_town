import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/helpers/user_helper.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/core/utils/user_helpers.dart';
import 'package:app/core/utils/validators.dart';
import 'package:app/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:app/features/auth/presentation/widgets/or_widget.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:app/ui/custom_button.dart';
import 'package:app/ui/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../route/app_pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _formKey = GlobalKey<FormState>();
  late TextEditingController _nameTC, _emailTC, _passTC, _confirmPassTC;
  final _refBloc = SignUpBloc();
  UserModel model = UserModel.empty();
  UserHelpers userHelpers = UserHelpers();

  @override
  void dispose() {
    _nameTC.dispose();
    _emailTC.dispose();
    _passTC.dispose();
    _confirmPassTC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _nameTC = TextEditingController();
    _emailTC = TextEditingController();
    _passTC = TextEditingController();
    _confirmPassTC = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpBloc, SignUpState>(
        bloc: _refBloc,
        buildWhen: (previous, current) =>
            current is SignUpError ||
            current is SignUpSuccess ||
            current is SignUpLoading ||
            current is UserSuccessFullyStoredToDBState ||
            current is UserFailedToStoreToDBState ||
            current is UserLoadingDBState,
        listener: (context, state) {
          if (state is UserSuccessFullyStoredToDBState) {
            CustomNavigator.pushReplace(context, AppPages.verfyemail);
          }

          if (state is UserFailedToStoreToDBState) {
            ToastHelpers.showToast(state.error, err: true);
            print("----------------------------------->${state.error}");
          }

          if (state is SignUpSuccess) {
            _refBloc.add(
              SaveUserToDB(
                user: model.copyWith(
                  name: state.name,
                  email: state.email,
                  password: state.password,
                ),
              ),
            );
          }
          if (state is SignUpError) {
            ToastHelpers.showToast(state.error, err: true);
          }
        },
        builder: (context, state) {
          if (state is SignUpLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoadingDBState) {
            return const Center(child: CircularProgressIndicator());
          }

          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: double.infinity,
                    width: double.maxFinite,
                    child: Image.asset(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      AppImages.bgImg,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DEFAULT_Horizontal_PADDING,
                      vertical: DEFAULT_VERTICAL_PADDING),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSpacers.height36,
                        Text(
                          'Ready to join the clean revolution?\nSign up now and be\na hero for our town!',
                          style: AppStyles.headingDark,
                        ),
                        CustomSpacers.height16,
                        CustomTextField(
                          hint: 'Enter your name',
                          controller: _nameTC,
                        ),
                        CustomSpacers.height16,
                        CustomTextField(
                          keyboardType: TextInputType.emailAddress,
                          hint: 'Enter your Email',
                          controller: _emailTC,
                          validator: (email) {
                            return Validators.isValidEmail(email);
                          },
                        ),
                        CustomSpacers.height16,
                        CustomTextField(
                          isPasswordField: true,
                          hint: 'Enter your password',
                          validator: (val) {
                            return Validators.isValidPassword(val);
                          },
                          controller: _passTC,
                        ),
                        CustomSpacers.height16,
                        CustomTextField(
                          isPasswordField: true,
                          validator: (val) {
                            return Validators.isValidPassword(val,
                                confirmPassword: _confirmPassTC.text);
                          },
                          hint: 'Confirm your password',
                          controller: _confirmPassTC,
                        ),
                        CustomSpacers.height32,
                        CustomButton(
                          btnTxt: 'Sign Up',
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await SharedPreferencesHelper.saveUser(
                                  _emailTC.text);
                              _refBloc.add(
                                SignUpWithEmailAndPassword(
                                    email: _emailTC.text,
                                    password: _passTC.text,
                                    name: _nameTC.text),
                              );
                            }
                          },
                        ),
                        OrWidget(
                          ontap: () {
                            CustomNavigator.pushTo(
                              context,
                              AppPages.login,
                            );
                          },
                          txt: 'Login',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
