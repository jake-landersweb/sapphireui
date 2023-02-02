import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'root.dart' as cv;

class Navigate extends Navigator {
  Navigate(BuildContext context, Widget body,
      {super.key, bool? maintainState}) {
    if (kIsWeb) {
      Navigator.of(context).push(
        MaterialPageRoute(
          maintainState: maintainState ?? true,
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: body,
          ),
        ),
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          maintainState: maintainState ?? true,
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: body,
          ),
        ),
      );
    } else {
      // android, windows and linux
      Navigator.of(context).push(
        MaterialPageRoute(
          maintainState: maintainState ?? true,
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: body,
          ),
        ),
      );
    }
  }
}
