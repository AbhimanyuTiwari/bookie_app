import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:bookie/constants/custom_button.dart';
import 'package:bookie/constants/header.dart';
import 'package:bookie/Wrapper.dart';

class Authenticate extends StatefulWidget {
  Authenticate({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

TextEditingController phoneNoController = TextEditingController();
bool isLoading = false;
String errorText = "";
TextEditingController otpController = TextEditingController();

String phoneNo;
String smsOTP;
String verificationId;
String errorMessage = '';
FirebaseAuth _auth = FirebaseAuth.instance;

class _AuthenticateState extends State<Authenticate> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            //  print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            // print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  handleError(var error) {
    //  print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
          isLoading = false;
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Text(
              "Login with your registered\n mobile number",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter your mobile no.",
                      prefixText: "+91 ",
                      prefixStyle: TextStyle(color: Colors.black, fontSize: 17),
                      icon: Icon(Icons.phone_android),
                    ),
                    controller: phoneNoController,
                    validator: (value) {
                      if (value.isEmpty)
                        return "Enter Phone No.";
                      else if (value.length != 10)
                        return "Enter valid phone no.";
                      else
                        return null;
                    }),
              ),
            ),
            SizedBox(height: 30),
            loading
                ? CircularProgressIndicator()
                : CustomButton(
                    text: "Get OTP",
                    color: Theme.of(context).primaryColor,
                    textStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                    width: 320,
                    borderRadius: 20,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                          phoneNo = "+91" + phoneNoController.text;
                        });

                        await verifyPhone();

                        setState(() {
                          loading = false;
                        });

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Otp()));
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}

class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  bool loading = false;
  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      AuthResult auth = await _auth.signInWithCredential(credential);
      final FirebaseUser user = auth.user;

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      if (user != null) {
        //  print(user.uid);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Wrapper()),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      //  print(e);
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    //  print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
          isLoading = false;
        });

        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: header(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Text(
              "Enter the OTP received on your mobile number",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Form(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorText: errorMessage,
                    hintText: "Enter OTP",
                    icon: Icon(Icons.lock),
                  ),
                  controller: otpController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: _start == 0
                    ? GestureDetector(
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              //fontSize: 20,
                              color: Colors.blue),
                        ),
                        onTap: () async {
                          setState(() {
                            _start = 60;
                          });
                          await _AuthenticateState().verifyPhone();
                          startTimer();
                        },
                      )
                    : Text(
                        "Resend in $_start seconds",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            SizedBox(height: 30),
            isLoading
                ? CircularProgressIndicator()
                : CustomButton(
                    text: "Submit OTP",
                    color: Theme.of(context).primaryColor,
                    textStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                    width: 320,
                    borderRadius: 20,
                    onPressed: () async {
                      setState(() {
                        smsOTP = otpController.text;
                        isLoading = true;
                        // print(isLoading);
                      });
                      await signIn();
                      setState(() {
                        isLoading = false;
                      });
                    },
                  )
          ],
        ),
      ),
    );
  }
}
