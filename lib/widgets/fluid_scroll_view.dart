import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'scroll_vel_listener.dart' as sui;

/// A [ScrollView] that animates the space between the widgets
/// as you scroll. Trying to replicate the effect seen when
/// scrolling on the iMessage app in iOS.
/// [velocityFactor] controls how much the spacing gets dampened.
/// Therefore, a higher [velocityFactor] will result in a more
/// subtle effect.
class FluidScrollView extends StatefulWidget {
  const FluidScrollView({
    super.key,
    required this.children,
    this.spacing = 16,
    this.velocityFactor,
    this.controller,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final double spacing;
  final int? velocityFactor;
  final ScrollController? controller;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<FluidScrollView> createState() => FluidScrollViewState();
}

class FluidScrollViewState extends State<FluidScrollView> {
  // storing the relative velocity
  late double _scrollVelocity;
  // list of widget keys that are visible
  late final List<String> _visibility;
  // velocity factor to dampen the scroll velocity with
  late int _velFactor;
  // ability to pass in custom controller
  late ScrollController _controller;

  @override
  void initState() {
    _scrollVelocity = 0;
    _visibility = [];
    // set the correct velocity factor
    if (widget.velocityFactor == null) {
      _velFactor = 300;
    } else {
      _velFactor = widget.velocityFactor!;
    }
    if (widget.controller == null) {
      _controller = ScrollController();
    } else {
      _controller = widget.controller!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return sui.ScrollVelocityListener(
      onVelocity: (vel) {
        setState(() {
          _scrollVelocity = vel / _velFactor;
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            crossAxisAlignment: widget.crossAxisAlignment,
            children: [
              for (int i = 0; i < widget.children.length; i++)
                _ScrollCell(
                  index: i,
                  scrollVelocity: _scrollVelocity,
                  visibility: _visibility,
                  spacing: widget.spacing,
                  child: widget.children[i],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// cell for controlling the offset of the widget
class _ScrollCell extends StatefulWidget {
  const _ScrollCell({
    super.key,
    required this.index,
    required this.scrollVelocity,
    required this.visibility,
    required this.child,
    required this.spacing,
  });
  final int index;
  final double scrollVelocity;
  final List<String> visibility;
  final Widget child;
  final double spacing;

  @override
  State<_ScrollCell> createState() => _ScrollCellState();
}

class _ScrollCellState extends State<_ScrollCell> {
  late final ValueKey _key;

  @override
  void initState() {
    _key = ValueKey(widget.index);
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: ((info) {
        if (info.size.height >= 0) {
          // get the visibility fraction
          var visiblePercentage = info.visibleFraction;
          if (visiblePercentage == 0) {
            // remove the widget key from the visible list
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                if (mounted) {
                  setState(() {
                    widget.visibility.removeWhere(
                        (element) => element == info.key.toString());
                  });
                }
              },
            );
          } else {
            // add the widget key to the visible list
            if (!widget.visibility.contains(info.key.toString())) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  if (mounted) {
                    setState(() {
                      widget.visibility.add(info.key.toString());
                    });
                  }
                },
              );
            }
          }
        }
        // sort the list based on the index of the widget
        widget.visibility.sort((a, b) {
          var na = a.replaceAll(RegExp(r'[^0-9]'), '');
          var nb = b.replaceAll(RegExp(r'[^0-9]'), '');
          var ia = int.parse(na);
          var ib = int.parse(nb);
          return ia.compareTo(ib);
        });
      }),
      child: Padding(
        padding: EdgeInsets.only(bottom: widget.spacing),
        child: AnimatedSlide(
          // offset the widget y value by the velocity
          // times the index the widget key is in the visibility
          // list. So, widgets near the bottom of the viewport will
          // have a larger offset than the top.
          offset: Offset(
              0,
              widget.scrollVelocity *
                  widget.visibility.indexOf(_key.toString())),
          duration: const Duration(milliseconds: 400),
          curve: Sprung(50),
          child: widget.child,
        ),
      ),
    );
  }
}
