import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CatchExceptionPage extends StatefulWidget {
  @override
  _CatchExceptionPageState createState() => _CatchExceptionPageState();
}

class _CatchExceptionPageState extends State<CatchExceptionPage> {
  @override
  void initState() {
    super.initState();
    _asyncDemo();

  }

  _asyncDemo() async {
    Future.delayed(Duration(seconds: 1), () {
      throw 123;
    }).then((value) {
      print('value $value');
      return value;
    });
    //     .catchError(() {
    //   //todo exception handler
    // }, test: (error) => error is int);
  }

  @override
  Widget build(BuildContext context) {
    String abc;
    print('main ${abc.length}');
    return Scaffold(
        appBar: AppBar(
          title: Text('异常捕获'),
        ),
        body: Container());
  }
}
