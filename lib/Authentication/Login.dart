import 'package:bookie/LandingPage/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:bookie/constants/custom_button.dart';
import 'package:bookie/modal/auth.dart';
import 'Authenticate.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  AuthServices auth = AuthServices();

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        loading = true;
      });
      await auth.signInWithGoogle();
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      //  print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Bookie",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          // SizedBox(height: 10,),
          Text("Why to buy new books ? Just ask your senior"),
          SizedBox(
            height: 60,
          ),
          Center(
            child: Container(
              height: 354,
              width: 467,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/logo.png"),
              )),
            ),
          ),

          loading
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    CustomButton(
                      text: "Sign in with Google",
                      onPressed: () => _signInWithGoogle(),
                      color: Colors.white,
                      // onPressed: (){
                      //   Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingPage()));
                      // },
                      image: "assets/google-logo.png",
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      borderRadius: 20,
                      width: 350,
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: "Login with phone no.",
//
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Authenticate())),
                      color: Color.fromRGBO(77, 69, 69, 1),
                      icon: Icon(
                        Icons.phone_android,
                        color: Colors.white,
                      ),
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      borderRadius: 20,
                      width: 350,
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
