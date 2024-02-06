import 'package:crypt/crypt.dart';

class CryptHelper {
  static Future<String> cryptText(String theText) async {
    final c2 = Crypt.sha256(theText, rounds: 10000);
    return c2.toString();
  }

  static Future<bool> cryptCheck(String pass, String inputPass) async {
    final hashPass = Crypt(pass);
    return hashPass.match(inputPass);
  }
}
