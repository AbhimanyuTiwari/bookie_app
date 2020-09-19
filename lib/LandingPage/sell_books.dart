import 'package:bookie/constants/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:bookie/modal/subjects';
import '../Wrapper.dart';
import 'package:image/image.dart' as Im;

class SellBooks extends StatefulWidget {
  @override
  _SellBooksState createState() => _SellBooksState();
}

class _SellBooksState extends State<SellBooks> {
  bool loading = false;
  bool accessDenied = false;
  String errorImage="";
  String errorYear="";
  String errorCategory="";
  double width;
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController author = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController price = TextEditingController();
  File image1;
  File image2;
  File image3;
  List<String> yearDrop = [
    'Please Select          ',
    '1',
    '2',
    '3',
    '4',
    "Other"
  ];

  Future<File> compressImage(File file) async {
    {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
      final compressedImageFile = File('$path/img_${DateTime.now()}.jpg')
        ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 60));
      print(file.lengthSync());
      print(compressedImageFile.lengthSync());
      return compressedImageFile;
    }
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

  handelChooseImage(imageSource, String imageType) async {
    // check permission
    PermissionStatus permissionStatus = await _getPermission(
        imageSource == ImageSource.gallery
            ? PermissionGroup.mediaLibrary
            : PermissionGroup.camera);
    // print(permissionStatus);
    if (permissionStatus == PermissionStatus.granted) {
      PickedFile _image = await ImagePicker()
          .getImage(source: imageSource, maxHeight: 675, maxWidth: 960);
      File image = File(_image.path);

      File temp = await compressImage(image);
      setState(() {
        image = temp;
        accessDenied = false;
        if (imageType == "image1")
          image1 = image;
        else if (imageType == "image2")
          image2 = image;
        else if (imageType == "image3")
          image3 = image;

        // do your work
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

  selectImage(parentContext, imageType) async {
    return await showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: () {
                  handelChooseImage(ImageSource.camera, imageType);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () {
                  handelChooseImage(ImageSource.gallery, imageType);
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
                        if (controller == year) category.text = "Please Select";
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

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask = storageRef
        .child("_profileImage_${DateTime.now()}.jpg")
        .putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  buildImage(index) {
    File file;
    if (index == 0)
      file = image1;
    else if (index == 1)
      file = image2;
    else
      file = image3;

    return Column(
      children: [
        (file == null)
            ? Container(
          width: 160,
          height: 180,
          child: Icon(
            Icons.add_a_photo,
            size: 100,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        )
            : Container(
          width: 160,
          height: 180,
          decoration: BoxDecoration(
              image: DecorationImage(image: FileImage(file))),
        ),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () {
              selectImage(context, "image${index + 1}");
            },
            textColor: Colors.white,
            child: Text(index == 0 ? "Add Cover Photo" : "Add Other Photos")
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      year.text = "Please Select          ";
    });
  }

  @override
  Widget build(BuildContext context) {
 
    width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sell Books",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 10, right: 20, left: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.library_books),
                        labelText: "Enter Book Name",
                        hintText: "Enter  Book Name",
                      ),
                      controller: title,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          checkData(data: "Book Name", value: value)),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 10, right: 20, left: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "Author Name",
                        hintText: "Enter  Author Name",
                      ),
                      controller: author,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          checkData(data: "Author Name", value: value)),
                ),
                buildDropDown(
                    text: "Which year student can read it?",
                    dropDownList: yearDrop,
                    controller: year),

                Text(errorYear,style: TextStyle(color: Colors.red),),
                // SizedBox(height: 10,),
                buildDropDown(
                    text: "Select Category",
                    dropDownList: (year.text == "Please Select          ")
                        ? subjects[0]
                        : subjects[int.parse(year.text)],
                    controller: category),

                Text(errorCategory,style: TextStyle(color: Colors.red),),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 10, right: 20, left: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.description),
                        labelText: "Description",
                        hintText: "Description of Book",
                      ),
                      maxLines: 5,
                      minLines: 1,
                      controller: description,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          checkData(data: "Description", value: value)),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 10, right: 20, left: 10),
                  child: TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.attach_money),
                          labelText: "Price",
                          hintText: "Price",
                          prefix: Text("₹  ")),
                      controller: price,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          checkData(data: "Price", value: value)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Add 3 photos of your Book",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 270,
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) =>
                        Card(
                          margin: EdgeInsets.only(left: 15),
                          shadowColor: Colors.grey,
                          child: buildImage(index),
                        ),
                  ),
                ),
                Text(errorImage,style: TextStyle(color: Colors.red),),
                SizedBox(height: 20,),
                loading?CircularProgressIndicator():CustomButton(
                  text: "SELL BOOK",
                  onPressed: () async{

                    if (_formKey.currentState.validate() && year.text != null &&
                        year.text != "Please Select          " &&
                        category.text != "Please Select" &&
                        category.text != null &&
                        (image1 != null && image2 != null && image3 != null))
                      {
                        setState(() {
                          loading=true;
                        });
                        String timestamp=DateTime.now().toString();
                        String image1Url= await uploadImage(image1);
                        String image2Url= await uploadImage(image2);
                        String image3Url= await uploadImage(image3);
                        booksRef.document(timestamp).setData({
                          "title":title.text,
                          "author":author.text,
                          "description":description.text,
                          "category":category.text,
                          "year":year.text,
                          "bookId":timestamp,
                          "price":price.text,
                          "image1":image1Url,
                          "image2":image2Url,
                          "image3":image3Url,
                          "userId":userId,
                        });
                        setState(() {
                          loading=false;
                        });

                        Fluttertoast.showToast(
                            msg: "SUCCESS : Book added for sell",
                            timeInSecForIosWeb: 4);
                        Navigator.pop(context);

                      }
                   else{
                     if(image1 == null || image2 != null || image3 != null){
                      setState(() {
                        errorImage="Please Select three images of books";
                      });
                    }
                     else{
                       setState(() {
                         errorImage="";
                       });
                     }
                    if(year.text == null || year.text == "Please Select          ")
                      setState(() {
                        errorYear="Please select from above dropdown menu";
                      });
                    else{
                      setState(() {
                        errorYear="";
                      });
                    }
                    if(category.text == "Please Select" || category.text == null)
                      setState(() {
                        errorCategory="Please select from above dropdown menu";
                      });
                    else{
                      setState(() {
                        errorCategory="";
                      });
                    }
                   }
                  },
                  width: 150,
                  color: Theme
                      .of(context)
                      .primaryColor,
                  textStyle: TextStyle(color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
