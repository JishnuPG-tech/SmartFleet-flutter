import "package:flutter/material.dart";
import "../tokens/app_colors.dart";

class BottomSheetScaffold extends StatelessWidget {
  final Widget body;
  final Widget sheetContent;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final List<double>? snapSizes;

  const BottomSheetScaffold({
    super.key,
    required this.body,
    required this.sheetContent,
    this.initialChildSize = 0.55,
    this.minChildSize = 0.35,
    this.maxChildSize = 0.92,
    this.snapSizes = const [0.35, 0.55, 0.92],
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        // Background layer (e.g. Map, Hero)
        Positioned.fill(child: body),

        // Draggable sheet layer
        DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          snap: true,
          snapSizes: snapSizes,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: colors.border, width: 1.5),
                  left: BorderSide(color: colors.border, width: 1.5),
                  right: BorderSide(color: colors.border, width: 1.5),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: sheetContent),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
