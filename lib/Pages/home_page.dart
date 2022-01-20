import 'package:bookmyspace/Services/auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthProvider _auth = AuthProvider();
  late List<String> user = [];
  @override
  initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getStringList('user')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Book My Space"),
          backgroundColor: const Color(0xff001830),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(50)))),
      body: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          height: 50,
          color: const Color(0xff001830),
          buttonBackgroundColor: Colors.blue,
          index: 2,
          items: const <Widget>[
            Icon(
              Icons.home,
              semanticLabel: "Home",
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.add_location,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.search,
              size: 25,
              color: Colors.white,
            ),
            Icon(
              Icons.settings,
              size: 25,
              color: Colors.white,
            ),
          ],
          onTap: (index) {
            //Handle button tap
          },
        ),
        body: Container(color: Colors.white),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.white,
                          image: DecorationImage(
                              alignment: Alignment.center,
                              image: NetworkImage(
                                user.isEmpty ? "" : user[1],
                              ))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      user.isEmpty ? "" : user[0],
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                )),
            Column(children: getDrawerItems()),
          ],
        ),
      ),
    );
  }

  List<Widget> getDrawerItems() {
    List<DrawerItems> items = [
      DrawerItems("My bookings", Icons.location_city, 0),
      DrawerItems("Nearby restaurant", Icons.location_searching, 1),
      DrawerItems("Locate", Icons.location_on, 2),
      DrawerItems("Help me", Icons.help, 3),
      DrawerItems("About us", Icons.contacts, 4),
      DrawerItems("Sign out", Icons.logout, 5),
    ];
    List<Padding> display = [];
    for (var element in items) {
      display.add(Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            child: Row(
              children: [
                Icon(
                  element.icon,
                  size: 30,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  element.name,
                  style: const TextStyle(),
                )
              ],
            ),
            onTap: () {
              if (element.index == 5) {
                _auth.signOut();
                Navigator.pushNamed(context, '/login');
              }
            },
          )));
    }
    return display;
  }
}

class DrawerItems {
  DrawerItems(this.name, this.icon, this.index);
  late String name;
  late IconData icon;
  late int index;
}
