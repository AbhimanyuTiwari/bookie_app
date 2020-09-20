import 'package:bookie/LandingPage/productDetails.dart';
import 'package:bookie/constants/title_text.dart';
import 'package:bookie/modal/data_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bookie/constants/product_card.dart';
import 'package:bookie/constants/product_icon.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

String currentCategory = "Books Related To Your Course";
class _MyHomePageState extends State<MyHomePage> {



  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: AppData.categoryList
            .map(
              (category) => GestureDetector(
                onTap:() {
                  setState(() {
                    AppData.categoryList.forEach((item) {
                      item.isSelected = false;
                    });
                    print(category.name);
                    currentCategory = category.name;
                    category.isSelected = true;
                  });
                },
                child: ProductIcon(
                  model: category,

                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _productWidget() {
    return StreamBuilder<Object>(
        stream: BooksInfo(value: currentCategory, isDashboard: true).booksList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<Books> books = snapshot.data ?? [];
            if(books.length==0)
              return Center(
                child: TitleText(text: "No books Available",fontSize: 25,),
              );

            return  GridView.builder(
                primary: true,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                // crossAxisCount: 2,
                // mainAxisSpacing: 10,
                // childAspectRatio: 0.80,
              padding: EdgeInsets.only(bottom: 10),

              gridDelegate:  new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
                physics: ScrollPhysics(),

                itemCount:books.length ,
                itemBuilder:(context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailPage(book: books[index],)));
                    },
                    child: ProductCard(
                      book: books[index],
                    ),
                  );
                },

            );


        }
          return Center(
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator()),

          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
     // height: MediaQuery.of(context).size.height - 210,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            _categoryWidget(),
            _productWidget(),
          ],
        ),
      ),
    );
  }
}
