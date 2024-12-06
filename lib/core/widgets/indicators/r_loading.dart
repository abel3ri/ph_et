import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RLoading extends StatelessWidget {
  const RLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset("assets/lotties/loading.json");
  }
}
