import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/cakeorderscreen.dart';
import 'package:my_cake_shop/shoppingcartscreen.dart';
import 'package:my_cake_shop/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(CakeScreen());

class CakeScreen extends StatefulWidget {
  final Cake cake;
  final User user;

  const CakeScreen({Key key, this.cake, this.user}) : super(key: key);

  @override
  _CakeScreenState createState() => _CakeScreenState();
}

class _CakeScreenState extends State<CakeScreen> {
  double screenHeight, screenWidth;
  String titlecenter = "Loading Recipe...";
  List cakeList;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  Widget build(BuildContext context) {
    //   var quantity =
    //       Iterable<int>.generate(int.parse(widget.cake.quantity) + 1).toList();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[700],
        title: Text(widget.cake.cakename),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white, size: 35),
            onPressed: () {
              _shoppinCartScreen();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _order();
        },
        icon: Icon(Icons.shopping_bag_rounded, color: Colors.white),
        label: Text("Buy Now",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                fontSize: 14)),
        backgroundColor: Colors.amber,
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 5, color: Colors.black12),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8)),
                      ),
                      margin: const EdgeInsets.all(1),
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
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(widget.cake.cakename,
                        style: TextStyle(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            color: Colors.blueAccent)),
                    SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 5, color: Colors.black12),
                          borderRadius:
                              const BorderRadius.all(const Radius.circular(8)),
                        ),
                        margin: const EdgeInsets.all(1),
                        child: Column(children: [
                          Text('Ingredients: ', // + widget.cake.ingredients
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(widget.cake.ingredients,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ])),
                    SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 5, color: Colors.black12),
                          borderRadius:
                              const BorderRadius.all(const Radius.circular(8)),
                        ),
                        margin: const EdgeInsets.all(1),
                        child: Column(children: [
                          Text('Step: ',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(widget.cake.step,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ])),
                    SizedBox(height: 10),
                    Icon(Icons.star, color: Colors.redAccent),
                    Text(
                      'Rating: ' + widget.cake.rating,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Icon(Icons.star, color: Colors.redAccent),
                  ])))),
      backgroundColor: Colors.cyan[50],
    );
  }

  void _shoppinCartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ShoppingCartScreen(
                  user: widget.user,
                )));
  }

  void _order() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CakeOrderScreen(
                  cake: widget.cake,
                  user: widget.user,
                )));
  }
}
