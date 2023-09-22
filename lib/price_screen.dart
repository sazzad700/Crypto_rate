import 'package:bitcoin_app/helper/networkHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? SelectedCurrentCur = "USD";
  String? Btcrate = '?';
  String? Ethrate='?';
  String? Ltcrate='?';

  @override
  void initState() {
    super.initState();

    setvalue();
  }

  Widget androidDropdown() {
    List<DropdownMenuItem<String>> DropdownmenuItem = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      DropdownmenuItem.add(newItem);
    }

    return DropdownButton<String>(
        value: SelectedCurrentCur,
        items: DropdownmenuItem,
        onChanged: (value) {
          setState(() {
            Btcrate = "?";
            Ethrate="?";
            Ltcrate="?";
            SelectedCurrentCur = value;
          });
          setvalue();
        });
  }

  Widget iosPicker() {
    List<Text> children = [];

    for (String currency in currenciesList) {
      children.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        setState(() {
          Btcrate = "?";
          Ethrate="?";
          Ltcrate="?";
          SelectedCurrentCur = currenciesList[index];
        });
       setvalue();
      },
      children: children,
    );
  }

   setvalue() async {
    try {
      // Call the async function and await the result.
      String Btcresult =await getApivalue("BTC");
      String Ethresult=await getApivalue("ETH");
      String Ltcresult=await getApivalue("LTC");
      // Update the state with the received data.
      setState(() {
        Btcrate = Btcresult;
        Ethrate=Ethresult;
        Ltcrate=Ltcresult;
      });
    } catch (error) {
      // Handle any errors that occur during the asynchronous operation.
      print('Error: $error');
    }
  }

  getApivalue(String coin) async {

    networkhelper obj =await networkhelper(value: SelectedCurrentCur,coin: coin);
    var value = await obj.getdata();
    double s = value['rate'];

       return s.toInt().toString();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              children(
                currency: 'BTC',
                rate: Btcrate,
                SelectedCurrentCur: SelectedCurrentCur,
              ),
              children(
                currency: 'ETH',
                rate: Ethrate,
                SelectedCurrentCur: SelectedCurrentCur,
              ),
              children(
                currency: 'LTC',
                rate: Ltcrate,
                SelectedCurrentCur: SelectedCurrentCur,
              ),

            ],
          ),

          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? androidDropdown() : iosPicker(),
          ),
        ],
      ),
    );
  }
}


class children extends StatelessWidget {

    var rate;
    var SelectedCurrentCur;
    var currency;
    children({this.rate,this.SelectedCurrentCur,this.currency});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $currency = $rate $SelectedCurrentCur',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


