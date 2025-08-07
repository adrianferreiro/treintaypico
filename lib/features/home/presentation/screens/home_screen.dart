import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const name = 'home-screen';
  static const path = '/home';

  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            spacing: 12,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.black26),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: AppLogo(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
