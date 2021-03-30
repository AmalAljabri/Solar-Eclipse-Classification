import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final picker = ImagePicker();
  File _image;
  bool _loading = false;
  List _output;

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      // setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _loading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0d0e1f),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                //Use`Navigator` widget to push the second screen to out stack of screens
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new SecondScreen();
                }));
              })
        ],
      ),
       
      backgroundColor: Color(0xFF0d0e1f),
      body:  new SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
         
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 0),
            Text(
              '\n         Solar Eclipse',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFf4bb3a),
                  fontWeight: FontWeight.w500,
                  fontSize: 33),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: _loading
                  ? Container(
                      width: 300,
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/solar eclipse.png'),
                          SizedBox(height: 40),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                      children: <Widget>[
                        Container(
                          height: 250,
                          child: Image.file(_image),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _output != null
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text('${_output[0]['label']}',
                                    style: TextStyle(
                                        color: Color(0xFFaf2727),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500)),
                              )
                            : Container(),
                      ],
                    )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  RaisedButton.icon(
                    onPressed: pickImage,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                    label: Text(
                      'Take a Photo',
                      style: TextStyle(
                          color: Color(0xFF445d7b),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    icon: Icon(
                      Icons.camera_enhance,
                      color: Color(0xFF445d7b),
                    ),
                    splashColor: Color(0xFFed7c31),
                    color: Color(0xFFf4bb3a),
                  ),
                  SizedBox(height: 18),
                  RaisedButton.icon(
                    onPressed: pickGalleryImage,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                    label: Text(
                      'Photo Library',
                      style: TextStyle(
                          color: Color(0xFF445d7b),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    icon: Icon(
                      Icons.photo_library,
                      color: Color(0xFF445d7b),
                    ),
                    splashColor: Color(0xFFed7c31),
                    color: Color(0xFFf4bb3a),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0d0e1f),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF0d0e1f),
      body: new SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset('assets/solar eclipse.png'),
            SizedBox(height: 5),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: Text(
                'Solar Eclipses happen during a New Moon, when the Moon moves between the Earth and the Sun and the three celestial bodies form a straight line or almost a straight line: Earth - Moon - Sun. There are 3 kinds of Solar Eclipses. There is also a rare hybrid that is a combination of two eclipses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
            ),
            SizedBox(height: 0),
            new Padding(
              padding: new EdgeInsets.all(10.0),
              child: Image.asset('assets/types.jpg'),
            ),
            SizedBox(height: 5),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: Text(
                'Total Solar Eclipse',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFf4bb3a),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: Text(
                'Total Solar Eclipse occur when the Moon comes between the Sun and the Earth and casts the darkest part of its shadow (the Umbra) on Earth. The darkest point of the eclipse is almost as dark as night.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: Text(
                'Annular Solar Eclipse',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFf4bb3a),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: Text(
                'An Annular Solar eclipse happens when the Moon covers the Sun'
                's center, leaving the Sun'
                's visible outer edges to form a "ring of fire" or annulus around the Moon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: Text(
                'Partial Solar Eclipse',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFf4bb3a),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: Text(
                'Partial Solar Eclipses happen when the Moon comes between the Sun and the Earth, but they don'
                't align in a perfectly straight line. Because of this, the Moon only partially covers the Sun'
                's disc.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.all(16.0),
              child: Text(
                'Made By @amal_aljabri1',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFaf2727),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
