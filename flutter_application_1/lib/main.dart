import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const FintechHomeScreen(),
    );
  }
}

class FintechHomeScreen extends StatelessWidget {
  const FintechHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -30,
                  left: -20,
                  right: -20,
                  bottom: -30,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: RadialGradient(
                          colors: [
                            Colors.blueAccent.withValues(alpha: 0.7),
                            Colors.blueAccent.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16181F),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Main profile avatar now uses the uploaded sticker
                      // instead of the Icons.person placeholder.
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Color(0xFF232838),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.blueAccent,
                          backgroundImage: AssetImage(
                            'assets/images/profile_main.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Johnny Depp',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Rmcx_dn8v87d_ljh8589',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                const ClipboardData(
                                  text: 'Rmcx_dn8v87d_ljh8589',
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.copy,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Current Balance',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '\$98,325',
                        style: TextStyle(
                          color: Color.fromARGB(255, 231, 229, 229),
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Each TransactionTile now takes an imagePath and shows
                    // the corresponding sticker instead of Icons.person.
                    const TransactionTile(
                      title: 'Received Money',
                      date: 'November 02, 2023',
                      amount: '+ \$213.00',
                      time: '10:12 PM',
                      imagePath: 'assets/images/tx_1.png',
                    ),
                    const TransactionTile(
                      title: 'Received Money',
                      date: 'October 29, 2023',
                      amount: '+ \$102.00',
                      time: '10:12 PM',
                      imagePath: 'assets/images/tx_2.png',
                    ),
                    const TransactionTile(
                      title: 'Received Money',
                      date: 'October 16, 2023',
                      amount: '+ \$300.00',
                      time: '10:12 PM',
                      imagePath: 'assets/images/tx_3.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final String time;
  final String imagePath;

  const TransactionTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.time,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}