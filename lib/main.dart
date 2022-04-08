import 'package:flutter/material.dart';
import 'package:project/pages/home_scren.dart';
import 'package:project/pages/splash_screen.dart';

String authToken = "Bearer 786785e9-1b74-430a-80d9-aae49678954f";
String allEventsEndPoint = 'https://api.sheety.co/bdcbafbc1f4197dda178b9e69f6ccee9/techAlchemyDeveloperTest1/allEvents';
String eventDetailEndPoint =
    'https://api.sheety.co/bdcbafbc1f4197dda178b9e69f6ccee9/techAlchemyDeveloperTest1/eventDetails';
String checkOutEndPoint = 'https://api.sheety.co/bdcbafbc1f4197dda178b9e69f6ccee9/techAlchemyDeveloperTest1/checkout';
String purchaseEndpoint = 'https://api.sheety.co/bdcbafbc1f4197dda178b9e69f6ccee9/techAlchemyDeveloperTest1/purchase';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(color: primaryColor, debugShowCheckedModeBanner: false, title: "project", home: SplashScreen()));
}
