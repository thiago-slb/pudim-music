import 'dart:io';

import 'package:flutter/widgets.dart';

/// Tela estreita (celular): barra de baixo, mini player e páginas em uma coluna.
bool isCompact(BuildContext context) => MediaQuery.sizeOf(context).width < 700;

/// Janela própria (barra de título, minimizar, fechar).
bool get isDesktop =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;
