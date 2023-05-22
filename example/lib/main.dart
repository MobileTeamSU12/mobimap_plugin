import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mobimap_plugin/mobiap_gps_plugin.dart';
import 'package:mobimap_plugin/mobimap_image_plugin.dart';
import 'package:mobimap_plugin/mobimap_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? internet;
  bool? gps;
  String image = '';

  @override
  void initState() {
    MobiMapPlugin.listenInternetConnection(onReceiveData: (status) {
      internet = status;
      setState(() {

      });
    },);
    MobiMapGPSPlugin.listenGPSStatus(onReceiveData: (status) {
      gps = status;
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MobiMapPlugin;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TestLabel(
                label: 'update app version',
                child: FutureBuilder(
                  builder: (context, snapshot) => Text(snapshot.data.toString()),
                  future: MobiMapPlugin.updateAppVersion('filePath'),
                ),
              ),
              TestLabel(
                label: 'Imei',
                child: FutureBuilder(
                  builder: (context, snapshot) => Text(snapshot.data.toString()),
                  future: MobiMapPlugin.getImei(),
                ),
              ),
              TestLabel(
                label: 'Operating system version',
                child: FutureBuilder(
                  builder: (context, snapshot) => Text(snapshot.data.toString()),
                  future: MobiMapPlugin.getOperatingSystemVersion(),
                ),
              ),
              TestLabel(
                label: 'App version',
                child: FutureBuilder(
                  builder: (context, snapshot) => Text(snapshot.data.toString()),
                  future: MobiMapPlugin.getAppVersion(),
                ),
              ),
              TestLabel(
                label: 'Hash',
                child: FutureBuilder(
                  builder: (context, snapshot) => Text(snapshot.data.toString()),
                  future: MobiMapPlugin.getHashCommit(),
                ),
              ),
              TestLabel(
                label: 'App setting',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () async {
                  await MobiMapPlugin.openAppSetting();
                  print('await MobiMapPlugin.openAppSetting()');
                },),),
              ),
              TestLabel(
                label: 'GPS setting',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () {
                  MobiMapGPSPlugin.openGpsSetting();
                },),),
              ),
              TestLabel(
                label: 'Permission',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () async{
                  print( await MobiMapPlugin.requestPermission(type: 'ALL'));
                },),),
              ),

              TestLabel(
                label: 'Wifi Printer',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () async{
                  await MobiMapPlugin.connectWifiPrinter();
                },),),
              ),

              TestLabel(
                label: 'Channel Printer',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () async{
                  await MobiMapPlugin.connectChannelPrinter();
                },),),
              ),

              TestLabel(
                label: 'Print QR Code',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () async{
                  await MobiMapPlugin.printQrCode();
                },),),
              ),

              TestLabel(
                label: 'Take photo',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () async{
                  image = await MobiMapImagePlugin.takePhoto(drawText: [], fileName: 'test');
                  setState(() {

                  });
                },),),
              ),
              TestLabel(
                label: 'Location',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () async {
                  print(await MobiMapGPSPlugin.getLocation());
                },),),
              ),
              Text(image),
              TestLabel(
                label: 'Internet',
                child: FutureBuilder(
                  builder: (context, snapshot) => Text(snapshot.data.toString()),
                  future: MobiMapPlugin.getInternetConnection(),
                ),
              ),
              TestLabel(
                label: 'Internet Status',
                child: Text(internet.toString()),
              ),
              TestLabel(
                label: 'Gps status',
                child: Text(gps.toString()),
              ),
              TestLabel(
                label: 'GPS',
                child: FutureBuilder(
                  builder: (context, snapshot) => Text(snapshot.data.toString()),
                  future: MobiMapGPSPlugin.getGpsStatus(),
                ),
              ),
              TestLabel(
                label: 'launch url',
                child: Container(color: Colors.red, child: GestureDetector(onTap: () async {
                  MobiMapPlugin.launchBrowser('http://docs.google.com/viewer?url=https://istorage.fpt.vn/v2/big-upload/istorage/Map/1/202304/doc/Map_1682414322202_e355b11bd117658fc090b1c5abecaa9a_780965.pdf');
                },),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestLabel extends StatelessWidget{
  const TestLabel({super.key, this.child, this.label});
  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 70,
      color: Colors.greenAccent,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(label ?? 'none'),
          Expanded(child: child ?? Container()),
        ],
      ),
    );
  }

}