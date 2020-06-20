import 'package:covid_info/logic/all_status_by_country_bloc.dart';
import 'package:covid_info/models/all_status_by_country.dart';
import 'package:covid_info/logic/country_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../logic/covid_api.dart';
import '../charts/horizontal_bar_chart.dart';
import '../charts/time_series_chart.dart';
import '../charts/stacked_area_line_chart.dart';

class DetailsPage extends StatefulWidget {
  final MaterialColor red;
  final String currentCountry;
  final AllStatusByCountryBloc allStatusByCountryBloc;
  final CountryBloc countryBloc;

  const DetailsPage(
      {Key key,
      this.red,
      this.currentCountry,
      this.allStatusByCountryBloc,
      this.countryBloc})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _selectedIndex = 0;
  Future<AllStatusByCountry> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchAllStatusByCountry(widget.allStatusByCountryBloc,
        widget.countryBloc, widget.currentCountry.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.currentCountry)),
      ),
      body: FutureBuilder<AllStatusByCountry>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final subtitle = <Widget>[
              Text("Interactable",
                  style: TextStyle(color: Colors.grey[700], fontSize: 18.0)),
            ];
            final children = <Widget>[
              Center(
                child:
                    Text("Deaths Timeline", style: TextStyle(fontSize: 24.0)),
              ),
            ];
            if (!snapshot.data.fresh) {
              subtitle.add(
                Text(" - (Out of date)",
                    style: TextStyle(color: Colors.red[700], fontSize: 18.0)),
              );
              children.add(
                Center(
                  child: Text("(Out of date)",
                      style: TextStyle(color: Colors.red[700], fontSize: 18.0)),
                ),
              );
            }
            List _tabOptions = <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: children,
                    ),
                    Expanded(
                      child: HorizontalBarChart.fromScratch(
                          snapshot.data.deathsTimeline),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                          child: Text("Active Cases Timeline",
                              style: TextStyle(fontSize: 24.0)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: subtitle,
                        ),
                      ],
                    ),
                    Expanded(
                      child: TimeSeriesChart.fromScratch(
                          snapshot.data.activeCasesTimeline),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                          child: Text("Cases Status Timeline",
                              style: TextStyle(fontSize: 24.0)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: subtitle,
                        ),
                      ],
                    ),
                    Expanded(
                      child: StackedAreaLineChart.fromScratch(snapshot.data),
                    )
                  ],
                ),
              )
            ];
            return _tabOptions.elementAt(_selectedIndex);
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            title: Text('Deaths'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text('Active Cases'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartArea),
            title: Text('Cases Status'),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blueGrey[800],
        selectedItemColor: widget.red,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.orange[100],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
