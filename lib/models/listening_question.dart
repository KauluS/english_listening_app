// questions_data.dartファイルで使用されるモデルクラスを定義

class ListeningQuestion {
  final String audioPath;
  final String imagePath;
  final String englishText;

  const ListeningQuestion({
    required this.audioPath,
    required this.imagePath,
    required this.englishText,
  });
}
