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
  bool _showText = false;
  int _currentQuestionIndex = 0;
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);

    ListeningQuestion currentQuestion = listeningQuestions[_currentQuestionIndex];

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
    setState(() {
      _showText = false;
      _isPlaying = false;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < listeningQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showText = false;
        _isPlaying = false;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _showText = false;
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ListeningQuestion currentQuestion = listeningQuestions[_currentQuestionIndex];

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
              onPressed: _isPlaying ? null : _playAudio,
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
                  onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                  child: const Text('前へ'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _currentQuestionIndex < listeningQuestions.length - 1
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
