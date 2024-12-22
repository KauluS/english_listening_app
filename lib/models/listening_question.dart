class ListeningQuestion {
  final String audioPath;
  final String imagePath;
  final String englishText;
  final int duration; // 音声の長さ（秒）

  const ListeningQuestion({
    required this.audioPath,
    required this.imagePath,
    required this.englishText,
    required this.duration,
  });
}
