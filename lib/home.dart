import 'package:flutter/material.dart';
import 'package:football_schedule/next/next_match.dart';
import 'package:football_schedule/previous/previous_match.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _pageState = 0;
  var _appBarTitle = 'Previous Match';

  void updatePage(int page , String title){
    setState(() {
      _pageState = page;
      _appBarTitle = title;
    });
  }

  Widget body(){
    switch(_pageState){
      case 0: return PreviousMatch();
      case 1: return NextMatch();
      default: return PreviousMatch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: body(),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: DrawerHeader(
                child: Center(
                    child: Text(
                        'Hi',
                      style: TextStyle(fontSize: 24.0, color: Colors.white),
                    )
                ),
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pop();
                updatePage(0 , 'Previous Match');
              },
              leading: Icon(Icons.today),
              title: Text('Previous Match'),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pop();
                updatePage(1 , 'Next Match');
              },
              leading: Icon(Icons.access_alarms),
              title: Text('Next Match'),
            )
          ],
        )
      ),
    );
  }
}
