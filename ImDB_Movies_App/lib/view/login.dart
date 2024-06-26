import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_mvvm/res/colors.dart';
import 'package:learning_mvvm/res/components/frosted_glass_box.dart';
import 'package:learning_mvvm/res/components/round_button.dart';
import 'package:learning_mvvm/utils/routes/routes_name.dart';
import 'package:learning_mvvm/utils/utils.dart';
import 'package:learning_mvvm/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';

import '../res/components/background_image.dart';
import '../res/components/check_circle_icon.dart';
import '../res/components/headline.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    if (kDebugMode) {
      _emailController.text = "eve.holt@reqres.in";
      _passwordController.text = "cityslicka";
    }
    super.initState();
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Provider
  ValueNotifier<bool> _obscurePass = ValueNotifier<bool>(true);

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  Map<String, dynamic> getUserCredentials() {
    return {
      "email": _emailController.text.trim().toString(),
      "password": _passwordController.text.trim().toString(),
    };
    // trim() method removes any leading (front) or trailing (back) spaces from user input before using it in the application
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _obscurePass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    void TextFieldValidate() {
      if (_emailController.text.isEmpty) {
        Utils.snackBar("Email can't be empty!", context);
      } else if (!_emailController.text.contains("@")) {
        Utils.snackBar("Email must contain @", context);
      } else if (_passwordController.text.isEmpty) {
        Utils.snackBar("Password can't be empty!", context);
      } else if (_passwordController.text.length < 6) {
        Utils.snackBar("Password must be more than 6 letter's", context);
      } else {
        final _authViewModel =
            Provider.of<AuthViewModel>(context, listen: false);
        _authViewModel.loginApi(getUserCredentials(), context);
      }
    }

    return WillPopScope(
      // Android User's can simply exit from app by pressing back button
      onWillPop: () async {
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImage(),
            FrostedGlassBox(
              height: _height * .7,
              width: _width < 450 ? double.infinity : 480,
              child: login(_height, TextFieldValidate, context),
            ),
          ],
        ),
      ),
    );
  }

  Padding login(
      double _height, void TextFieldValidate(), BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CheckCircleIcon(),
          SizedBox(height: _height * .03),
          Headline(title: "Welcome!!"),
          SizedBox(height: _height * .04),
          email(),
          SizedBox(height: _height * .02),
          password(),
          SizedBox(height: _height * .05),
          Consumer<AuthViewModel>(
            builder: (context, value, child) {
              return RoundButton(
                  title: "Login",
                  loading: value.loginLoading,
                  onTap: () {
                    TextFieldValidate();
                  });
            },
          ),
          SizedBox(height: _height * .02),
          buildSignUpQueryOption(context),
        ],
      ),
    );
  }

  Widget buildSignUpQueryOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            color: AppColors.semiTransparentColor,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, RoutesName.signup);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors
                .click, // Icon changed when user hover over the container
            child: Container(
              padding: EdgeInsets.all(10),
              child: const Text(
                "Sign up",
                style: TextStyle(
                  color: AppColors.buttonkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ValueListenableBuilder<bool> password() {
    return ValueListenableBuilder(
      valueListenable: _obscurePass,
      builder: (context, value, child) {
        return TextField(
          controller: _passwordController,
          obscureText: value,
          obscuringCharacter: '#', // Password secured by showing -> #######
          focusNode: _passwordFocusNode,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Icon(Icons.lock_open_outlined),
            suffixIcon: InkWell(
              onTap: () {
                _obscurePass.value = !_obscurePass.value;
              },
              child: Icon(
                _obscurePass.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
        );
      },
    );
  }

  TextField email() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      focusNode: _emailFocusNode,
      onSubmitted: (value) {
        // After submitting email, click done on keyboard, focus on the password bar

        Utils.changeFocusNode(context,
            current: _emailFocusNode, next: _passwordFocusNode);
      },
      decoration: InputDecoration(
        hintText: "Email",
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }
}
