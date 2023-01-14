import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sapphireui/functions/root.dart';
import 'package:sprung/sprung.dart';
import 'button.dart' as sui;

/// Shows a floating sheet with padding based on the platform
class FloatingSheet extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String title;

  const FloatingSheet({
    Key? key,
    required this.child,
    required this.title,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Sprung(36),
      padding: EdgeInsets.only(
          bottom: (MediaQuery.of(context).viewInsets.bottom -
                      MediaQuery.of(context).viewPadding.bottom) <
                  0
              ? 0
              : (MediaQuery.of(context).viewInsets.bottom - bottomPadding)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, bottomPadding + 10),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: _Sheet(
            title: title,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Presents a floating model.
Future<T> showFloatingSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required String title,
  Color? backgroundColor,
  bool useRootNavigator = false,
  Curve? curve,
  bool? isDismissable,
  bool enableDrag = true,
}) async {
  final result = await showCustomModalBottomSheet(
    isDismissible: isDismissable ?? true,
    context: context,
    builder: builder,
    enableDrag: enableDrag,
    animationCurve: curve ?? Sprung(36),
    duration: const Duration(milliseconds: 500),
    containerWidget: (_, animation, child) => FloatingSheet(
      title: title,
      backgroundColor: backgroundColor,
      child: child,
    ),
    expand: false,
    useRootNavigator: useRootNavigator,
  );

  return result;
}

class _Sheet extends StatefulWidget {
  const _Sheet({
    Key? key,
    required this.title,
    required this.child,
    this.headerHeight = 50,
    this.padding = const EdgeInsets.all(8),
    this.icon,
    this.useRoot = false,
  }) : super(key: key);

  final String title;
  final Widget child;
  final double headerHeight;
  final EdgeInsets padding;
  final IconData? icon;
  final bool useRoot;

  @override
  _SheetState createState() => _SheetState();
}

class _SheetState extends State<_Sheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: CustomColors.sheetBackground(context),
          child: Padding(
            padding: widget.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: CustomColors.textColor(context),
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    sui.Button(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: widget.useRoot)
                              .pop(),
                      child: Icon(
                        widget.icon ?? Icons.close,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
