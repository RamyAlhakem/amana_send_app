import 'package:flutter/material.dart';

import '/app/widgets/divider.dart';
import '/app/widgets/row.dart';
import '/app/widgets/shimmer/shimmer_load.dart';
import '/database/injector.dart';

class HomeLoader extends StatelessWidget {
  const HomeLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Database().getUser;
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      children: [
        ShimmerLoad(
          height: 50,
          horizontalCount: userBox.token.isEmpty ? 2 : 1,
        ),
        const ShimmerLoad(height: 50, verticalCount: 2),
        const ShimmerLoad(height: 70, horizontalCount: 3),
        const SizedBox(height: 4),
        _title(context, 0.15, 0.12),
        _title(context, 0.35, 0.15),
        _title(context, 0.25, 0.25),
        _title(context, 0.32, 0.35),
        const HDivider(height: 30),
        _title(context, 0.15, 0.3),
        _title(context, 0.25, 0.3),
        const SizedBox(height: 8),
        const ShimmerLoad(height: 50),
      ],
    );
  }

  Widget _title(BuildContext context, double start, double end) {
    return RowSpaceBetween([
      ShimmerLoad(
        height: 22,
        width: MediaQuery.of(context).size.width * start,
        radius: 5,
        spacingY: 3,
      ),
      ShimmerLoad(
        height: 22,
        width: MediaQuery.of(context).size.width * end,
        radius: 5,
        spacingY: 3,
      ),
    ]);
  }
}
