import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:local_auth/local_auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: PassCodeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class PassCodeScreen extends StatefulWidget {
  PassCodeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PassCodeScreenState createState() => new _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  bool isFingerprint = false;

  Future<Null> biometrics() async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: false);
//    try {
//      authenticated = await auth.authenticateWithBiometrics(
//          localizedReason: 'Scan your fingerprint to authenticate',
//          useErrorDialogs: true,
//          stickyAuth: false);
//    } on PlatformException catch (e) {
//      print(e);
//    }
    if (!mounted) return;
    if (authenticated) {
      setState(() {
        isFingerprint = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var myPass = [1, 2, 3, 4];
    return LockScreen(
        title: "Passcode",
        passLength: myPass.length,
        bgImage: "assets/images/bg.jpg",
        fingerPrintImage: "assets/images/fingerprint.png",
        showFingerPass: true,
        fingerFunction: biometrics,
        numColor: Colors.blue,
        fingerVerify: isFingerprint,
        borderColor: Colors.white,
        showWrongPassDialog: true,
        wrongPassContent: "Wrong pass please try again.",
        wrongPassTitle: "Opps!",
        wrongPassCancelButtonText: "Cancel",
        passCodeVerify: (passcode) async {
          for (int i = 0; i < myPass.length; i++) {
            if (passcode[i] != myPass[i]) {
              return false;
            }
          }

          return true;
        },
        onSuccess: () {

        });
  }
}
