import 'package:docveda_app/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:flutter/material.dart';

class DocvedaCurvedEdgesWidget extends StatelessWidget {
  const DocvedaCurvedEdgesWidget({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: DocvedaCustomCurvedEdges(), child: child);
  }
}
