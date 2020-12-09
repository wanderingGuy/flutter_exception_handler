## flutter_exception_handler

A new Flutter application for illustrating exception handler

### 全局异常弹窗

提供的 API 支持

```
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
})
```
### 项目中使用

```
void main() {
  runExceptionAlertApp(
    () {
      runApp(MyApp());
    },
    homeKey: globalKey,
    exceptionUploader: _handleError,
  );
}

///自定义的异常处理，比如上报到服务器
void _handleError(Object obj, StackTrace stack) {
  print('zone _handleError $obj stack $stack');
}
```

