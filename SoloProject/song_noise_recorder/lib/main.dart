import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:song_noise_recorder/mqtt.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MQTT mqtt;
  static AudioCache cachePlayer = AudioCache();
  AudioPlayer audioPlayer = new AudioPlayer();
  List<double> dbNoises = [];

  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;

  @override
  void initState() {
    super.initState();
    _noiseMeter = new NoiseMeter(onError);
    mqtt = new MQTT();
  }

  void onError(PlatformException e) {
    print(e.toString());
    _isRecording = false;
  }


  void playSong() async{
    cachePlayer.play("sample.mp3");

    int duration = await _getDuration();

    Timer(Duration(milliseconds: duration),(){
      stopRecorder();
    });
  }

  Future<int> _getDuration() async {
    File audiofile = (await cachePlayer.load('sample.mp3'));
    await audioPlayer.setUrl(
      audiofile.path,
    );
    int duration = await Future.delayed(
      Duration(seconds: 2),
          () => audioPlayer.getDuration(),
    );
    return duration;
  }

  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (exception) {
      print(exception);
    }
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });

    print(noiseReading.maxDecibel);
    dbNoises.add(noiseReading.maxDecibel);

  }

  void stopRecorder() async {
    try {
      mqtt.publish(dbNoises.toString());
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void testMqtt(){
    List<double> rdm = [1.0,2.2,3.4];
    mqtt.publish(rdm.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Center(
        child: new Text("Press the button to play the song!"),
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isRecording ? Colors.red : Colors.green,
        onPressed: () {
          playSong();
          start();
          //testMqtt();
        },
        tooltip: 'Record',
        child: _isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
