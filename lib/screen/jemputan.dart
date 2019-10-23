import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jemputan Malea',
      home: Layout(),
    );
  }
}

class Layout extends StatefulWidget {
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final String url =
      'https://script.google.com/macros/s/AKfycbznr__g9n2iEEOR94Q06ccPyJVFt4LYiIfkn6jjeZHERMQfyyq2/exec?id=1YrvygmfoHLMMf_7I5y7oluUqWsAyrqna9hx4mUOa6iw&sheet=data';
  List data;

  final formatter = new NumberFormat("#,###");

  Future<String> getData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
    setState(() {
      var content = json.decode(res.body);
      data = content['data'];
    });
    return 'success!';
  }

  void refreshData() {
    FlutterRingtonePlayer.playNotification(volume: 0.5, looping: true);
    getData();
  }

  @override
  void initState() {
    super.initState();
    this.getData();
    OneSignal.shared.init("32bb7f83-9bfe-4120-9f7a-e0b9fa1ccdb3");

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/wisata.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('JEMPUTAN MALEA'),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Container(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.all(10.0),

              //LIST VIEW
              child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.transparent,
                      //CARD
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          color: Colors.transparent,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          //LIST TILE
                          ListTile(
                            subtitle: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            data[index]['nama'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Image.network(
                                            data[index]['foto'],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "Tempat Jemput : " +
                                                data[index]['tempat'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "Perjalanan : " +
                                                formatter
                                                    .format(data[index]['jml']) +
                                                " kali",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "Tagihan : Rp. " +
                                                formatter.format(
                                                    data[index]['bulanan']),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                    ),
                  ),
                      ));
                },
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              refreshData();
            },
            tooltip: 'Refresh',
            child: Icon(Icons.refresh),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ],
    );
  }
}
