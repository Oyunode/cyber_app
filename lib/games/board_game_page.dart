import 'dart:math';
import 'package:flutter/material.dart';
import '../models/cyber_question.dart';
import '../app_state.dart';

enum BoardTileType { normal, question, bonus, risk }

class BoardTile {
  final int index;
  final BoardTileType type;

  BoardTile({required this.index, required this.type});
}

class CyberBoardGamePage extends StatefulWidget {
  const CyberBoardGamePage({super.key});

  @override
  State<CyberBoardGamePage> createState() => _CyberBoardGamePageState();
}

class _CyberBoardGamePageState extends State<CyberBoardGamePage> {
  static const int boardSize = 20; // tiles 0..19
  late List<BoardTile> tiles;
  late List<CyberQuestion> questions;

  int position = 0;
  int diceValue = 0;
  int lives = 3;
  bool finished = false;
  bool rolling = false;

  @override
  void initState() {
    super.initState();
    questions = buildQuestions();
    _buildBoard();
  }

  void _buildBoard() {
    final rnd = Random();
    tiles = List.generate(boardSize, (i) {
      if (i == 0) {
        return BoardTile(index: i, type: BoardTileType.normal);
      }
      if (i == boardSize - 1) {
        return BoardTile(index: i, type: BoardTileType.bonus);
      }
      final r = rnd.nextDouble();
      if (r < 0.3) {
        return BoardTile(index: i, type: BoardTileType.question);
      } else if (r < 0.4) {
        return BoardTile(index: i, type: BoardTileType.bonus);
      } else if (r < 0.5) {
        return BoardTile(index: i, type: BoardTileType.risk);
      }
      return BoardTile(index: i, type: BoardTileType.normal);
    });
  }

  void _resetGame() {
    setState(() {
      position = 0;
      diceValue = 0;
      lives = 3;
      finished = false;
      rolling = false;
      _buildBoard();
    });
  }

  Future<void> _rollDice() async {
    if (finished || lives <= 0 || rolling) return;

    setState(() {
      rolling = true;
    });

    final rnd = Random();
    int finalRoll = rnd.nextInt(6) + 1;

    // simple rolling animation
    for (int i = 0; i < 8; i++) {
      setState(() {
        diceValue = rnd.nextInt(6) + 1;
      });
      await Future.delayed(const Duration(milliseconds: 80));
    }

    setState(() {
      diceValue = finalRoll;
    });

    int newPos = position + finalRoll;
    if (newPos >= boardSize - 1) {
      newPos = boardSize - 1;
    }

    setState(() {
      position = newPos;
    });

    await _handleTileEvent(tiles[newPos]);

    if (position == boardSize - 1 && !finished) {
      finished = true;
      _showFinishDialog();
    }

    setState(() {
      rolling = false;
    });
  }

  Future<void> _handleTileEvent(BoardTile tile) async {
    if (lives <= 0 || finished) return;

    switch (tile.type) {
      case BoardTileType.normal:
        break;
      case BoardTileType.bonus:
        appState.addScore(3);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bonus tile! +3 score')),
          );
        }
        break;
      case BoardTileType.risk:
        lives--;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Risk tile! You lost 1 ❤️')),
          );
        }
        if (lives <= 0) {
          _showGameOverDialog();
        }
        break;
      case BoardTileType.question:
        final question = questions[Random().nextInt(questions.length)];
        await _askQuestion(question);
        break;
    }
  }

  Future<void> _askQuestion(CyberQuestion question) async {
    final bool? correct = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cyber question 🎯'),
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

    if (correct == true) {
      appState.addScore(5);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Correct! +5 score and you move 1 step forward'),
          ),
        );
      }
      if (position < boardSize - 1) {
        setState(() {
          position = (position + 1).clamp(0, boardSize - 1);
        });
      }
    } else if (correct == false) {
      lives--;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong answer. You lost 1 ❤️'),
          ),
        );
      }
      if (lives <= 0) {
        _showGameOverDialog();
      }
    }
  }

  Future<void> _showFinishDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('You reached the end! 🏁'),
          content: Text(
            'Great job making it through the cyber board.\n\n'
            'Player: ${appState.currentUser?.username ?? "You"}\n'
            'Total score: ${appState.currentUser?.totalScore ?? 0}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).maybePop();
              },
              child: const Text('Back'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showGameOverDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game over 💔'),
          content: const Text(
            'You ran out of lives on the cyber board.\nLearn from the questions and try again!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).maybePop();
              },
              child: const Text('Back'),
            ),
          ],
        );
      },
    );
  }

  Color _tileColor(BoardTileType type, bool isCurrent, ColorScheme cs) {
    if (isCurrent) return cs.primaryContainer;
    switch (type) {
      case BoardTileType.normal:
        return cs.surfaceVariant;
      case BoardTileType.question:
        return cs.tertiaryContainer;
      case BoardTileType.bonus:
        return cs.secondaryContainer;
      case BoardTileType.risk:
        return cs.errorContainer;
    }
  }

  IconData _tileIcon(BoardTileType type) {
    switch (type) {
      case BoardTileType.normal:
        return Icons.stop_rounded;
      case BoardTileType.question:
        return Icons.help_center_rounded;
      case BoardTileType.bonus:
        return Icons.star_rounded;
      case BoardTileType.risk:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber Board Adventure'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Roll the dice, move along the board, and survive cyber questions.\n'
              'Reach the last tile before losing all hearts.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          _buildStatusRow(cs),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                final boardWidth = isWide ? 600.0 : constraints.maxWidth;

                return Center(
                  child: SizedBox(
                    width: boardWidth,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: tiles.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // 5 x 4 board
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final tile = tiles[index];
                        final isCurrent = index == position;
                        final color = _tileColor(tile.type, isCurrent, cs);

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCurrent
                                  ? cs.primary
                                  : cs.outline.withOpacity(0.4),
                              width: isCurrent ? 2 : 1.2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _tileIcon(tile.type),
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${tile.index + 1}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (isCurrent)
                                const Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Text('🧍'),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed:
                      (finished || lives <= 0 || rolling) ? null : _rollDice,
                  icon: const Icon(Icons.casino_rounded),
                  label: const Text('Roll dice'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _resetGame,
                  child: const Text('Restart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Lives
          Row(
            children: List.generate(3, (i) {
              final filled = i < lives;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(
                  filled ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: filled ? cs.error : cs.outline,
                ),
              );
            }),
          ),
          const Spacer(),
          // Dice view
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.casino_rounded, size: 18),
                const SizedBox(width: 6),
                Text(
                  diceValue == 0 ? '-' : diceValue.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
