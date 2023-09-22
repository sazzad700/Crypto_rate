import 'dart:convert';

import 'package:http/http.dart' as http;

const apikey='********';
class networkhelper{

  String? value;
  String? coin;

  networkhelper({this.value,this.coin});


   Future<dynamic> getdata() async{

    http.Response response = await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/$coin/$value?apikey=$apikey'));


    if(response.statusCode==200){

      return jsonDecode(response.body);

    }else{
      print("vandy");
      print(response.statusCode);
    }
  }

}