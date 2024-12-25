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

  bool get _isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();

    _playerState = _audioPlayer.state;

    _audioPlayer.onPlayerStateChanged
        .listen((state) => setState(() => _playerState = state));
  }

  bool _showText = false;
  int _currentQuestionIndex = 0;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // 音声を再生するメソッド
  void _playAudio() async {
    ListeningQuestion currentQuestion =
        listeningQuestions[_currentQuestionIndex];

    int cnt = 0; // 再生回数をカウントする変数

    while (cnt < 2) {
      if (cnt > 0) {
        setState(() => _showText = true); // テキストを表示
      }

      await _audioPlayer.play(AssetSource(currentQuestion.audioPath));

      await _audioPlayer.onPlayerComplete.first; // 再生が終わるまで待機

      await Future.delayed(Duration(seconds: 1)); // 1秒待機

      cnt++;
    }
  }

  // 次の問題に進むメソッド
  void _nextQuestion() {
    if (_currentQuestionIndex < listeningQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showText = false;
      });
    }
  }

  // 前の問題に戻るメソッド
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
              child: Text(_isPlaying ? '再生中...' : '再生'),
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
