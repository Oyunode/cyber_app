import 'package:flutter/material.dart';
import '../models/cyber_question.dart';
import '../app_state.dart';

class CyberQuizPage extends StatefulWidget {
  const CyberQuizPage({super.key});

  @override
  State<CyberQuizPage> createState() => _CyberQuizPageState();
}

class _CyberQuizPageState extends State<CyberQuizPage> {
  late final List<CyberQuestion> questions;
  int currentIndex = 0;
  int correctCount = 0;
  int lives = 3;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    questions = buildQuestions();
  }

  void _answer(int selected) {
    if (finished || lives <= 0) return;
    final q = questions[currentIndex];
    final isCorrect = selected == q.correctIndex;

    if (isCorrect) {
      correctCount++;
      appState.addScore(2); // жижиг оноо
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Зөв хариуллаа 💕')),
      );
    } else {
      lives--;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Буруу хариуллаа. Үлдсэн амь: $lives'),
        ),
      );
      if (lives <= 0) {
        _finishQuiz();
        return;
      }
    }

    if (currentIndex == questions.length - 1) {
      _finishQuiz();
    } else {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _finishQuiz() {
    setState(() {
      finished = true;
    });
    final bonus = correctCount >= questions.length * 0.7 ? 8 : 3;
    appState.addScore(bonus);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Кибер сорил дууслаа 🎀'),
          content: Text(
            'Нийт ${questions.length}-с $correctCount зөв.\n'
            'Нэмэлт оноо: +$bonus',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restart();
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

  void _restart() {
    setState(() {
      currentIndex = 0;
      correctCount = 0;
      lives = 3;
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кибер сорил 📚'),
        centerTitle: true,
        backgroundColor: cs.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // статус
            Row(
              children: [
                Text('Асуулт: ${currentIndex + 1}/${questions.length}'),
                const Spacer(),
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
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.primaryContainer),
              ),
              child: Text(
                q.prompt,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: q.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.secondaryContainer,
                      foregroundColor: cs.onSecondaryContainer,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () => _answer(i),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(q.options[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
