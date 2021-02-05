import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/comment.dart';
import 'package:my_cake_shop/commentdetailscreen.dart';
import 'package:my_cake_shop/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(ReviewCommentScreen());

class ReviewCommentScreen extends StatefulWidget {
  final User user;
  final Cake cake;
  final Comment comment;

  const ReviewCommentScreen({Key key, this.user, this.cake, this.comment})
      : super(key: key);

  @override
  _ReviewCommentScreenState createState() => _ReviewCommentScreenState();
}

class _ReviewCommentScreenState extends State<ReviewCommentScreen> {
  List cmdList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Comment...";
  String cakeName = "";

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
            backgroundColor: Colors.indigo[100],
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
                      childAspectRatio: (screenWidth / screenHeight) / 0.45,
                      children: List.generate(cmdList.length, (index) {
                        return Padding(
                            padding: EdgeInsets.all(1),
                            child: Card(
                                child: InkWell(
                              onTap: () => _loadCommentDetails(index),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 3),
                                    Text("Post by: " + cmdList[index]['name'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.indigo[900],
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Container(
                                        height: screenHeight / 3.5,
                                        width: screenWidth / 1.0,
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
                                        SizedBox(height: 5),
                                        Text(
                                          //"Cake name: " +
                                          cmdList[index]['cakename'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
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
          titlecenter = "No Comment Found.";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          cmdList = jsondata["cmd"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadCommentDetails(int index) async {
    Comment curcomment = new Comment(
        commentid: cmdList[index]['commentid'],
        email: cmdList[index]['email'],
        cakename: cmdList[index]['cakename'],
        name: cmdList[index]['name'],
        comment: cmdList[index]['comment'],
        image: cmdList[index]['image'],
        commentdate: cmdList[index]['commentdate']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CommentDetailScreen(
                  cake: widget.cake,
                  comment: curcomment,
                  user: widget.user,
                )));
    _loadComment();
  }
}
