import 'dart:math';
import 'package:flutter/material.dart';
import '../app_state.dart';
import 'profile_leaderboard_screen.dart';
import 'training_screen.dart';
import 'start_screen.dart';

import '../games/tictactoe_ai_page.dart';
import '../games/tictactoe_pvp_page.dart';
import '../games/memory_match_page.dart';
import '../games/link_pairs_page.dart';
import '../games/board_game_page.dart';
import '../games/quiz_game_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = appState.currentUser;
    final username = user?.username ?? 'Тоглогч';
    final score = user?.totalScore ?? 0;
    final progress = max(0.1, (score % 100) / 100.0);

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F0FF), Color(0xFFF4E8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---------- ДЭЭД БҮХ КОНТЕНТ (scroll) ----------
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(20, 12, 20, 90),
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
                              'Кибер ур чадвараа тоглоомоор сайжруулъя',
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
                          tooltip: 'Эхлэх хуудас',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StartScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.brightness_5_rounded),
                        ),
                        IconButton(
                          tooltip: 'Лидерборд',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ProfileAndLeaderboardPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.emoji_events),
                        ),
                        IconButton(
                          tooltip: 'Гарах',
                          onPressed: () => appState.logout(),
                          icon: const Icon(Icons.logout_rounded),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ---------- ӨНӨӨДРИЙН СОРИЛ (hero card) ----------
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8E7CFF), Color(0xFF64B5F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Өнөөдрийн сорил',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Фишинг X-O (AI) тоглоомонд 1 удаа\nалдаагүйгээр ялж үзээрэй.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color:
                                              Colors.white.withOpacity(0.92),
                                        ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 8,
                                            backgroundColor:
                                                Colors.white.withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${(progress * 100).round()}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 90,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(26),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.security_rounded,
                                    size: 40,
                                    color: cs.primary,
                                  ),
                                  const SizedBox(height: 8),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const CyberTicTacToePage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Эхлэх',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------- ӨДРИЙН PILL-ҮҮД ----------
                    SizedBox(
                      height: 52,
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

                    const SizedBox(height: 16),

                    // ---------- ТӨЛӨВЛӨГӨӨ ----------
                    Text(
                      'Таны төлөвлөгөө',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _PlanCard(
                          color: const Color(0xFFFFD180),
                          title: 'Тоглоомоор давтах',
                          level: 'Medium',
                          description:
                              'X-O, санах ойн карт, самбар аяллын\nаль нэгийг тоглож дуусга.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CyberTicTacToePage(),
                              ),
                            );
                          },
                        ),
                        _PlanCard(
                          color: const Color(0xFF90CAF9),
                          title: 'Онолоо бататгах',
                          level: 'Light',
                          description:
                              'Онолын хэсгээс дор хаяж 2 булан\nуншаад, Youtube хичээл 1-г үз.',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TrainingScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ---------- ТОГЛООМУУД ГАРЧИГ ----------
                    Text(
                      'Тоглоомууд',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // ---------- ТОГЛООМЫН GRID ----------
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _GameCard(
                          icon: Icons.security_rounded,
                          title: 'Фишинг X-O',
                          subtitle: 'AI эсрэг',
                          colors: const [
                            Color(0xFF8A7DFF),
                            Color(0xFFB388FF),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CyberTicTacToePage(),
                              ),
                            );
                          },
                        ),
                        _GameCard(
                          icon: Icons.groups_rounded,
                          title: '2 тоглогч X-O',
                          subtitle: 'Нэг дэлгэцээр',
                          colors: const [
                            Color(0xFF80DEEA),
                            Color(0xFFB3E5FC),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CyberTicTacToePvpPage(),
                              ),
                            );
                          },
                        ),
                        _GameCard(
                          icon: Icons.memory_rounded,
                          title: 'Санах ой',
                          subtitle: '4×4, 3 амь',
                          colors: const [
                            Color(0xFFFFB74D),
                            Color(0xFFFFF59D),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MemoryMatchPage(),
                              ),
                            );
                          },
                        ),
                        _GameCard(
                          icon: Icons.link_rounded,
                          title: 'Хос карт',
                          subtitle: 'Аюул ↔ Хамгаалалт',
                          colors: const [
                            Color(0xFFF48FB1),
                            Color(0xFFFFCDD2),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LinkPairsPage(),
                              ),
                            );
                          },
                        ),
                        _GameCard(
                          icon: Icons.route_rounded,
                          title: 'Самбар аялал',
                          subtitle: 'Dice + quiz',
                          colors: const [
                            Color(0xFF64B5F6),
                            Color(0xFF81D4FA),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CyberBoardGamePage(),
                              ),
                            );
                          },
                        ),
                        _GameCard(
                          icon: Icons.quiz_rounded,
                          title: 'Кибер сорил',
                          subtitle: 'Түвшинтэй тест',
                          colors: const [
                            Color(0xFFBA68C8),
                            Color(0xFFE1BEE7),
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CyberQuizPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ---------- ДООД NAV ----------
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: _BottomNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==== Day pill ====
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
    final Color bg = active ? cs.onBackground : Colors.white;
    final Color fg = active ? Colors.white : cs.onBackground;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
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

// ==== Plan card ====
class _PlanCard extends StatelessWidget {
  final Color color;
  final String title;
  final String level;
  final String description;
  final VoidCallback onTap;

  const _PlanCard({
    required this.color,
    required this.title,
    required this.level,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = min(360.0, MediaQuery.of(context).size.width - 60);

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
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
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  level,
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
      ),
    );
  }
}

// ==== Game card ====
class _GameCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  const _GameCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = min(190.0, (MediaQuery.of(context).size.width - 64) / 2);

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: colors.last.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    icon,
                    size: 26,
                    color: cs.onPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onPrimary.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==== Bottom nav ====
class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavIcon(
            icon: Icons.home_rounded,
            label: 'Нүүр',
            active: true,
            colorScheme: cs,
          ),
          _NavIcon(
            icon: Icons.sports_esports_rounded,
            label: 'Тоглоом',
            active: false,
            colorScheme: cs,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TrainingScreen(),
                ),
              );
            },
            child: _NavIcon(
              icon: Icons.menu_book_rounded,
              label: 'Сургалт',
              active: false,
              colorScheme: cs,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final ColorScheme colorScheme;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.active,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? colorScheme.primary : colorScheme.onSurfaceVariant;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
