import 'package:bookie/Authentication/Authenticate.dart';
import 'package:bookie/Wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookie/modal/subjects';

class UserData{
  final String userId;
  final String year;
  final String admissionNo;
  final String profileUrl;
  final String phoneNo;
  final String branch;
  UserData({
    this.userId,
    this.year,
    this.admissionNo,
    this.profileUrl,
    this.phoneNo,
    this.branch,
});
}
class UserSnapshot{
  UserData getUserDetails(DocumentSnapshot doc){
    return UserData(
      year: doc["year"],
      userId: doc["userId"],
      phoneNo: doc["phoneNo"],
      admissionNo:doc["admissionNo"],
      branch: doc["branch"],
      profileUrl: doc["profileUrl"]
    );
  }
}

class Books{
  final String title;
  final String author;
  final String price;
  final String userId;
  final String bookId;
  final String category;
  final String year;
  final String description;
  final String image1;
  final String image2;
  final String image3;
  Books({
    this.title,
    this.author,
    this.price,
    this.userId,
    this.bookId,
    this.category,
    this.year,
    this.description,
    this.image1,
    this.image2,
    this.image3,
});
}
class BooksInfo{
  String value;
  bool isDashboard;
  BooksInfo({
   this.value,this.isDashboard
});
  Stream<List<Books>> get booksList{
    if(value=="Books Related To Your Course")
      return booksRef.limit(10).snapshots().map(_booksFromSnapshot);
    if(isDashboard)
    return booksRef.where("category",isEqualTo: value).limit(4).snapshots().map(_booksFromSnapshot);
    else
      return booksRef.where("title",isGreaterThanOrEqualTo: value).snapshots().map(_booksFromSnapshot);
  }
 List<Books> _booksFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return Books(
        userId: doc["userId"],
        title:doc["title"],
        description:doc["description"],
        author:doc["author"],
        bookId:doc["bookId"],
        category: doc["category"],
        image1: doc["image1"],
        image2: doc["image2"],
        image3: doc["image3"],
        price: doc["price"],
        year: doc["year"]
      );
    }).toList();
  }
}
class Category{
  int id ;
  String name ;
  bool isSelected ;
  Category({this.id,this.name,this.isSelected = false,});
}
class AppData {

  static int i = 0;
  static List<Category> categoryList = subjects[int.parse(userData.year[0])]
      .map((subject) {
    if (i == 0) {
      i++;
      return Category(
          id: i, isSelected: true, name: "Books Related To Your Course");
    }
    i++;
    return Category(id: 1, name: subject);
  }).toList();

}