import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/core/utils/validators.dart';
import 'package:app/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:app/features/auth/presentation/widgets/or_widget.dart';
import 'package:app/features/shared/splash_screen.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:app/ui/custom_button.dart';
import 'package:app/ui/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();
  late TextEditingController _emailTC, _passTC;
  final _refBloc = SignUpBloc();

  @override
  void dispose() {
    _emailTC.dispose();
    _passTC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _emailTC = TextEditingController();
    _passTC = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpBloc, SignUpState>(
        bloc: _refBloc,
        buildWhen: (previous, current) =>
            current is LoginErr ||
            current is LoginLoading ||
            current is LoginSuccess,
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SplashScreen(
                    isUserLoggingIn: true,
                  );
                },
              ),
            );
            ToastHelpers.showToast('login in Success');
          }
          if (state is LoginErr) {
            ToastHelpers.showToast(state.error, err: true);
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
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
                          "Let's login and clean\nour town,\none swipe at a time",
                          style: AppStyles.headingDark,
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
                        CustomSpacers.height32,
                        CustomButton(
                          btnTxt: 'Login in',
                          onTap: () {
                            print('------------------->${_emailTC.text}');
                            // if (_formKey.currentState!.validate()) {
                            _refBloc.add(
                              SignInWithEmailAndPassword(
                                  email: _emailTC.text, password: _passTC.text),
                            );
                            // }
                          },
                        ),
                        OrWidget(
                          ontap: () {
                            CustomNavigator.pushTo(
                              context,
                              AppPages.signup,
                            );
                          },
                          txt: 'Sign Up',
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
