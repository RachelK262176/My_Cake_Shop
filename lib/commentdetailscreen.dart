import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/comment.dart';
import 'package:my_cake_shop/smallcomment.dart';
import 'package:my_cake_shop/user.dart';
import 'package:toast/toast.dart';

void main() => runApp(CommentDetailScreen());

class CommentDetailScreen extends StatefulWidget {
  final User user;
  final Comment comment;
  final Cake cake;
  final SmallCmt smallcomment;

  const CommentDetailScreen(
      {Key key, this.user, this.comment, this.cake, this.smallcomment})
      : super(key: key);

  @override
  _CommentDetailScreenState createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends State<CommentDetailScreen> {
  Comment comment;
  User user;
  double screenHeight, screenWidth;
  List smallcmtList;
  List cmdList;
  String titlecenter = "Loading post...";
  final TextEditingController _smallcmtcontroller = TextEditingController();
  //String _smallcmt = "";

  @override
  void initState() {
    super.initState();
    comment = widget.comment;
    user = widget.user;
    _loadSmallComment();
    //_loadbigComment();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.cyan[50],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text(widget.comment.cakename),
            backgroundColor: Colors.cyan[400],
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  _loadSmallComment();
                },
              ),
            ]),
        body: Column(children: [
          Container(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        Text("Post by: " + widget.comment.name,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.indigo[900],
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 5, color: Colors.white),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(8)),
                          ),
                          margin: const EdgeInsets.all(1),
                          height: screenHeight / 3.0,
                          width: screenWidth / 0.1,
                          child: CachedNetworkImage(
                            imageUrl:
                                "http://rachelcake.com/mycakeshop/images/cakeimages/${widget.comment.image}.jpg",
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.broken_image,
                              size: screenWidth / 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(widget.comment.comment,
                            style: TextStyle(
                                fontSize: 24,
                                //fontStyle: FontStyle.italic,
                                color: Colors.black)),
                        SizedBox(height: 5),
                        Divider(
                            height: 2,
                            color: Colors.grey), // line seperate the comment
                      ])))),
          Expanded(
            child: SingleChildScrollView(
              child: smallcmtList == null
                  ? Container(
                      child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("No any comment",
                                style: TextStyle(color: Colors.grey)),
                          )))
                  : Container(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: smallcmtList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(smallcmtList[index]['name'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.blueGrey)),
                                        Text(
                                            " (" +
                                                smallcmtList[index]
                                                    ['smallcmtdate'] +
                                                " )",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(smallcmtList[index]['smallcmt'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Divider(height: 2, color: Colors.grey),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                );
                              }))),
            ),
          ),
          TextField(
              controller: _smallcmtcontroller,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  labelText: "Comment",
                  icon: new Icon(Icons.comment_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _updatenewsmallcmt();
                    },
                    icon: Icon(Icons.send),
                  ))),
          SizedBox(height: 5),
        ]));
  }

  void _updatenewsmallcmt() {
    http.post("http://rachelcake.com/mycakeshop/php/insert_smallcomment.php",
        body: {
          "commentid": comment.comment,
          "email": user.email,
          "name": user.name,
          "smallcmt": _smallcmtcontroller.text,
        }).then((res) {
      print(res.body);

      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadSmallComment() {
    http.post("http://rachelcake.com/mycakeshop/php/load_smallcomment.php",
        body: {
          "commentid": widget.comment
              .comment, //send the postid to load_comments.php to get data
        }).then((res) {
      print(res.body);

      if (res.body == "nodata") {
        smallcmtList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          smallcmtList = jsondata["smallcmt"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
