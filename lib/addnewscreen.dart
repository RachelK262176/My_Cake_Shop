import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/user.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(AddNewScreen());

class AddNewScreen extends StatefulWidget {
  final User user;
  final Cake cake;

  const AddNewScreen({Key key, this.user, this.cake}) : super(key: key);

  @override
  _AddNewScreenState createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  final TextEditingController _cakenamecontroller = TextEditingController();
  final TextEditingController _cakepricecontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _ingredientscontroller = TextEditingController();
  final TextEditingController _stepcontroller = TextEditingController();
  final TextEditingController _ratingcontroller = TextEditingController();

  String _cakename = "";
  String _cakeprice = "";
  String _quantity = "";
  String _ingredients = "";
  String _step = "";
  String _rating = "";
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';
  //int _radioValue = 0;
  //String foodtype = "Food";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text('New Cake Recipe'),
        backgroundColor: Colors.purple[700],
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: screenHeight / 3.2,
                          width: screenWidth / 1.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    5.0) //         <--- border radius here
                                ),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("Click image to take food picture",
                        style: TextStyle(fontSize: 10.0, color: Colors.black)),
                    SizedBox(height: 5),
                    TextField(
                        controller: _cakenamecontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Cake Name',
                            icon: Icon(Icons.cake, color: Colors.cyan))),
                    TextField(
                        controller: _cakepricecontroller,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Cake Price',
                            icon: Icon(Icons.money, color: Colors.teal))),
                    TextField(
                        controller: _quantitycontroller,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Quantity Available',
                            icon: Icon(MdiIcons.numeric, color: Colors.lime))),
                    TextField(
                        controller: _ingredientscontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Ingredients',
                            icon: Icon(Icons.menu_book_rounded,
                                color: Colors.amber))),
                    TextField(
                        controller: _stepcontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: 'Step',
                            icon: Icon(Icons.format_list_numbered,
                                color: Colors.deepOrange))),
                    TextField(
                        controller: _ratingcontroller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText: 'Rating',
                            icon: Icon(Icons.star, color: Colors.pinkAccent))),
                    SizedBox(height: 15),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child:
                          Text('Add New Cake', style: TextStyle(fontSize: 18)),
                      color: Colors.deepPurple,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: newCakeDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.lime[50],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                  SizedBox(height: 15),
                  // Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // children: [
                  Flexible(
                      child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: 100,
                    height: 50,
                    child: Text('Camera',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    color: Colors.lime[100],
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () => {Navigator.pop(context), _chooseCamera()},
                  )),
                  SizedBox(height: 10),
                  Flexible(
                      child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minWidth: 100,
                    height: 50,
                    child: Text('Gallery',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    color: Colors.lime[100],
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () => {
                      Navigator.pop(context),
                      _chooseGallery(),
                    },
                  )),
                  // ],
                  // ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<void> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void newCakeDialog() {
    _cakename = _cakenamecontroller.text;
    _cakeprice = _cakepricecontroller.text;
    _quantity = _quantitycontroller.text;
    _ingredients = _ingredientscontroller.text;
    _step = _stepcontroller.text;
    _rating = _ratingcontroller.text;

    if (_cakename == "" &&
        _cakeprice == "" &&
        _quantity == "" &&
        _ingredients == "" &&
        _step == "" &&
        _rating == "") {
      Toast.show(
        "Fill all required fields",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Register new Cake? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure to add new recipe?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onAddCake();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
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

  void _onAddCake() {
    final dateTime = DateTime.now();
    _cakename = _cakenamecontroller.text;
    _cakeprice = _cakepricecontroller.text;
    _quantity = _quantitycontroller.text;
    _ingredients = _ingredientscontroller.text;
    _step = _stepcontroller.text;
    _rating = _ratingcontroller.text;

    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("http://rachelcake.com/mycakeshop/php/add_newcake.php", body: {
      "cakename": _cakename,
      "cakeprice": _cakeprice,
      "quantity": _quantity,
      "ingredients": _ingredients,
      "step": _step,
      "encoded_string": base64Image,
      "imagename": _cakename + "-${dateTime.microsecondsSinceEpoch}",
      "rating": _rating,
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
}
