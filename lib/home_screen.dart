import 'package:auto_retry/interceptor/connectivity_request_retrier.dart';
import 'package:auto_retry/interceptor/retry_interceptor.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  String mainResponse = "";
  late Dio dio;

  @override
  void initState() {
    dio = Dio();
    dio.interceptors.add(RetryInterceptor(requestRetrier: ConnectivityRequestRetrier(
      dio: dio,
      connectivity: Connectivity()
    )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auto Retry"),),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? CircularProgressIndicator()
                  : Text(mainResponse),
              MaterialButton(
                color: Colors.green,
                child: Text("Retry",style: TextStyle(color: Colors.white),),
                onPressed: () {
                  apiCall();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void apiCall() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await dio.get('https://services.hanselandpetal.com/feeds/flowers.json');
      mainResponse = response.data[0]['name'] as String;
      print(response);
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }
}
