import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/firestore_service.dart';
import 'package:flutter_application_1/models/model.user.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/keywords.dart';
import '../../controller/my_authentication_service.dart';
import '../../controller/my_services.dart';
import '../../utils/my_colors.dart';
import '../../utils/my_screensize.dart';
import '../../widgets/my_widget.dart';
import '../home/scr.home.dart';
import '../signup/scr_signup.dart';

enum FormData {
  Email,
  password,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  Color enabled = MyColors.pureYellowColor;
  Color enabledtxt = Colors.white;
  Color deaible = MyColors.bluishBlackColor;
  // Color backgroundColor = const Color(0xFF1F1A30);
  Color backgroundColor = MyColors.pureYellowColor;
  bool ispasswordev = true;
  FormData? selected;
  bool isLoading = false;
  bool isRememberd = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FirebaseAuth firebaseAuth;

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    // c: check already signed in user
    /* User? user = MyAuthenticationService.mCheckUserSignInStatus(
        firebaseAuth: firebaseAuth);
    if (user != null) {
      mLoadUserData(user);
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white,
              Colors.white,
              Colors.white
            ],
          ),
          /* image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                HexColor("#fff").withOpacity(0.2), BlendMode.dstATop),
            image: const NetworkImage(
              'https://mir-s3-cdn-cf.behance.net/project_modules/fs/01b4bd84253993.5d56acc35e143.jpg',
            ),
          ), */
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                  padding: const EdgeInsets.all(40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      vLoginGif(),
                      const SizedBox(
                        height: 10,
                      ),
                      vLoginGuideText(),
                      const SizedBox(
                        height: 20,
                      ),
                      vEmailInputField(),
                      const SizedBox(
                        height: 20,
                      ),
                      vPassInputFiled(),
                      const SizedBox(
                        height: 20,
                      ),
                      vRememberMe(),
                      const SizedBox(
                        height: 20,
                      ),
                      vSignInButton(),
                    ],
                  ),
                ),

                //End of Center Card
                //Start of outer card
                const SizedBox(
                  height: 10,
                ),

                vSigninGuideText2(),
                const SizedBox(height: 10),

                vGotoSignUpScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* void mGoNextPage(User user) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return LandingScreen(user: user);
    }));
  } */

  Widget vUserDummyImage() {
    return Image.asset(
      "assets/images/user.png",
      width: 100,
      height: 100,
    );
  }

  Widget vLoginGuideText() {
    return const Text(
      // "Please sign in to continue",
      "Welcome. Find your balance, unlock your potential",
      style: TextStyle(
        color: MyColors.bluishBlackColor,
      ),
    );
  }

  Widget vEmailInputField() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: selected == FormData.Email ? enabled : backgroundColor,
      ),
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: emailController,
        onTap: () {
          setState(() {
            selected = FormData.Email;
          });
        },
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: selected == FormData.Email ? enabledtxt : deaible,
            size: 20,
          ),
          hintText: 'Email',
          hintStyle: TextStyle(
              color: selected == FormData.Email ? enabledtxt : deaible,
              fontSize: 12),
        ),
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            color: selected == FormData.Email ? enabledtxt : deaible,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }

  Widget vPassInputFiled() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: selected == FormData.password ? enabled : backgroundColor),
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: passwordController,
        onTap: () {
          setState(() {
            selected = FormData.password;
          });
        },
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: selected == FormData.password ? enabledtxt : deaible,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: ispasswordev
                  ? Icon(
                      Icons.visibility_off,
                      color:
                          selected == FormData.password ? enabledtxt : deaible,
                      size: 20,
                    )
                  : Icon(
                      Icons.visibility,
                      color:
                          selected == FormData.password ? enabledtxt : deaible,
                      size: 20,
                    ),
              onPressed: () => setState(() => ispasswordev = !ispasswordev),
            ),
            hintText: 'Password',
            hintStyle: TextStyle(
                color: selected == FormData.password ? enabledtxt : deaible,
                fontSize: 12)),
        obscureText: ispasswordev,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            color: selected == FormData.password ? enabledtxt : deaible,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }

  Widget vSignInButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        mSignInProcess();
      },
      style: ElevatedButton.styleFrom(
          // fixedSize: Size(MyScreenSize.mGetWidth(context, 60), 50),
          backgroundColor: MyColors.pureGreenColor,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 48),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0))),
      child: isLoading
          ? MyWidget.vButtonProgressLoader()
          : const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget vSigninGuideText2() {
    return Text("Can't Log In?",
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          letterSpacing: 0.5,
        ));
  }

  Widget vGotoSignUpScreen() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(
              color: MyColors.bluishBlackColor,
              letterSpacing: 0.5,
            )),
            
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const SignupScreen();
            }));
          },
          child: Text("Sign up",
              style: TextStyle(
                  color: MyColors.darkYellowColor.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: 14)),
        ),
      ],
    );
  }

  bool mInputValidation() {
    if (emailController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  vRememberMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GFCheckbox(
            size: GFSize.SMALL,
            onChanged: (value) {
              setState(() {
                isRememberd = !isRememberd;
              });
            },
            value: isRememberd),
        const Text("Remember me")
      ],
    );
  }

  mSaveSessionStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool(MyKeywords.sessionStatus, isRememberd);
  }

  void mSignInProcess() async {
    if (mInputValidation()) {
      String email = emailController.value.text;
      String password = passwordController.value.text;

      var response = await MyAuthenticationService.mSignIn(
          firebaseAuth: firebaseAuth, email: email, password: password);
      if (response.runtimeType == User) {
        User? user = response as User;
        bool isVerified = MyAuthenticationService.mCheckUserVerified(
            firebaseAuth: firebaseAuth, user: user);
        if (isVerified) {
          // m: get User data
          await MyFirestoreService.mFetchUserData(
                  firebaseFirestore: FirebaseFirestore.instance,
                  email: user.email!)
              .then((value) {
            value != null
                ? {
                    // c: Save session data into sharedpreferece
                    mSaveSessionStatus(),
                    // c: Go to Landing Screen
                    mGoForward(user, value)
                  }
                : null;
          });
        } else {
          Future.delayed(const Duration(milliseconds: 1)).then((value) {
            MyWidget.vShowWarnigDialog(
                    context: context,
                    buttonText: "Check email",
                    message: "Email Verification",
                    desc: "Email is not verified. Please check your email.")
                .then((value) {
              MyServices.mLaunchGmailInbox(email: email);
            });
            setState(() {
              isLoading = false;
            });
          });
        }
      } else {
        String e = await response;
        Future.delayed(const Duration(milliseconds: 1)).then((value) {
          MyWidget.vShowWarnigDialog(
              context: context, message: "Sign in error", desc: e.toString());
        });
        setState(() {
          isLoading = false;
        });
      }
      //
    } else {
      setState(() {
        isLoading = false;
      });
      MyWidget.vShowWarnigDialog(context: context, message: "Input required*");
    }
  }

  void mGoForward(User user, UserData userData) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(
        userData: userData,
      );
    }));
  }

  vLoginGif() {
    return const Image(
        image: AssetImage("assets/animations/anim_security.gif"));
  }

  void mLoadUserData(User user) async {
    await MyFirestoreService.mFetchUserData(
            firebaseFirestore: FirebaseFirestore.instance, email: user.email!)
        .then((value) {
      if (value != null) {
        mGoForward(user, value);
      }
    });
  }
}
