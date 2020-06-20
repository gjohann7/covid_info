import 'package:covid_info/logic/global_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/global.dart';
import '../logic/covid_api.dart';
import '../charts/pie_chart.dart';
import '../charts/bar_chart.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  GlobalBloc globalBloc;
  Future<Global> futureGlobal;

  @override
  void initState() {
    super.initState();
    globalBloc = GlobalBloc();
    futureGlobal = fetchGlobal(globalBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Global Summary')),
      ),
      backgroundColor: Colors.blue[50],
      body: FutureBuilder<Global>(
        future: futureGlobal,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final children = <Widget>[];
            final staggeredTiles = <StaggeredTile>[];
            if (!snapshot.data.fresh) {
              children.add(outOfDateView());
              staggeredTiles.add(StaggeredTile.extent(2, 35));
            }
            children.addAll(<Widget>[
              horizontalView(snapshot.data.confirmedCases),
              pieChartView(snapshot.data.lethality),
              verticalView(snapshot.data.recoveredCases),
              horizontalView(snapshot.data.deathsCases),
              barChartView(snapshot.data.worldTotal)
            ]);
            staggeredTiles.addAll(<StaggeredTile>[
              StaggeredTile.extent(2, 120.0),
              StaggeredTile.extent(1, 230.0),
              StaggeredTile.extent(1, 230.0),
              StaggeredTile.extent(2, 120.0),
              StaggeredTile.extent(2, 320.0),
            ]);

            return StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: children,
              staggeredTiles: staggeredTiles,
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sorry, something",
                  style: TextStyle(fontSize: 35),
                ),
                Text(
                  "went wrong",
                  style: TextStyle(fontSize: 35),
                ),
                Icon(
                  Icons.bug_report,
                  size: 60,
                  color: Colors.red[900],
                )
              ],
            ));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Material outOfDateView() {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196f3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Out of date",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900]),
              ))),
    );
  }

  Material horizontalView(category) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196f3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(category['title'],
                            style: TextStyle(
                              fontSize: 23.0,
                              color: Colors.grey[900],
                            ))
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: category['color'],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  category['total'],
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: category['color'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "New",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: category['color'],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  category['new'],
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: category['color'],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ]))),
    );
  }

  Material verticalView(category) {
    return Material(
        color: Colors.white,
        elevation: 14.0,
        shadowColor: Color(0x802196f3),
        borderRadius: BorderRadius.circular(24.0),
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13.0),
                              child: Text(category['title'],
                                  style: TextStyle(
                                    fontSize: 23.0,
                                    color: Colors.grey[900],
                                  )),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 13.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "Total",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: category['color'],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        category['total'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: category['color'],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 13.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "New",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: category['color'],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        category['new'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: category['color'],
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ])
                    ]))));
  }

  Material pieChartView(category) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    category['title'],
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.deepOrangeAccent[700],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 8.0),
                  child: Text(
                    category['subtitle'],
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child:
                      PieChart.fromScratch(category['title'], category['data']),
                )
              ],
            )),
      ),
    );
  }

  Material barChartView(category) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 13.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    category['title'],
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                Expanded(
                  child:
                      BarChart.fromScratch(category['title'], category['data']),
                )
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    globalBloc.dispose();
    super.dispose();
  }
}
