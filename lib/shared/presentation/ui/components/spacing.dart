import 'package:flutter/widgets.dart';

class Spacing extends SizedBox {
  static const double space = 12;

  const Spacing.x([double qtd = 1])
      : assert(qtd > 0),
        super(width: space * qtd, key: null);

  const Spacing.y([double qtd = 1])
      : assert(qtd > 0),
        super(height: space * qtd, key: null);
}
