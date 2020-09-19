import 'package:bookie/LandingPage/sell_books.dart';
import 'package:bookie/modal/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  AuthServices auth = AuthServices();

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bookie',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                SizedBox(
                  height: 20,
                ),
                // ListTile(
                //   leading: CircleAvatar(
                //     radius: 30,
                //     backgroundColor: Colors.grey,
                //     backgroundImage: CachedNetworkImageProvider(userImage),
                //   ),
                //   title: Text(
                //     "${personalInfo.firstName} ${personalInfo.lastName}",
                //     style: TextStyle(
                //         color: Colors.white,fontSize: 18),
                //   ),
                //   subtitle: Text("${personalInfo.phoneNo}",style: TextStyle(
                //       color: Colors.white),),
                // )
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('My Account'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('Sell Books'),
            onTap: () => {Navigator.push(context,MaterialPageRoute(builder: (context)=>SellBooks()))},
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('Privacy'),
            onTap: ()  { },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () {}
          ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                _signOut();
              }),
        ],
      ),
    );
  }
}

