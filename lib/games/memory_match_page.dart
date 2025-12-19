import 'dart:math';
import 'package:flutter/material.dart';
import '../models/memory_card.dart';
import '../app_state.dart';

class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({super.key});

  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage> {
  late List<MemoryCardModel> cards;
  MemoryCardModel? firstSelected;
  bool busy = false;
  int matches = 0;
  int lives = 3;

  @override
  void initState() {
    super.initState();
    _setupCards();
  }

  void _setupCards() {
    final pairs = <Map<String, String>>[
      {'a': 'Фишинг имэйл', 'b': 'Хуурамч мэдээлэл асуудаг имэйл'},
      {'a': 'Хүчтэй нууц үг', 'b': 'Урт, онцгой хэлц үг'},
      {'a': '2FA / MFA', 'b': 'Нэмэлт кодоор баталгаажуулалт'},
      {'a': 'Олон нийтийн Wi-Fi', 'b': 'Банкандаа нэвтрэхээс зайлсхий'},
      {'a': 'Сэжигтэй USB', 'b': 'Олдсон USB-г битгий холбо'},
      {'a': 'Фэйк вебсайт', 'b': 'URL хаягийг маш сайн шалгах'},
      {'a': 'Ransomware', 'b': 'Файл түгжиж мөнгө нэхэх'},
      {'a': 'Социал инженерчлэл', 'b': 'Хүнийг хуурч нууц авдаг'},
    ];

    final temp = <MemoryCardModel>[];
    int id = 0;
    for (final p in pairs) {
      temp.add(MemoryCardModel(id: id, text: p['a']!));
      temp.add(MemoryCardModel(id: id, text: p['b']!));
      id++;
    }

    temp.shuffle(Random());
    setState(() {
      cards = temp;
      firstSelected = null;
      matches = 0;
      lives = 3;
      busy = false;
    });
  }

  Future<void> _onCardTap(int index) async {
    if (busy || lives <= 0) return;
    final card = cards[index];
    if (card.isMatched || card.isFaceUp) return;

    setState(() {
      card.isFaceUp = true;
    });

    if (firstSelected == null) {
      firstSelected = card;
    } else {
      busy = true;
      final previous = firstSelected!;
      if (previous.id == card.id) {
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          previous.isMatched = true;
          card.isMatched = true;
          matches++;
        });
        if (matches == cards.length ~/ 2) {
          appState.addScore(12);
          _showWinDialog();
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
        setState(() {
          previous.isFaceUp = false;
          card.isFaceUp = false;
          lives--;
        });

        if (lives <= 0) {
          _showGameOverDialog();
        }
      }
      firstSelected = null;
      busy = false;
    }
  }

  Future<void> _showWinDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Гайхалтай ой санамж! 🧠'),
          content: const Text(
            'Бүх кибер ойлголтуудыг зөв хослууллаа.\nОноо: +12',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _setupCards();
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

  Future<void> _showGameOverDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Тоглоом дууслаа 💔'),
          content: const Text(
            'Амь дууслаа. Алдаанаасаа сураад дахин оролдоорой!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _setupCards();
              },
              child: const Text('Дахин оролдох'),
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

  Widget _buildLivesRow(ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final filled = i < lives;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            filled ? Icons.favorite : Icons.favorite_border,
            size: 22,
            color: filled ? cs.error : cs.outline,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Санах ойн карт – Кибер'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Картуудыг нээгээд кибер аюул – тайлбар гэсэн хосуудыг ол.\n'
              'Буруу таацвал 1 амь хасагдана (нийт 3 амь).',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          _buildLivesRow(cs),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                final gridWidth = isWide ? 600.0 : constraints.maxWidth;

                return Center(
                  child: SizedBox(
                    width: gridWidth,
                    child: GridView.builder(
                      itemCount: cards.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        final faceUp = card.isFaceUp || card.isMatched;

                        return GestureDetector(
                          onTap: () => _onCardTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: card.isMatched
                                  ? cs.primaryContainer.withOpacity(0.5)
                                  : faceUp
                                      ? cs.surface
                                      : cs.surfaceVariant,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: card.isMatched
                                    ? cs.primary
                                    : cs.outline.withOpacity(0.4),
                                width: 1.2,
                              ),
                              boxShadow: [
                                if (faceUp)
                                  BoxShadow(
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                    color: Colors.black.withOpacity(0.12),
                                  ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                faceUp ? card.text : '❓',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: card.isMatched
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                              ),
                            ),
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
            child: FilledButton.tonal(
              onPressed: _setupCards,
              child: const Text('Шинээр эхлэх'),
            ),
          ),
        ],
      ),
    );
  }
}
