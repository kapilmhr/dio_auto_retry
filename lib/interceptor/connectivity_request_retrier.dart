import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

class ConnectivityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  ConnectivityRequestRetrier({required this.dio, required this.connectivity});

  Future<Response?> scheduleRerty(RequestOptions requestOptions,ErrorInterceptorHandler handler ) async {
    StreamSubscription? streamSubscription;
    final responseCompleter = Completer<Response>();
    streamSubscription = connectivity.onConnectivityChanged.listen((event) async{
      if (event != ConnectivityResult.none) {
        streamSubscription?.cancel();
        var res = await dio.request(requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
            queryParameters: requestOptions.queryParameters,
            options: Options(contentType: requestOptions.contentType));
        handler.resolve(res);
      }
    });
  }
}