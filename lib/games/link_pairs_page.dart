import 'dart:math';
import 'package:flutter/material.dart';
import '../models/link_pair.dart';
import '../app_state.dart';

class LinkPairsPage extends StatefulWidget {
  const LinkPairsPage({super.key});

  @override
  State<LinkPairsPage> createState() => _LinkPairsPageState();
}

class _LinkPairsPageState extends State<LinkPairsPage> {
  late List<LinkPair> pairs;
  late List<String> shuffledDefenses;
  String? selectedThreat;
  Map<String, String> matches = {};

  @override
  void initState() {
    super.initState();
    _setupPairs();
  }

  void _setupPairs() {
    pairs = [
      LinkPair(
        threat: 'Фишинг имэйл',
        defense: 'Илгээгч, домэйнийг шалгаж, сэжигтэй бол дарж/хариулахгүй',
      ),
      LinkPair(
        threat: 'Сул нууц үг',
        defense: 'Урт, давтагдашгүй хүчтэй нууц үг ашиглах',
      ),
      LinkPair(
        threat: 'Олон нийтийн Wi-Fi',
        defense: 'VPN хэрэглэх эсвэл чухал аккаунтад нэвтрэхгүй байх',
      ),
      LinkPair(
        threat: 'Олдсон USB',
        defense: 'Төхөөрөмждөө холбохгүй, хамгаалалтын ажилтанд өгөх',
      ),
      LinkPair(
        threat: 'Хуурамч бэлэг / сугалаа',
        defense: 'Хэт гоё санагдвал эргэлзэж, албан ёсны эх сурвалжийг шалгах',
      ),
    ];

    shuffledDefenses = pairs.map((p) => p.defense).toList();
    shuffledDefenses.shuffle(Random());
    selectedThreat = null;
    matches.clear();
    setState(() {});
  }

  void _onSelectThreat(String threat) {
    setState(() {
      if (selectedThreat == threat) {
        selectedThreat = null;
      } else {
        selectedThreat = threat;
      }
    });
  }

  void _onSelectDefense(String defense) {
    if (selectedThreat == null) return;

    final pair = pairs.firstWhere((p) => p.threat == selectedThreat);
    final isCorrect = pair.defense == defense;

    if (isCorrect) {
      setState(() {
        matches[pair.threat] = defense;
        selectedThreat = null;
      });

      if (matches.length == pairs.length) {
        appState.addScore(6);
        _showCompletedDialog();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Энэ хамгаалалт тухайн аюулд тохирохгүй байна. Дахин!'),
        ),
      );
    }
  }

  Future<void> _showCompletedDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Бүх хосыг зөв холболоо! 🔗'),
          content: const Text(
            'Кибер аюул бүрт тохирох хамгаалалтыг зөв сонголоо.\nОноо: +6',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _setupPairs();
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
        title: const Text('Хос карт – Аюул & Хамгаалалт'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Зүүн талд аюул, баруун талд хамгаалалт байгаа.\n'
              'Аюулыг сонгоод тохирох хамгаалалтыг дарж хослуулаарай.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Threats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Аюулууд',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.separated(
                            itemCount: pairs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final threat = pairs[index].threat;
                              final isMatched = matches.containsKey(threat);
                              final isSelected = selectedThreat == threat;
                              return GestureDetector(
                                onTap: () {
                                  if (!isMatched) {
                                    _onSelectThreat(threat);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isMatched
                                        ? cs.primaryContainer.withOpacity(0.4)
                                        : isSelected
                                            ? cs.primaryContainer
                                            : cs.surfaceVariant,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isMatched
                                          ? cs.primary
                                          : cs.outline.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Text(
                                    threat,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: isMatched
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Defenses
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Хамгаалалт',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.separated(
                            itemCount: shuffledDefenses.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final defense = shuffledDefenses[index];
                              final isUsed =
                                  matches.values.any((d) => d == defense);

                              return GestureDetector(
                                onTap: () {
                                  if (!isUsed) {
                                    _onSelectDefense(defense);
                                  }
                                },
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isUsed
                                        ? cs.secondaryContainer
                                            .withOpacity(0.4)
                                        : cs.surfaceVariant,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isUsed
                                          ? cs.secondary
                                          : cs.outline.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Text(
                                    defense,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontStyle: isUsed
                                              ? FontStyle.italic
                                              : FontStyle.normal,
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FilledButton.tonal(
              onPressed: _setupPairs,
              child: const Text('Шинээр эхлэх'),
            ),
          ),
        ],
      ),
    );
  }
}
