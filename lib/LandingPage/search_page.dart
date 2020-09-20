import 'package:bookie/LandingPage/productDetails.dart';
import 'package:bookie/Wrapper.dart';
import 'package:bookie/constants/title_text.dart';
import 'package:bookie/modal/data_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookie/LandingPage/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
                onSubmitted:(val){
                  setState(() {
                    search=val;
                  });

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
      appBar:  AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Bookie",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body:Column(
        children: [
          _search(),
          StreamBuilder<List<Books>>(
            stream: BooksInfo(isDashboard: false,value: search).booksList,
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.active){
                List<Books> searchResult=snapshot.data??[];
                if(searchResult.length==0)
                  return Center(child: TitleText(text: "No Result Found",fontSize: 23,),);
                return ListView.builder(
                  shrinkWrap: true,
                    itemCount: searchResult.length,
                    itemBuilder:(context,index) {
                     return GestureDetector(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailPage(book:searchResult[index])));
                       },
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(
                           color: Colors.blueGrey.withOpacity(.1),
                           child: Row(
                             children:[
                            Container(
                              margin: EdgeInsets.all(10),
                                height: 180,
                                width: 130,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(searchResult[index].image1),
                                        fit: BoxFit.fitHeight
                                    )
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TitleText( text:searchResult[index].title,
                                      fontSize: 22,color: Theme.of(context).primaryColor,),
                                      SizedBox(height: 15,),
                                      TitleText(text: "- ${searchResult[index].author}",fontSize: 18,),
                                      SizedBox(height: 10,),
                                      TitleText(text: "₹ ${searchResult[index].price}",fontSize: 35,),
                                      SizedBox(height: 10,),
                                      Text(searchResult[index].category),
                                    ],
                                  ),
                                ),
                              ),
                             ]
                            ),
                         ),
                       ),
                     );
                });
              }
              return Center(child: CircularProgressIndicator(),);
            },
          ),
        ],
      )

    );
  }
}
