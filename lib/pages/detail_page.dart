import 'package:flutter/material.dart';
import 'package:project/base_class.dart';
import 'package:project/pages/home_scren.dart';

class DetailPage extends StatefulWidget {
  final int? id;
  const DetailPage({this.id, Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late GetAllEvents event;
  bool isLoading = true;

  @override
  void initState() {
    getDetail(widget.id!);
    super.initState();
  }

  getDetail(int id) async {
    event = await GetAllEvents.getEvent(id);
    print(event);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
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
                  padding: EdgeInsets.only(bottom: 20),
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    //   borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(image: NetworkImage(event.mainImage ?? ''), fit: BoxFit.fill),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40, left: 10),
                        color: Colors.grey.withOpacity(0.2),
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(event.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Total prize :'),
                              Text(
                                event.totalPrize == 0 ? "Free" : '₹' + event.totalPrize.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey.withOpacity(0.7),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Text(
                                  "Share Event",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 30),
                              event.isLiked
                                  ? InkWell(
                                      onTap: () {
                                        event.isLiked = !event.isLiked;
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.redAccent,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        event.isLiked = !event.isLiked;
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.favorite_border_outlined,
                                      ),
                                    )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '🎟️ ' + event.ticketsSold.toString() + '/' + event.maxTickets.toString() + " attending",
                        style: TextStyle(color: Colors.purple),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'ABOUT:',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 10),
                      Text(
                        event.description ?? '',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, height: 1.2),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: InkWell(
                          onTap: () async {
                            try {
                              postData(purchaseAmount: event.price, eventId: event.id);
                              var resp = await showModalBottomSheet(
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return getPopUp();
                                  });
                              if (resp != true) Navigator.pop(context, MaterialPageRoute(builder: (context) => Home()));
                            } catch (e) {
                              SnackBar(content: Text('$e'));
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                            decoration:
                                BoxDecoration(color: Color(0xFF02D9E7), borderRadius: BorderRadius.circular(50)),
                            child: Center(
                                child: Text(
                              "${event.price} - I'M IN!",
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget getPopUp() {
    return DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.8,
        minChildSize: 0.8,
        builder: (context, ScrollController) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Purchase Sucess",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Color(0xFF11D0A2)),
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Thank You!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                Text(
                  "Your Payment waas made sucessfully!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Text(
                  "Your booking Id",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "#12345666",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Color(0xFF02D9E7)),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Text(
                  "You will need this booking ID to enter inside the event. You can view this code inside your profile / booked events",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, height: 1.5),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                    onTap: () {
                      try {
                        Navigator.pop(context, MaterialPageRoute(builder: (context) => Home()));
                      } catch (e) {
                        SnackBar(content: Text('$e'));
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                      decoration: BoxDecoration(color: Color(0xFF936EFE), borderRadius: BorderRadius.circular(50)),
                      child: Center(
                          child: Text(
                        "CLOSE",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      )),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
