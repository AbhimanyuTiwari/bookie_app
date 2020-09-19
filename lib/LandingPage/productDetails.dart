import 'package:bookie/Wrapper.dart';
import 'package:bookie/constants/custom_button.dart';
import 'package:bookie/constants/title_text.dart';
import 'package:bookie/modal/data_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Books book;

  ProductDetailPage({this.book});

  @override
  _ProductDetailPageState createState() =>
      _ProductDetailPageState(bookData: book);
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  final Books bookData;

  _ProductDetailPageState({this.bookData});

  AnimationController controller;
  int _current = 0;
  Animation<double> animation;
  Map book;

  static List<String> imgList;
  String ownerName = "";
  String ownerPhoto = "";
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  setOwner() async {
    book = {
      "title": bookData.title,
      "category": bookData.category,
      "year": bookData.year,
      "description": bookData.description,
      "price": bookData.price,
      "author": bookData.author,
      "userId": bookData.userId,
    };
    imgList.insert(0, bookData.image1);
    imgList.insert(1, bookData.image2);
    imgList.insert(2, bookData.image3);
    DocumentSnapshot doc = await usersRef.document(book["userId"]).get();
    setState(() {
      ownerName = doc.data["name"];
      ownerPhoto = doc.data["profileUrl"];
    });
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
    imgList.clear();
    setOwner();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isLiked = true;

  Widget _productImage() {
    return Column(children: [
      CarouselSlider(
        items: imageSliders,
        options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            // aspectRatio: 2.0,
            height: 290,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.map((url) {
          int index = imgList.indexOf(url);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
        maxChildSize: .8,
        initialChildSize: .47,
        minChildSize: .47,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                .copyWith(bottom: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Color(0xffa8a09b),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child: ClipRect(child: TitleText(text: book['title'], fontSize: 25))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TitleText(
                                  text: "\₹ ",
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                                TitleText(
                                  text: book["price"],
                                  fontSize: 25,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _description(),
                ],
              ),
            ),
          );
        });
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            TitleText(
              text: "Author - ",
              fontSize: 18,
            ),
            TitleText(
              text: book["author"],
              fontSize: 18,
              color: Colors.orange,
            ),
          ],
        ),
        SizedBox(height: 20),
        if (ownerName != "")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                text: "Book Owner",
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(ownerPhoto),
                    radius: 20,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  TitleText(
                    text: ownerName,
                    color: Colors.orange,
                    fontSize: 18,
                  )
                ],
              )
            ],
          ),
        SizedBox(
          height: 20,
        ),
        TitleText(
          text: "Book Description",
          fontSize: 20,
        ),
        SizedBox(height: 20),
        Text(
          book["description"],
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            TitleText(
              text: "Category - ",
              fontSize: 18,
            ),
            TitleText(
              text: book["category"],
              fontSize: 18,
              color: Colors.orange,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            TitleText(
              text: "Suitable for - ",
              fontSize: 18,
            ),
            TitleText(
              text: (book["year"] == "1")
                  ? "Fresher"
                  : (book["year"] == "2")
                      ? "2nd yr students"
                      : (book["year"] == "3")
                          ? "3rd yr students"
                          : "Final yr students",
              fontSize: 18,
              color: Colors.orange,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: CustomButton(
            text: "Request For Book",
            width: 250,
            color: Colors.orange,
            textStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.orange,
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: _flotingButton(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Bookie"),
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  _productImage(),
                ],
              ),
              _detailWidget()
            ],
          ),
        ),
      ),
    );
  }
}
