import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sprung/sprung.dart';
import 'package:provider/provider.dart';

class _SheetProvider extends ChangeNotifier {
  bool _isScaled = false;

  bool get isScaled => _isScaled;

  void setIsScaled(bool val) {
    _isScaled = val;
    notifyListeners();
  }
}

/// Allows for accessing the [CupertinoSheet] and using
/// the [showCupertinoSheet] method. This wraps the entire future
/// widget tree inside a provider that allows for
/// the scale method to be triggered throughout the widget tree.
class CupertinoSheetBase extends StatelessWidget {
  CupertinoSheetBase({
    super.key,
    required this.child,
  });
  final Widget child;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // create the provider when the root widget is wrapped
    // inside the base widget
    return ChangeNotifierProvider(
      create: ((context) => _SheetProvider()),
      builder: (context, child) {
        return _body(context);
      },
    );
  }

  Widget _body(BuildContext context) {
    _SheetProvider smodel = Provider.of<_SheetProvider>(context);
    return Container(
      key: _key,
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
      child: AnimatedScale(
        scale: smodel.isScaled ? 0.85 : 1,
        curve: Sprung.overDamped,
        duration: const Duration(milliseconds: 500),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(smodel.isScaled ? 15 : 0),
          child: child,
        ),
      ),
    );
  }
}

/// The base widget to be used inside the [showCupertinoSheet].
class CupertinoSheet extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final BuildContext oldContext;
  final bool? rescaleScreen;

  const CupertinoSheet({
    Key? key,
    required this.child,
    required this.oldContext,
    this.backgroundColor,
    this.rescaleScreen,
  }) : super(key: key);

  @override
  State<CupertinoSheet> createState() => _CupertinoSheetState();
}

class _CupertinoSheetState extends State<CupertinoSheet> {
  @override
  void dispose() {
    if (widget.rescaleScreen ?? true) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.oldContext.read<_SheetProvider>().setIsScaled(false),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Navigator(
          onGenerateRoute: ((_) => MaterialPageRoute(
                builder: (context2) => Builder(
                  builder: (context) => AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Sprung(36),
                    child: Material(
                      color: widget.backgroundColor,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: widget.child,
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

/// Shows the floating sheet.
Future<T> showCupertinoSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  bool useRootNavigator = false,
  Curve? curve,
  bool? isDismissable,
  bool enableDrag = true,
  bool? reScaleScreen,
}) async {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => context.read<_SheetProvider>().setIsScaled(true),
  );
  final result = await showCustomModalBottomSheet(
    isDismissible: isDismissable ?? true,
    context: context,
    builder: builder,
    enableDrag: enableDrag,
    animationCurve: curve ?? Sprung(36),
    duration: const Duration(milliseconds: 500),
    containerWidget: (_, animation, child) => CupertinoSheet(
      backgroundColor: backgroundColor,
      oldContext: context,
      rescaleScreen: reScaleScreen,
      child: child,
    ),
    expand: false,
    useRootNavigator: useRootNavigator,
  );

  return result;
}
