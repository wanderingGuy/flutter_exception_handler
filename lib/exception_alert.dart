import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exception_handler/main.dart';

typedef ExceptionUploader = void Function(Object error, StackTrace stackTrace);

/// 全局异常弹窗
///
/// [callback] 中传入原有的调用[runApp]的相关逻辑
/// [showExceptionAlert] 用于在异常时弹出提示对话框，debug 模式默认开启，若要使用该功能，还必须传入[homeKey]。
/// [isUploadException] 是否上报自定义异常，设置为true后，发生异常会回调 [exceptionUploader] ，默认为true。
/// [homeKey] 设置一个key，用于弹窗寻找根路由，通常取 homePage 设置的 key 即可。
/// [exceptionUploader] 自定义处理异常的上报
void runExceptionAlertApp(
  VoidCallback callback, {
  bool showExceptionAlert = true,
  bool isUploadException = true,
  GlobalKey homeKey,
  ExceptionUploader exceptionUploader,
}) {
  if (showExceptionAlert) {
    assert(() {
      if (homeKey == null)
        print('homeKey cannot be null, if open showExceptionDialog function');
      return homeKey != null;
    }());
  }

  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  final Map zoneValues = {
    #showExceptionDialog: showExceptionAlert,
    #isUploadException: isUploadException,
    #homeKey: homeKey,
    #exceptionUploader: exceptionUploader,
  };

  print('main runZonedddd ${Zone.current.hashCode}');

  runZoned(() {
    print('outer runZonedddd ${Zone.current.hashCode} parent ${Zone.current.parent.hashCode}');
    WidgetsFlutterBinding.ensureInitialized();
    // 上层回调
    callback();
  }, onError: (exception, stackTrace) {
    print('onError runZonedddd current ${Zone.current.hashCode}');
    _handleError(exception, stackTrace, zoneValues);
  });
}

/// 异常处理
void _handleError(Object error, StackTrace stack, Map zoneValues) {
  runZoned(() {
    print('inner runZonedddd ${Zone.current.hashCode} parent ${Zone.current.parent.hashCode}');
    // debug下展示异常对话框
    if (Zone.current[#showExceptionDialog]) {
      _showExceptionAlertDialog(error, stack);
    }
    String stackStr = "runExceptionAlertApp print uncaughtException\n\n$error\n$stack";
    if (stackStr != null) {
      debugPrint(stackStr);
    }
    _uploadException(error, stack);
  }, zoneValues: zoneValues);
}

/// 展示异常警告窗口
void _showExceptionAlertDialog(Object error, StackTrace stack) {
  print('_showExceptionAlertDialog');
  assert(() {
    // GlobalKey key = Zone.current[#homeKey];
    GlobalKey key = globalKey;
    print('_showExceptionAlertDialog key $key');

    if (key == null || key.currentContext == null) {
      return true;
    }
    print('_showExceptionAlertDialog');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: key.currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 80),
              child: SingleChildScrollView(
                child: Text(
                  '$error',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 420),
              child: SingleChildScrollView(
                child: Text("$stack"),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text('我知道了'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text("复制下来"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: stack.toString()));
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    });
    return true;
  }());
}

/// 上报异常
void _uploadException(Object obj, StackTrace stack) {
  if (Zone.current[#isUploadException]) {
    ExceptionUploader uploader = Zone.current[#exceptionUploader];
    if (uploader != null) {
      uploader(obj, stack);
    }
  }
}
