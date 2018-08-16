import 'package:flutter/material.dart';
import 'package:football_schedule/entity/match_item.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class NextItem extends StatefulWidget {
  final MatchItem match;

  const NextItem({Key key, this.match}) : super(key: key);

  @override
  _NextItemState createState() => _NextItemState(match);
}

class _NextItemState extends State<NextItem> {
  final MatchItem match;

  _NextItemState(this.match);

  String teamHomeBadge = "";
  String teamAwayBadge = "";
  String dateMatch;

  Widget homeBadge() {
    if (teamHomeBadge.isEmpty) {
      return defaultBadge();
    } else {
      return CachedNetworkImage(
        width: 50.0,
        height: 50.0,
        imageUrl: teamHomeBadge,
        placeholder: CircularProgressIndicator(),
        errorWidget: defaultBadge(),
      );
    }
  }

  Widget awayBadge() {
    if (teamAwayBadge.isEmpty) {
      return defaultBadge();
    } else {
      return CachedNetworkImage(
        width: 50.0,
        height: 50.0,
        imageUrl: teamAwayBadge,
        placeholder: CircularProgressIndicator(),
        errorWidget: defaultBadge(),
      );
    }
  }

  Widget defaultBadge() {
    return Icon(
      Icons.android,
      size: 50.0,
      color: Theme.of(context).primaryColor,
    );
  }

  Future loadAwayTeam(String id) async {
    final request = await http
        .get("https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id=$id");

    if (request.statusCode == 200) {
      List response = json.decode(request.body)['teams'];

      setState(() {
        teamAwayBadge = response[0]['strTeamBadge'];
      });
    }
  }

  Future loadHomeTeam(String id) async {
    final request = await http
        .get("https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id=$id");

    if (request.statusCode == 200) {
      List response = json.decode(request.body)['teams'];

      setState(() {
        teamHomeBadge = response[0]['strTeamBadge'];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    String homeId = match.homeTeamId;
    String awayId = match.awayTeamId;

    loadAwayTeam(awayId);
    loadHomeTeam(homeId);

    initializeDateFormatting("in_ID");
    DateFormat f = DateFormat("dd MMMM yyyy", "id");
    dateMatch = f.format(DateTime.parse(match.dateMatch));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 130.0,
        child: InkWell(
          onTap: () {
            print(match.dateMatch);
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  dateMatch,
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: new Container(
                        height: 100.0,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    homeBadge(),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(match.homeTeamName),
                                    )
                                  ],
                                ),
                                flex: 4,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: new Text(
                        'VS',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: new Container(
                      height: 100.0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  awayBadge(),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(match.awayTeamName),
                                  )
                                ],
                              ),
                              flex: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
