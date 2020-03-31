import 'package:flutter/material.dart';
import 'dart:math';

const swatch_1 = Color(0xff91a1b4);
const swatch_2 = Color(0xffe3e6f3);
const swatch_3 = Color(0xffbabdd2);
const swatch_4 = Color(0xff545c6b);
const swatch_5 = Color(0xff363cb0);
const swatch_6 = Color(0xff09090a);
const swatch_7 = Color(0xff25255b);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Latest news'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _controller;
  double backgroundHeight = 180.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      setState(() {
        backgroundHeight = max(0, 180 - _controller.offset / 1.5);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: swatch_3.withOpacity(0.5),
          elevation: 0.0,
          title: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 32.0),
              child: InkWell(
                child: Icon(Icons.share, color: swatch_1),
              ),
            )
          ],
        ),
        body: _body());
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: backgroundHeight,
          color: swatch_3.withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: ListView(
            controller: _controller,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Discover rhings of this world'),
              ),
              _bigItem(),
              _item('Nombre', 'assets/galaxy.jpg'),
              _item('Nombre', 'assets/galaxy.jpg'),
              _item('Nombre', 'assets/galaxy.jpg'),
              _item('Nombre', 'assets/galaxy.jpg'),
              _item('Nombre', 'assets/galaxy.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bigItem() {
    var screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Container(
            width: double.infinity,
            height: (screenWidth - 80) * 3 / 5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gato.jpg'),
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Icon(Icons.play_arrow, size: 40.0, color: swatch_5))
      ],
    );
  }

  Widget _item(String name, String imageName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 150.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          width: 42.0,
                          height: 42.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21.0),
                            color: swatch_5,
                          ),
                          child: Center(
                            child: Text(name[0],
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text('Titulo muy largo de al menos dos líneas'),
                  Text(
                    'subtitulo pequeño y gris',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          Container(
              height: 150.0,
              width: 150.0,
              child: Image(image: AssetImage(imageName))),
        ],
      ),
    );
  }
}
