import 'package:bookie/Authentication/Authenticate.dart';
import 'package:bookie/LandingPage/productDetails.dart';
import 'package:bookie/constants/custom_button.dart';
import 'package:bookie/constants/header.dart';
import 'package:bookie/modal/data_service.dart';
import 'package:bookie/my_account/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'Authentication/Login.dart';
import 'LandingPage/landing_page.dart';
import 'modal/auth.dart';
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}
UserData userData;
String userId;
final CollectionReference usersRef = Firestore.instance.collection("users");
final CollectionReference booksRef = Firestore.instance.collection("books");
final StorageReference storageRef = FirebaseStorage.instance.ref();
class _WrapperState extends State<Wrapper> {

  AuthServices auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
            stream: auth.onAuthStateChanged, //checking user exist or not
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                if (user == null) {
                  return Login();
                }
                userId=user.uid;
                return StreamBuilder(
                  stream: usersRef.document(userId).snapshots(),
                  builder: (context,snap){
                    if(snap.connectionState==ConnectionState.active)
                      {
                        DocumentSnapshot profileSnapshot=snap.data;
                        if(!profileSnapshot.exists) return Profile();
                        userData=UserSnapshot().getUserDetails(profileSnapshot);

                        //return ProductDetailPage();
                        return MainPage();
                      }
                    else
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  },
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            });

  }
}
