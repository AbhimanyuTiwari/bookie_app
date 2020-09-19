import 'package:bookie/Wrapper.dart';
import 'package:bookie/constants/custom_button.dart';
import 'package:bookie/constants/header.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _profileImage;
  double width;
  bool loading=false;
  bool accessDenied = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController admissionNo = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController branch = TextEditingController();
  String errorDrop="";
  String errrorProfile="";

  List<String> yearDrop = [
    'Please Select          ',
    '1st Year',
    '2nd Year',
    '3rd Year',
    'Final Year',
  ];
  List<String> branchDrop = [
    'Please Select           ',
    'CSE',
    'IT',
  ];

  handelChooseImage(imageSource) async {
    PermissionStatus permissionStatus = await _getPermission(
        imageSource == ImageSource.gallery
            ? PermissionGroup.mediaLibrary
            : PermissionGroup.camera);
    if (permissionStatus == PermissionStatus.granted) {
      PickedFile _image = await ImagePicker()
          .getImage(
          source: imageSource, maxHeight: 675, maxWidth: 960, imageQuality: 88);
      File image = File(_image.path);
      setState(() {
        _profileImage = image;
      });
    } else {
      accessDenied = true;
      setState(() {});
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'Access to Camera denied',
        details: null,
      );
    }
  }

  selectImage(parentContext) async {
    return await showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: () {
                  handelChooseImage(ImageSource.camera);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () {
                  handelChooseImage(ImageSource.gallery);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Future<PermissionStatus> _getPermission(perm) async {
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(perm);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permisionStatus =
      await PermissionHandler().requestPermissions([perm]);
      return permisionStatus[perm] ?? PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  inputDecoration({String labeltext, IconData icon, String hintText = ""}) {
    return InputDecoration(
      icon: Icon(icon),
      labelText: labeltext,
      hintText: hintText,
    );
  }

  checkData({String data, String value}) {
    if (value.isEmpty)
      return "Please enter $data";
    else
      return null;
  }

  buildDropDown({
    TextEditingController controller,
    List dropDownList,
    String text,
  }) {
    String drop;
    if (controller.text == "")
      drop = dropDownList[0];
    else
      drop = controller.text;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(color: Colors.blue),
          ),
          Row(
            children: [
              SizedBox(
                //width: width * .40,
                child: DropdownButton(
                  //isDense: true,

                    hint: Text("Please Select"),
                    value: drop,
                    items: dropDownList.map((drop) {
                      return DropdownMenuItem(

                        value: drop,
                        child: Text(drop),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        controller.text = val;
                      });
                    }),
              ),
            ],
          ),

        ],
      ),
    );
  }
  Future<String> uploadImage(imageFile ) async {
    StorageUploadTask uploadTask = storageRef
        .child("_profileImage_${DateTime.now()}.jpg")
        .putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: header(context),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              (_profileImage == null)
                  ? Icon(
                Icons.account_circle,
                color: Theme
                    .of(context)
                    .primaryColor,
                size: 100,
              )
                  : CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50,
                backgroundImage: FileImage(_profileImage),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  selectImage(context);
                },
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Text(
                  "Add Profile Picture",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
              ),
              Text(errrorProfile,style: TextStyle(color: Colors.red),),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 10, right: 20, left: 10),
                child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "Enter Your Name",
                      hintText: "Enter  Your Name",
                    ),
                    controller: name,
                    keyboardType: TextInputType.text,
                    validator: (value) =>
                        checkData(data: "First Name", value: value)),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildDropDown(
                      text: "Branch",
                      dropDownList: branchDrop,
                      controller: branch),
                  buildDropDown(
                      text: "Year", dropDownList: yearDrop, controller: year),
                ],
              ),
              Text(errorDrop,style: TextStyle(color: Colors.red),),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 10, right: 20, left: 10),
                child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.credit_card),
                      labelText: "Admission No",
                      hintText: "19GCEBCSXXXX",
                    ),
                    controller: admissionNo,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.length != 11)
                        return "Enter valid Admission";
                      return null;
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 10, right: 20, left: 10),
                child: TextFormField(
                    decoration: inputDecoration(
                        labeltext: "Phone No", icon: Icons.phone),
                    controller: phoneNo,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.length != 10)
                        return "Enter valid phone no";
                      return null;
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 10, right: 20, left: 10),
                child: TextFormField(
                    decoration: inputDecoration(
                        labeltext: "Email Id", icon: Icons.email),
                    controller: emailId,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailId.text);
                      if (emailValid)
                        return null;
                      return "Enter valid Email Id";
                    }),
              ),

              SizedBox(height: 10),
              loading?CircularProgressIndicator():CustomButton(
                text: "Save",
                width: 200,
                color: Theme
                    .of(context)
                    .primaryColor,
                onPressed: () async{
                  if(_formKey.currentState.validate()&&branch.text!=null&&branch.text!=branchDrop[0]&&year.text!=null&&year.text!=yearDrop[0]&&_profileImage!=null)
                    {
                      setState(() {
                        loading=true;
                      });
                      String profileUrl= await uploadImage(_profileImage);
                      usersRef.document(userId).setData({
                        "profileUrl":profileUrl,
                        "name":name.text,
                        "emailId":emailId.text,
                        "phoneNo":phoneNo.text,
                        "admissionNo":admissionNo.text,
                        "year":year.text,
                        "branch":branch.text,
                      });

                      setState(() {
                        loading=false;
                      });
                    }
                   if(branch.text!=null||branch.text!=branchDrop[0]||year.text!=null||year.text!=yearDrop[0])
                    {
                      setState(() {
                        errorDrop="Please select from dropdown menu";
                      });
                    }
                  if(_profileImage==null){
                    setState(() {
                      errrorProfile="Please select profile image";
                    });
                  }
                },
                textStyle: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
