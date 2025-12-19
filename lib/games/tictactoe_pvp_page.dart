import 'package:flutter/material.dart';
import '../models/cyber_question.dart';
import '../app_state.dart';

class CyberTicTacToePvpPage extends StatefulWidget {
  const CyberTicTacToePvpPage({super.key});

  @override
  State<CyberTicTacToePvpPage> createState() => _CyberTicTacToePvpPageState();
}

class _CyberTicTacToePvpPageState extends State<CyberTicTacToePvpPage> {
  final List<String?> board = List<String?>.filled(9, null);
  late List<CyberQuestion> questions;
  String currentPlayer = 'X';
  String? winner;

  @override
  void initState() {
    super.initState();
    questions = buildQuestions();
  }

  void _resetGame() {
    setState(() {
      for (int i = 0; i < board.length; i++) {
        board[i] = null;
      }
      winner = null;
      currentPlayer = 'X';
    });
  }

  Future<void> _onCellTap(int index) async {
    if (winner != null || board[index] != null) return;

    final question = questions[index % questions.length];
    final bool? correct = await _showQuestionDialog(question, currentPlayer);

    if (correct == true) {
      setState(() {
        board[index] = currentPlayer;
      });
      _checkGameState(currentPlayer);
      if (winner == null && !_isBoardFull()) {
        setState(() {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        });
      }
    } else if (correct == false && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Буруу хариуллаа. Тоглогч $currentPlayer ээлжээ алгаслаа!'),
        ),
      );
      if (!_isBoardFull() && winner == null) {
        setState(() {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        });
      }
    }
  }

  Future<bool?> _showQuestionDialog(CyberQuestion question, String player) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title:
              Text('Тоглогч $player, өөрийн тэмдэгээ тавихын тулд зөв хариул!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(question.prompt),
              const SizedBox(height: 12),
              ...List.generate(question.options.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(i == question.correctIndex);
                    },
                    child: Text(question.options[i]),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _checkGameState(String player) {
    final lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final line in lines) {
      final a = line[0];
      final b = line[1];
      final c = line[2];
      if (board[a] == player && board[b] == player && board[c] == player) {
        setState(() {
          winner = player;
        });
        _showWinnerDialog(player);
        return;
      }
    }

    if (_isBoardFull() && winner == null) {
      _showWinnerDialog(null);
    }
  }

  bool _isBoardFull() => board.every((cell) => cell != null);

  Future<void> _showWinnerDialog(String? player) async {
    String title;
    String message;
    int scoreGain = 0;

    if (player == 'X') {
      title = 'Тоглогч X яллаа! 🎉';
      message = 'Кибер мэдлэгтэй байлаа. Оноо нь бүртгэгдлээ.';
      scoreGain = 8;
    } else if (player == 'O') {
      title = 'Тоглогч O яллаа! 🎉';
      message = 'Сайн хамгаалсан байна. Оноо нь бүртгэгдлээ.';
      scoreGain = 8;
    } else {
      title = 'Тэнцлээ 🤝';
      message = 'Хоёр тал адилхан сайн байлаа.';
      scoreGain = 4;
    }

    if (scoreGain > 0) {
      appState.addScore(scoreGain);
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
              '$message\n\nСистемд нэвтэрсэн хэрэглэгчийн оноо: +$scoreGain'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Дахин тоглох'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).maybePop();
              },
              child: const Text('Буцах'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кибер X-O – 2 тоглогч'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Нэг дэлгэц дээр хоёр тоглогч тоглоно.\n'
              'Одоогийн ээлж: $currentPlayer',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.surfaceVariant.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemBuilder: (context, index) {
                      final value = board[index];
                      return GestureDetector(
                        onTap: () => _onCellTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: cs.outline.withOpacity(0.5),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              value ?? '',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color:
                                    value == 'X' ? cs.primary : cs.secondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FilledButton.tonal(
              onPressed: _resetGame,
              child: const Text('Самбарыг цэвэрлэх'),
            ),
          ),
        ],
      ),
    );
  }
}
