import 'package:bookie/LandingPage/home_page.dart';
import 'package:bookie/LandingPage/nav_drawer.dart';
import 'package:bookie/LandingPage/search_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MainPageState createState() => _MainPageState();
}
bool isHomePageSelected = true;
String search;
class _MainPageState extends State<MainPage> {


  Widget _search() {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                onSubmitted: (val){
                  setState(() {

                    search=val;
                  });

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(fontSize: 12),

                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Bookie",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      drawer: NavDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _search(),
            SingleChildScrollView(
              child: MyHomePage(),
            ),
          ],
        ),
      ),
    );
  }
}
