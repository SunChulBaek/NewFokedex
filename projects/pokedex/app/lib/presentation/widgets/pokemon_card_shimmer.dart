import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 포켓몬 카드 shimmer 플레이스홀더
class PokemonCardShimmer extends StatelessWidget {
  const PokemonCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 14,
                    width: 80,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
