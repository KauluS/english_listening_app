import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/listening_question.dart';
import '../data/questions_data.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState? _playerState;
  late StreamSubscription stream;

  @override
  void initState() {
    super.initState();

    _playerState = _audioPlayer.state;

    stream = _audioPlayer.onPlayerStateChanged
        .listen((it) => setState(() => _playerState = it));
  }

  bool _showText = false;
  int _currentQuestionIndex = 0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    ListeningQuestion currentQuestion =
        listeningQuestions[_currentQuestionIndex];

    // 1回目の再生（テキスト非表示）
    await _audioPlayer.play(AssetSource(currentQuestion.audioPath));
    await Future.delayed(Duration(seconds: currentQuestion.duration));

    // テキストを表示
    setState(() => _showText = true);
    await _audioPlayer.stop();

    // 2回目の再生（テキスト表示あり）
    await _audioPlayer.play(AssetSource(currentQuestion.audioPath));
    await Future.delayed(Duration(seconds: currentQuestion.duration));

    // 音声終了後、テキストを非表示
    await _audioPlayer.stop();
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < listeningQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showText = false;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _showText = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ListeningQuestion currentQuestion =
        listeningQuestions[_currentQuestionIndex];

    bool isPlaying = _playerState == PlayerState.playing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('リスニング'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '問題 ${_currentQuestionIndex + 1}/${listeningQuestions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Image.asset(
              currentQuestion.imagePath,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playAudio,
              child: Text(isPlaying ? '再生中...' : '再生'),
            ),
            const SizedBox(height: 20),
            if (_showText)
              Text(
                currentQuestion.englishText,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      _currentQuestionIndex > 0 ? _previousQuestion : null,
                  child: const Text('前へ'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed:
                      _currentQuestionIndex < listeningQuestions.length - 1
                          ? _nextQuestion
                          : null,
                  child: const Text('次へ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
