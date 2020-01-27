import 'package:flutter/material.dart';
import 'package:personal_dictionary/UI/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Dictionary',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            bottomNavigationBar: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            body: TabBarView(
              children: [
                HomeScreen(),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            ),
          ),
        ));
  }
}
