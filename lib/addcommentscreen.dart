import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/reviewcommentscreen.dart';
import 'package:my_cake_shop/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(AddCommentScreen());

class AddCommentScreen extends StatefulWidget {
  final Cake cake;
  final User user;

  const AddCommentScreen({Key key, this.cake, this.user}) : super(key: key);

  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  List cmdList;
  int numcomment = 0;
  double screenHeight, screenWidth;
  String titlecenter = "Nothing...";
  final TextEditingController _commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_loadComment();
    //_commentcontroller.text = widget.cake.comment;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          title: Text("Comment Screen"),
          backgroundColor: Colors.lightBlue[900],
          actions: <Widget>[
            Flexible(
              child: IconButton(
                icon: Icon(Icons.comment_bank, color: Colors.white, size: 35),
                onPressed: () {
                  _reviewCommentScreen();
                },
              ),
            ),
          ],
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: screenHeight / 2.0,
                          width: screenWidth / 0.1,
                          child: CachedNetworkImage(
                            imageUrl:
                                "http://rachelcake.com/mycakeshop/images/cakeimages/${widget.cake.image}.jpg",
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.broken_image,
                              size: screenWidth / 2,
                            ),
                          )),
                      SizedBox(height: 20),
                      Text("Name: ",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text(widget.cake.cakename,
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue[900])),
                      SizedBox(height: 20),
                      Row(children: [
                        Text("Any comment about this recepi? ",
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ]),
                      TextField(
                        style: TextStyle(fontSize: 20),
                        controller: _commentcontroller,
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: 'Your Comment',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: Icon(Icons.notes)),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add Comment',
                            style: TextStyle(fontSize: (18))),
                        color: Colors.lightBlue[500],
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _confirmDialog,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ))));
  }

  void _addComment() {
    http.post("http://rachelcake.com/mycakeshop/php/insert_comment.php", body: {
      "email": widget.user.email,
      "name": widget.user.name,
      "cakename": widget.cake.cakename,
      "comment": _commentcontroller.text,
      "image": widget.cake.image,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
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

  void _confirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Confirmation Dialog",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Please make sure that your comment does not involve any insulting words or words that make others uncomfortable. Thank you",
            style: TextStyle(color: Colors.blue[900], fontSize: 18),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addComment();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _reviewCommentScreen() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ReviewCommentScreen(
                  user: widget.user,
                  cake: widget.cake,
                )));
  }
}
