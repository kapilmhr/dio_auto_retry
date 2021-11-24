import 'dart:io';

import 'package:auto_retry/interceptor/connectivity_request_retrier.dart';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor{
  ConnectivityRequestRetrier requestRetrier;

  RetryInterceptor({required this.requestRetrier});


  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async{
    requestRetrier.scheduleRerty(err.requestOptions,handler);

    if(_shouldRetry(err)){
      print("RETRY");
      try{
        // handler.next(err);
        requestRetrier.scheduleRerty(err.requestOptions,handler);
        // handler.resolve(response!);
      }
      catch(e){
         print(e);
      }
    }
  }

  bool _shouldRetry(DioError dioError){
    return dioError.error == DioErrorType.other &&
    dioError.error != null &&
    dioError.error is SocketException;
  }
}