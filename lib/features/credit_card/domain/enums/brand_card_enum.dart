import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CardBrandEnum {
  alelo(1),
  americanExpress(2),
  banescard(3),
  visa(4),
  cabal(5),
  dinersClub(6),
  elo(7),
  goodcard(8),
  hipercard(9),
  jcb(10),
  mastercard(11),
  sorocred(12);

  final int value;

  const CardBrandEnum(this.value);

  static CardBrandEnum? getByValue(int? value) => CardBrandEnum.values.firstWhereOrNull((v) => v.value == value);
}

extension CardBrandExtension on CardBrandEnum {
  String get description => switch (this) {
    CardBrandEnum.alelo => 'Alelo',
    CardBrandEnum.americanExpress => 'American Express',
    CardBrandEnum.banescard => 'Banescard',
    CardBrandEnum.cabal => 'Cabal',
    CardBrandEnum.dinersClub => 'Diners Club',
    CardBrandEnum.elo => 'Elo',
    CardBrandEnum.goodcard => 'Good Card',
    CardBrandEnum.hipercard => 'Hipercard',
    CardBrandEnum.jcb => 'JCB',
    CardBrandEnum.mastercard => 'Mastercard',
    CardBrandEnum.sorocred => 'Sorocred',
    CardBrandEnum.visa => 'Visa',
  };

  Widget icon([double size = 36]) {
    return switch (this) {
      CardBrandEnum.alelo => SvgPicture.asset('assets/icons/card-brands/alelo.svg', height: size, width: size),
      CardBrandEnum.americanExpress => SvgPicture.asset('assets/icons/card-brands/americanexpress.svg', height: size, width: size),
      CardBrandEnum.banescard => SvgPicture.asset('assets/icons/card-brands/banescard.svg', height: size, width: size),
      CardBrandEnum.cabal => SvgPicture.asset('assets/icons/card-brands/cabal.svg', height: size, width: size),
      CardBrandEnum.dinersClub => SvgPicture.asset('assets/icons/card-brands/dinersclub.svg', height: size, width: size),
      CardBrandEnum.elo => SvgPicture.asset('assets/icons/card-brands/elo.svg', height: size, width: size),
      CardBrandEnum.goodcard => SvgPicture.asset('assets/icons/card-brands/goodcard.svg', height: size, width: size),
      CardBrandEnum.hipercard => SvgPicture.asset('assets/icons/card-brands/hipercard.svg', height: size, width: size),
      CardBrandEnum.jcb => SvgPicture.asset('assets/icons/card-brands/jcb.svg', height: size, width: size),
      CardBrandEnum.mastercard => SvgPicture.asset('assets/icons/card-brands/mastercard.svg', height: size, width: size),
      CardBrandEnum.sorocred => SvgPicture.asset('assets/icons/card-brands/sorocred.svg', height: size, width: size),
      CardBrandEnum.visa => SvgPicture.asset('assets/icons/card-brands/visa.svg', height: size, width: size),
    };
  }
}