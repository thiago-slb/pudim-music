import 'dart:io';

import 'package:flutter/widgets.dart';

/// Narrow screen (phone): bottom bar, mini player and single-column pages.
bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < 700;

/// Own window (title bar, minimize, close).
bool get isDesktop =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;
