import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/main.dart';

Future<Map<String, dynamic>> getReq(url) async {
  dynamic resp = await http.get(Uri.parse(url), headers: {
    'Content-Type': 'application/json',
    'Authorization': '$authToken',
  });
  resp.body;
  return json.decode(resp.body);
}

class GetAllEvents {
  String? name;
  String? dateTime;
  String? bookBy;
  int? ticketsSold;
  int? maxTickets;
  int? friendsAttending;
  String? price;
  bool isPartnered = false;
  String? sport;
  int? totalPrize;
  String? location;
  bool isRecommended = false;
  String? mainImage;
  int? id;
  bool isLiked = false;
  String? description;
  String? venueInformation;
  String? eventCreator;
  String? teamInformation;
  List<String> tags = [];
  GetAllEvents(
      {this.id,
      this.isLiked = false,
      this.bookBy,
      this.eventCreator,
      this.teamInformation,
      this.dateTime,
      this.friendsAttending,
      this.isPartnered = false,
      this.isRecommended = false,
      List<String>? tags,
      this.location,
      this.mainImage,
      this.maxTickets,
      this.name,
      this.price,
      this.sport,
      this.ticketsSold,
      this.description,
      this.venueInformation,
      this.totalPrize})
      : this.tags = tags ?? [];

  GetAllEvents.fromJson(Map<String, dynamic> d)
      : id = d['id'],
        name = d['name'],
        dateTime = d['dateTime'],
        bookBy = d['bookBy'],
        ticketsSold = d['ticketsSold'],
        maxTickets = d['maxTickets'],
        friendsAttending = d['friendsAttending'],
        price = (d['price']).toString(),
        isPartnered = d['isPartnered'] ?? false,
        sport = d['sport'],
        totalPrize = d['totalPrize'],
        location = d['location'],
        isRecommended = d['isRecommended'] ?? false,
        description = d['description'],
        venueInformation = d['venueInformation'],
        mainImage = d['mainImage'];

  ///get by id
  static Future<GetAllEvents> getEvent(int id) async {
    GetAllEvents event;
    String url = eventDetailEndPoint.toString() + '/${id}';
    var resp = await getReq(url);
    event = GetAllEvents.fromJson(resp['eventDetail']);
    return event;
  }

  static Future<List<GetAllEvents>> fetch() async {
    List<GetAllEvents> events = [];
    var resp = await getReq(allEventsEndPoint);
    (resp['allEvents'] as List).forEach((e) {
      events.add(GetAllEvents.fromJson(e));
    });
    print(events);
    return events;
  }
}

Future<http.Response> postData({purchaseAmount, eventId}) {
  var resp = http.post(
    Uri.parse(purchaseEndpoint),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': '$authToken',
    },
    body: jsonEncode(<String, dynamic>{
      'purchase': {
        'dateTime': DateTime.now().toString(),
        'purchaseAmount': purchaseAmount,
        'paymentMethodType': 'visa',
        'eventId': eventId,
      },
      "options": {
        "raw": {"language": "json"}
      }
    }),
  );
  print(resp);
  return resp;
}
