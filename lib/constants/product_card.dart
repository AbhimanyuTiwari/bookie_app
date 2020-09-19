import 'package:bookie/constants/title_text.dart';
import 'package:bookie/modal/data_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



class ProductCard extends StatelessWidget {
  final Books book;

  ProductCard({Key key, this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget cachedNetworkImage(String mediaUrl) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 10  horizontally
                5.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: CachedNetworkImage(
          imageUrl: mediaUrl,
          fit: BoxFit.cover,

          width: double.infinity,
          placeholder: (context, url) => Padding(
            child: CircularProgressIndicator(),
            padding: EdgeInsets.all(20.0),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
        ],
      ),

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Positioned(
            //   left: 0,
            //   top: 0,
            //   // child: IconButton(
            //   //   icon: Icon(
            //   //     product.isliked ? Icons.favorite : Icons.favorite_border,
            //   //     color:
            //   //     product.isliked ? Colors.red : Color(0xffa8a09b),
            //   //   ),
            //   //   onPressed: () {},
            //   // ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
               // SizedBox(height: product.isSelected ? 15 : 0),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.orange,
                      ),
                      Image.network(book.image1)
                    ],
                  ),
                ),
                // SizedBox(height: 5),
                TitleText(
                  text: book.title,
                  fontSize: 14,
                ),
                TitleText(
                  text: book.author,
                  fontSize: 12,
                  color: Colors.orange,
                ),
                TitleText(
                  text:book.price.toString(),
                  fontSize:  16,
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
