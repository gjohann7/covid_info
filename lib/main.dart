import 'package:covid_info/logic/all_status_by_country_bloc.dart';
import 'package:covid_info/logic/country_bloc.dart';
import 'package:flutter/material.dart';
import './pages/home_page.dart';
import './pages/dashboard_page.dart';
import './pages/details_page.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19 INFO',
      theme: ThemeData(
        primarySwatch: red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  String selectedCountry = "";
  List _tabOptions;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress = "";
  AllStatusByCountryBloc allStatusByCountryBloc;
  CountryBloc countryBloc;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    countryBloc = CountryBloc();
    allStatusByCountryBloc = AllStatusByCountryBloc();
  }

  @override
  Widget build(BuildContext context) {
    _tabOptions = _getTabOptions();
    return Scaffold(
      appBar: AppBar(
        title: const Text('COVID-19 INFO'),
      ),
      body: _tabOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            title: Text('Details'),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blueGrey[800],
        selectedItemColor: red,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),
    );
  }

  _getTabOptions() {
    return [
      HomePage(),
      DashboardPage(),
      DetailsPage(
        red: red,
        currentCountry: _currentAddress,
        countryBloc: countryBloc,
        allStatusByCountryBloc: allStatusByCountryBloc,
      )
    ];
  }

  _onItemTapped(int index) async {
    if (_currentAddress != "") {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      _getCurrentLocation();
      _tabOptions = _getTabOptions();
    }
  }

  _getCurrentLocation() async {
    bool isGeolocationAvailable = await Geolocator().isLocationServiceEnabled();

    if (!isGeolocationAvailable) {
      _getAddressFromLatLng(off: true);
    } else {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
        _getAddressFromLatLng(off: false);
      }).catchError((e) {
        print(e);
      });
    }
  }

  _getAddressFromLatLng({bool off}) async {
    if (off) {
      setState(() {
        _currentAddress = "Portugal";
      });
    } else {
      try {
        List<Placemark> p = await geolocator.placemarkFromCoordinates(
            _currentPosition.latitude, _currentPosition.longitude);
        Placemark place = p[0];
        setState(() {
          _currentAddress = place.country;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    allStatusByCountryBloc.dispose();
    countryBloc.dispose();
    super.dispose();
  }
}

const MaterialColor red = MaterialColor(
  0xFF922B21,
  <int, Color>{
    50: Color(0xFF922B21),
    100: Color(0xFF922B21),
    200: Color(0xFF922B21),
    300: Color(0xFF922B21),
    400: Color(0xFF922B21),
    500: Color(0xFF922B21),
    600: Color(0xFF922B21),
    700: Color(0xFF922B21),
    800: Color(0xFF922B21),
    900: Color(0xFF922B21),
  },
);
