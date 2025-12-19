import 'dart:math';
import 'package:flutter/material.dart';
import '../app_state.dart';
import 'home_screen.dart';
import 'login_screen.dart';
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = appState.currentUser;
    final username = user?.username ?? 'Тоглогч';

    return Scaffold(
      extendBody: true,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // ---------- ДЭЭД КОНТЕНТ ----------
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    // TOP BAR
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: cs.primaryContainer,
                          child: Text(
                            username.isNotEmpty
                                ? username[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Сайн уу, $username',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Кибер аяллаа өнөөдөр эхлүүлье ✨',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: cs.onBackground.withOpacity(0.65),
                                  ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Гарах',
                          onPressed: () => appState.logout(),
                          icon: const Icon(Icons.logout_rounded),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // HERO CARD
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7FF),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Өнөөдрийн зорилго',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Кибер аюулгүй байдлын 3 алхмыг\nөнөөдөр дуусгаарай.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: cs.onBackground
                                            .withOpacity(0.75),
                                      ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.9),
                                      child: const Icon(
                                        Icons.shield_rounded,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.9),
                                      child: const Icon(
                                        Icons.lock_rounded,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.9),
                                      child: const Icon(
                                        Icons.wifi_rounded,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        '+3 алхам',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14.0),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF8E7CFF),
                                      Color(0xFF64B5F6),
                                      Color(0xFFFFB6C1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.deepPurple.withOpacity(0.3),
                                      blurRadius: 26,
                                      offset: const Offset(0, 18),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.security_rounded,
                                  color: Colors.white,
                                  size: 46,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // DAY PILLS
                    SizedBox(
                      height: 56,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          _DayPill(label: 'Дав', day: '01', active: false),
                          _DayPill(label: 'Мяг', day: '02', active: false),
                          _DayPill(label: 'Лха', day: '03', active: true),
                          _DayPill(label: 'Пүр', day: '04', active: false),
                          _DayPill(label: 'Баа', day: '05', active: false),
                          _DayPill(label: 'Бям', day: '06', active: false),
                          _DayPill(label: 'Ням', day: '07', active: false),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Таны аяллын төлөвлөгөө',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        _PlanCard(
                          color: Color(0xFFFFD180),
                          chip: 'Алхам 1',
                          title: 'Онолтой танилцах',
                          description:
                              'Кибер халдлага, фишинг,\nнууц үгийн талаар богино\nонол унш.',
                        ),
                        _PlanCard(
                          color: Color(0xFF90CAF9),
                          chip: 'Алхам 2',
                          title: 'Тоглоомоор давтах',
                          description:
                              'Фишинг X-O, санах ойн карт,\nсамбар аяллаас дор хаяж 1-г\nтоглож дуусга.',
                        ),
                        _PlanCard(
                          color: Color(0xFFF48FB1),
                          chip: 'Алхам 3',
                          title: 'Видео үзэж гүнзгийрүүлэх',
                          description:
                              'Youtube хичээл, тэмцээний\nзаруудаас хүссэн 1-г үз.',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ДООД CTA ТОВЧ
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Кибер аяллаа эхлүүлэх',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// туслах виджетүүд
class _DayPill extends StatelessWidget {
  final String label;
  final String day;
  final bool active;

  const _DayPill({
    required this.label,
    required this.day,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = active ? Colors.black : Colors.white;
    final fg = active ? Colors.white : cs.onBackground;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active ? Colors.black : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: fg,
              fontSize: 13,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: fg.withOpacity(0.9),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Color color;
  final String chip;
  final String title;
  final String description;

  const _PlanCard({
    required this.color,
    required this.chip,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final width = min(360.0, MediaQuery.of(context).size.width - 60);

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.45),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                chip,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
