class MemoryCardModel {
  final int id; // pair id
  final String text;
  bool isFaceUp;
  bool isMatched;

  MemoryCardModel({
    required this.id,
    required this.text,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}
