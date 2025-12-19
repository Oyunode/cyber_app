import 'package:flutter/material.dart';
import '../app_state.dart';

class ProfileAndLeaderboardPage extends StatelessWidget {
  const ProfileAndLeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Лидерборд 🌟'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF5FB), Color(0xFFFFE0F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (user != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: cs.primaryContainer,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: cs.primaryContainer,
                        child: Text(
                          user.username.isNotEmpty
                              ? user.username[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Нийт оноо: ${user.totalScore}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Text('💗 ME'),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ТОП тоглогчид',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedBuilder(
                  animation: appState,
                  builder: (context, _) {
                    final leaderboard = appState.leaderboard;
                    if (leaderboard.isEmpty) {
                      return const Center(
                        child: Text('Одоогоор тоглосон хүн алга 😊'),
                      );
                    }
                    return ListView.separated(
                      itemCount: leaderboard.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final u = leaderboard[index];
                        final isMe = u == user;
                        final rank = index + 1;

                        final Color rankColor;
                        if (rank == 1) {
                          rankColor = const Color(0xFFFFD700);
                        } else if (rank == 2) {
                          rankColor = const Color(0xFFC0C0C0);
                        } else if (rank == 3) {
                          rankColor = const Color(0xFFCD7F32);
                        } else {
                          rankColor = cs.secondaryContainer;
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isMe
                                  ? cs.primary
                                  : Colors.pink.shade50,
                              width: isMe ? 1.8 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: rankColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$rank',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: cs.primaryContainer,
                                child: Text(
                                  u.username.isNotEmpty
                                      ? u.username[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  u.username,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: isMe
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                ),
                              ),
                              Text(
                                u.totalScore.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: cs.primary,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              const Text('⭐'),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
