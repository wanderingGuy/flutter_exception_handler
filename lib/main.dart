import 'package:flutter/material.dart';
import 'package:flutter_exception_handler/catch_exception_example.dart';
import 'package:flutter_exception_handler/exception_alert.dart';

GlobalKey globalKey = GlobalKey();

void main() {
  ErrorWidget.builder = (FlutterErrorDetails detail) {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Text(
              'error\n--------\n ${detail.exception}',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'stacktrace\n--------\n ${detail.stack}',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          ]),
        ));
  };

  runExceptionAlertApp(
    () {
      runApp(MyApp());
    },
    isUploadException: true,
    homeKey: globalKey,
    exceptionUploader: _handleError,
  );
}

void _handleError(Object obj, StackTrace stack) {
  print('zone _handleError $obj stack $stack');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter xception Handler Demonstration'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('异常捕获'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CatchExceptionPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
