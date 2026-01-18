import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duo Scene',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DuoScenePage(),
      },
    );
  }
}

class DuoScenePage extends StatefulWidget {
  const DuoScenePage({super.key});

  @override
  State<DuoScenePage> createState() => _DuoScenePageState();
}

class _DuoScenePageState extends State<DuoScenePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('The Encounter'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Rain Effect Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: RainPainter(_controller.value),
                );
              },
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCharacterCard(
                    context,
                    "The Heavyweight",
                    "A very large gentleman",
                    Icons.accessibility_new_rounded,
                    Colors.orangeAccent,
                  ),
                  const SizedBox(height: 40),
                  const Icon(Icons.add, color: Colors.white54, size: 40),
                  const SizedBox(height: 40),
                  _buildCharacterCard(
                    context,
                    "Sophie Rain",
                    "The iconic character",
                    Icons.water_drop_rounded,
                    Colors.lightBlueAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, String title, String subtitle, IconData icon, Color accentColor) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: accentColor.withOpacity(0.2),
            child: Icon(icon, size: 50, color: accentColor),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class RainPainter extends CustomPainter {
  final double animationValue;
  final List<RainDrop> drops = List.generate(100, (index) => RainDrop());

  RainPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var drop in drops) {
      double y = (drop.y + animationValue * drop.speed * size.height) % size.height;
      canvas.drawLine(
        Offset(drop.x * size.width, y),
        Offset(drop.x * size.width, y + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RainPainter oldDelegate) => true;
}

class RainDrop {
  final double x = math.Random().nextDouble();
  final double y = math.Random().nextDouble() * 1000;
  final double speed = 0.5 + math.Random().nextDouble() * 0.5;
  final double length = 10 + math.Random().nextDouble() * 20;
}
