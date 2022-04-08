import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:project/base_class.dart';
import 'package:project/pages/detail_page.dart';

Color primaryColor = Color(0xFF7555CF);
Color primaryBlue = Color(0xFF02D9E7);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget> _children = [
    DataPage(),
    Demo(Colors.deepOrange),
    Demo(Colors.green),
    Demo(Colors.green),
    Demo(Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            padding: EdgeInsets.only(left: 20, top: 20),
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Welcome',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                selectedItemColor: primaryColor,
                unselectedItemColor: Colors.grey,
                onTap: onTabTapped,
                currentIndex: _currentIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        // color: Colors.grey,
                      ),
                      title: Text('')),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.confirmation_number_outlined,
                        //  color: Colors.grey,
                      ),
                      title: Text('')),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.games_outlined,
                        //  color: Colors.grey,
                      ),
                      title: Text('')),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.account_circle_outlined,
                        //  color: Colors.grey,
                      ),
                      title: Text('')),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.settings,
                        //  color: Colors.grey,
                      ),
                      title: Text('')),
                ],
              ),
            )));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Demo extends StatefulWidget {
  final Color color;
  const Demo(this.color, {Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Recommended Events"),
            Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('lib/assets/image/splash.png'), fit: BoxFit.fitWidth),
                ))
          ],
        ),
      ),
    );
  }
}

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  int imageIndex = 0;
  bool isEventLoading = true;

  List<GetAllEvents> events = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    events = await GetAllEvents.fetch();
    isEventLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: isEventLoading
            ? Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Colors.grey,
                    // this is inherited from accentColor: in themedata
                    // valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey.withOpacity(0.2),
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("Recommended Events", style: TextStyle(color: Colors.grey)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: CarouselSlider(
                          options: CarouselOptions(
                            onPageChanged: (i, r) {
                              setState(() {
                                imageIndex = i;
                              });
                            },
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                          ),
                          items: events
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => DetailPage(id: e.id)));
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height / 3.7,
                                    width: MediaQuery.of(context).size.width / 1.2,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(30),
                                      image: DecorationImage(image: NetworkImage(e.mainImage ?? ''), fit: BoxFit.fill),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.watch_later_outlined, color: Colors.white),
                                              SizedBox(width: 5),
                                              Text(e.dateTime ?? "",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Text(e.name ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: Colors.black,
                                                  border: Border.all(color: Colors.white),
                                                ),
                                                child: Text(
                                                  '🎟️ ' + e.ticketsSold.toString() + '/' + e.maxTickets.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: Colors.black,
                                                  border: Border.all(color: Colors.white),
                                                ),
                                                child: Text(
                                                  e.friendsAttending == 0
                                                      ? "No Friends"
                                                      : "👨‍👧‍👦 +" + e.friendsAttending.toString() + "Friends",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: Colors.lightBlueAccent,
                                                  border: Border.all(color: Colors.white),
                                                ),
                                                child: Text(
                                                  e.price == '0' ? "Free" : "₹" + e.price.toString(),
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 20,
                          child: Center(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: events.length,
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  return Icon(
                                    i == imageIndex ? Icons.circle : Icons.circle_outlined,
                                    size: 6,
                                  );
                                }),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("All events"),
                        SizedBox(height: 10),
                        ListView.builder(
                            itemCount: events.length,
                            shrinkWrap: true,
                            controller: ScrollController(),
                            itemBuilder: (context, i) {
                              var e = events[i];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => DetailPage(id: e.id)));
                                },
                                child: Column(children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height / 4,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                      ),
                                      image:
                                          DecorationImage(image: NetworkImage(e.mainImage ?? ''), fit: BoxFit.fitWidth),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.only(left: 20, right: 0, top: 20, bottom: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              if (e.isPartnered)
                                                Container(
                                                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: Colors.lightBlueAccent,
                                                    border: Border.all(color: Colors.white),
                                                  ),
                                                  child: Text(
                                                    "Patners",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              if (e.isPartnered) SizedBox(width: 5),
                                              Container(
                                                padding: EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.white),
                                                ),
                                                child: Text(
                                                  e.sport ?? '',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Text(e.name ?? "",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.watch_later_outlined, color: Colors.white),
                                                  SizedBox(width: 5),
                                                  Text(e.dateTime ?? '',
                                                      style:
                                                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 8, right: 0, bottom: 5, top: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(30.0),
                                                    bottomLeft: Radius.circular(30.0),
                                                  ),
                                                  color: Colors.lightBlueAccent,
                                                  // border: Border.all(color: Colors.white),
                                                ),
                                                child: Text(
                                                  e.price == '0' ? "Free " : "₹ " + e.price.toString() + "  ",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Total prize :'),
                                              Text(e.totalPrize == 0 ? "Free" : '₹' + e.totalPrize.toString()),
                                            ],
                                          ),
                                          e.isLiked
                                              ? InkWell(
                                                  onTap: () {
                                                    e.isLiked = !e.isLiked;
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.redAccent,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    e.isLiked = !e.isLiked;
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.favorite_border_outlined,
                                                  ),
                                                )
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Icon(Icons.speed, color: Colors.grey),
                                          SizedBox(width: 5),
                                          Text(
                                            'Event Creator:',
                                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 5),
                                          Text('steve Jobs'),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Divider()
                                    ],
                                  )
                                ]),
                              );
                            }),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
