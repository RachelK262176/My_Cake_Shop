import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/cakescreen.dart';
import 'package:my_cake_shop/user.dart';
import 'package:http/http.dart' as http;

void main() => runApp(CommentScreen());

class CommentScreen extends StatefulWidget {
  final User user;
  final Cake cake;

  const CommentScreen({Key key, this.user, this.cake}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List cmdList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Comment...";
  String cakeName = "";
  int numcomment = 0;

  @override
  void initState() {
    super.initState();
    _loadComment();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              title: Text('Comment Area'),
              backgroundColor: Colors.blue[900],
            ),
            body: Column(children: [
              cmdList == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ))))
                  : Flexible(
                      child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: (screenWidth / screenHeight) / 0.2,
                      children: List.generate(cmdList.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Card(
                                child: InkWell(
                              onTap: () => _loadCakeDetails(index),
                              child: SingleChildScrollView(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: screenHeight / 6,
                                        width: screenWidth / 4,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://rachelcake.com/mycakeshop/images/cakeimages/${cmdList[index]['image']}.jpg",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(
                                            Icons.broken_image,
                                            size: screenWidth / 2,
                                          ),
                                        )),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(cmdList[index]['email'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black12)),
                                        Text(
                                          cmdList[index]['cakename'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            "Comment: " +
                                                cmdList[index]['comment'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )));
                      }),
                    )),
            ])));
  }

  void _loadComment() {
    http.post("http://rachelcake.com/mycakeshop/php/load_comment.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        cmdList = null;
        setState(() {
          titlecenter = "No Comment...";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          cmdList = jsondata["comment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadCakeDetails(int index) async {
    Cake curcake = new Cake(
        cakeid: cmdList[index]['cakeid'],
        cakename: cmdList[index]['cakename'],
        cakeprice: cmdList[index]['cakeprice'],
        quantity: cmdList[index]['quantity'],
        image: cmdList[index]['image'],
        remark: cmdList[index]['remark']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CakeScreen(
                  cake: curcake,
                  user: widget.user,
                )));
    _loadComment();
  }
}
