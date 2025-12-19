import 'package:flutter/material.dart';

class TheoryScreen extends StatelessWidget {
  const TheoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final items = <_TheoryItem>[
      _TheoryItem(
        title: 'Фишинг (Phishing)',
        description:
            'Хэрэглэгчийг хуурч нүүр хуудас, имэйл, мессежээр нууц мэдээлэл авахаар оролддог халдлага.',
        bullets: [
          'Ихэвчлэн банк, сошиал, төрийн байгууллагын нэрийг ашиглана.',
          'Яаралтай, айлгасан үг хэрэглэдэг: “аккаунт түгжигдлээ”, “шагнал хожлоо” гэх мэт.',
          'Бодит домэйн хаягтай төстэй линк ашигладаг.',
        ],
      ),
      _TheoryItem(
        title: 'Хүчтэй нууц үг',
        description:
            'Хүн болон програм амархан тааж болшгүй урт, ховор, олон төрлийн тэмдэгттэй нууц үг.',
        bullets: [
          'Дор хаяж 12+ тэмдэгт.',
          'Жижиг/том үсэг, тоо, тусгай тэмдэгт хослуул.',
          'Нэг нууц үгийг олон сайтад давтаж битгий ашигла.',
        ],
      ),
      _TheoryItem(
        title: '2 шатлалт баталгаажуулалт (2FA/MFA)',
        description:
            'Нууц үгээс гадна нэмэлт код, апп, токен ашиглаж нэвтрэх хамгаалалт.',
        bullets: [
          'Имэйл, банк, гол аккаунтууд дээр заавал асаах хэрэгтэй.',
          'Нэг удаагийн OTP кодоо хэнд ч өгч болохгүй.',
        ],
      ),
      _TheoryItem(
        title: 'Социал инженерчлэл',
        description:
            'Систем биш хүнийг нь хуурч, итгэлийг ашиглан мэдээлэл авдаг халдлага.',
        bullets: [
          'Хуурамч IT ажилтан, банкны ажилтан болж ярьдаг.',
          '“Зөвхөн чамд туслая”, “түр зуурын код” гэх мэт үг хэллэг ашиглана.',
        ],
      ),
      _TheoryItem(
        title: 'Олон нийтийн Wi-Fi',
        description:
            'Нууц үггүй эсвэл олон хүн ашигладаг сүлжээнд чухал аккаунтаар нэвтрэхэд эрсдэлтэй.',
        bullets: [
          'Банк, имэйл, сургуулийн системд нэвтэрч болохгүй.',
          'VPN ашиглавал илүү аюулгүй.',
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Онол – Кибер аюулгүй байдал'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F0FF), Color(0xFFF4E8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  ...item.bullets.map(
                    (b) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(
                            child: Text(
                              b,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TheoryItem {
  final String title;
  final String description;
  final List<String> bullets;

  _TheoryItem({
    required this.title,
    required this.description,
    required this.bullets,
  });
}
