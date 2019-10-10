import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_audio/native_audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _audio = NativeAudio();
  var _isLoaded = false;
  var _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _listenForAudioEvents();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Audio'),
        ),
        body: Column(
          children: <Widget>[
            if (!_isLoaded)
              MaterialButton(
                  child: Text("Play"), onPressed: () => _playSampleAudio()),
            if (_isLoaded)
              MaterialButton(
                  child: Text("Stop"), onPressed: () => _audio.stop()),
            if (!_isPlaying)
              MaterialButton(
                  child: Text("Resume"), onPressed: () => _audio.resume()),
            if (_isPlaying)
              MaterialButton(
                  child: Text("Pause"), onPressed: () => _audio.pause()),
          ],
        ),
      ),
    );
  }

  void _listenForAudioEvents() {
    _audio.onLoaded = (audioDuration) {
      setState(() {
        _isLoaded = true;
        _isPlaying = true;
      });
    };

    _audio.onResumed = () {
      setState(() => _isPlaying = true);
    };

    _audio.onPaused = () {
      setState(() => _isPlaying = false);
    };

    _audio.onStopped = () {
      setState(() {
        _isLoaded = false;
        _isPlaying = false;
      });
    };

    _audio.onCompleted = () {
      setState(() {
        _isLoaded = false;
        _isPlaying = false;
      });
    };
  }

  void _playSampleAudio() {
    _audio.play(
        "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
        title: "How The Fashion Industry Is Responding To Climate Change",
        album: "Science Friday",
        artist: "WNYC Studio",
        imageUrl:
            "https://www.sciencefriday.com/wp-content/uploads/2019/09/clothes-close-min.jpg");
  }
}
