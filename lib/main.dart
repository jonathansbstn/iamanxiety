import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnxietyDashboard(),
    );
  }
}

class AnxietyDashboard extends StatefulWidget {
  const AnxietyDashboard({super.key});

  @override
  State<AnxietyDashboard> createState() => _AnxietyDashboardState();
}

class _AnxietyDashboardState extends State<AnxietyDashboard>
    with TickerProviderStateMixin {
  late AnimationController particleController;
  late AnimationController pulseController;

  final List<Map<String, dynamic>> modes = [
    {
      "title": "Overthinking Mode",
      "desc": "Menganalisa semua kemungkinan buruk 😵",
      "icon": Icons.psychology,
      "color": Colors.orangeAccent,
    },
    {
      "title": "Social Panic Mode",
      "desc": "Takut dinilai & over aware 😰",
      "icon": Icons.groups,
      "color": Colors.pinkAccent,
    },
    {
      "title": "Midnight Spiral Mode",
      "desc": "Overthinking maksimal jam 2 pagi 🌙",
      "icon": Icons.nightlight_round,
      "color": Colors.deepPurpleAccent,
    },
    {
      "title": "Future Fear Mode",
      "desc": "Takut masa depan yang belum terjadi 🔮",
      "icon": Icons.visibility,
      "color": Colors.lightBlueAccent,
    },
  ];

  @override
  void initState() {
    super.initState();

    particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    particleController.dispose();
    pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌈 Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E1B2E),
                  Color(0xFF2A2540),
                  Color(0xFF312B55),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// 🌟 Floating Particles
          AnimatedBuilder(
            animation: particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(particleController.value),
                size: MediaQuery.of(context).size,
              );
            },
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  /// 🔥 JUDUL PALING ATAS
                  const Text(
                    "I Am Anxiety",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🖼 LOGO ANXIETY (FIXED VERSION)
                  Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.3),
                          blurRadius: 60,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(25), //
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(0, 255, 255, 255), //
                      ),
                      child: Image.asset(
                        "assets/anxiety.png",
                        fit: BoxFit.contain, //
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 🎬 CARD-CARD VERTICAL
                  ...modes.asMap().entries.map((entry) {
                    int index = entry.key;
                    var mode = entry.value;

                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 600 + (index * 200)),
                      tween: Tween(begin: 0.8, end: 1.0),
                      curve: Curves.elasticOut,
                      builder: (context, double value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: anxietyCard(
                        mode["title"],
                        mode["desc"],
                        mode["icon"],
                        mode["color"],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget anxietyCard(String title, String desc, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          /// 🧠 Pulse Icon
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 + (pulseController.value * 0.12),
                child: child,
              );
            },
            child: CircleAvatar(
              radius: 35,
              backgroundColor: color,
              child: Icon(icon, size: 35, color: Colors.white),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double progress;
  ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(2);
    final paint = Paint()
      ..color = Colors.orangeAccent.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    for (int i = 0; i < 50; i++) {
      final dx = random.nextDouble() * size.width;
      final dy =
          (random.nextDouble() * size.height + progress * 300) % size.height;
      canvas.drawCircle(Offset(dx, dy), random.nextDouble() * 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
