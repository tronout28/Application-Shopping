import 'package:application_action/Page/Widget/navbarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // variabel set obsecureText
  var isObsecure = true.obs;

  // Variable data pengguna
  var email = ''.obs;
  var password = ''.obs;

  // Validator variable
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var isEmailAndPasswordCorrect = true.obs;

  // Email RegExp
  final emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );
  bool isAllValid() {
    if (isEmailValid.value == true && isPasswordValid.value == true) {
      return true;
    } else {
      return false;
    }
  }

  void setObsecure() {
    isObsecure.value = !isObsecure.value;
  }

  Future<void> userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.value, password: password.value);
      writeToSharedPreference();
      Get.offAll(NavbarWidget());
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        print('No user found for that email.');
        isEmailAndPasswordCorrect.value = false;
        isEmailValid.value = false;
        isPasswordValid.value = false;
      }
    }
  }

  Future<void> writeToSharedPreference() async {
    // Intialize SharedPreference
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", true);
    prefs.setString("email", email.value);
    Get.offAll(NavbarWidget());
  }
}
