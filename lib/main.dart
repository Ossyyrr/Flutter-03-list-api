import 'package:flutter/material.dart';
import 'dart:math';
import 'network.dart';
import 'package:webfeed/webfeed.dart';
// import 'package:webview_flutter/webview_flutter.dart';

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
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;

          switch (settings.name) {
            case '/':
              builder =
                  (BuildContext context) => MyHomePage(title: 'Latest news');
              break;
            case '/show':
              var args = settings.arguments;
              if (args is RssItem) {
                builder = (BuildContext context) => ShowPage(
                      title: args.categories.first.value,
                      content: args.content.value,
                    );
              }
              break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}

class ShowPage extends StatefulWidget {
  final String title;
  final String content;

  const ShowPage({Key key, this.title, this.content}) : super(key: key);

  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: swatch_3.withOpacity(0.5),
          elevation: 0.0,
          centerTitle: false,
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black)),
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
        body: Container(
          child: Text(
            widget.content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 30.0,
            ),
          ),
        ));
  }

  /* Widget _body() {
    return Container();
  } */
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
  Future<RssFeed> future;

  @override
  void initState() {
    super.initState();

    future = getNews();

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
          centerTitle: false,
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
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<RssFeed> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: backgroundHeight,
                    color: swatch_3.withOpacity(0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: snapshot.data.items.length +
                            2, //noticias mas subtitulo e imagen grande
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(snapshot.data.description),
                            );
                          }
                          if (index == 1) {
                            return _bigItem();
                          }

                          return _item(snapshot.data.items[index - 2]);
                        }
                        /*  children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(snapshot.data.description),
                        ),
                        _bigItem(),
                        _item('Nombre', 'assets/galaxy.jpg'),
                        _item('Nombre', 'assets/galaxy.jpg'),
                        _item('Nombre', 'assets/galaxy.jpg'),
                        _item('Nombre', 'assets/galaxy.jpg'),
                        _item('Nombre', 'assets/galaxy.jpg'),
                      ],  */
                        ),
                  ),
                ],
              );
          }
          return null;
        });
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

  Widget _item(RssItem item) {
    var mediaUrl = _extractImage(item.content.value);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/show',
            arguments:
                item); //of busca dentro del arbol un widget de tipo navigator que ya esté insertado (acceder a widget de los padres)
      },
      child: Padding(
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
                              child: Text(item.categories.first.value[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            item.categories.first.value,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(item.title),
                    ),
                    Text(
                      item.dc.creator,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
            mediaUrl != null
                ? Container(
                    height: 150.0,
                    width: 150.0,
                    child: FadeInImage.assetNetwork(
                        placeholder: "assets/galaxy.jpg",
                        image: mediaUrl,
                        fit: BoxFit.cover))
                : SizedBox(
                    height: 150.0,
                  ),
          ],
        ),
      ),
    );
  }
}

String _extractImage(String content) {
  RegExp regExp =
      RegExp('<img[^>]+src="([^">]+)"'); // extrae imagenes desde un html

  Iterable<Match> matches =
      regExp.allMatches(content); //traigo todos los matches de ese contenido

  if (matches.length > 0) {
    // me quedo con la primera imagen que encuentro
    return matches.first.group(1);
  }
  return null;
}
