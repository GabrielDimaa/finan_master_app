import 'package:collection/collection.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum FinancialInstitutionEnum {
  wallet(0),
  acesso(1),
  agibank(1),
  banrisul(1),
  bb(1),
  bmg(1),
  bnb(1),
  bradesco(1),
  bs2(1),
  c6bank(1),
  caixa(1),
  citibank(1),
  digio(9),
  hsbc(8),
  inter(7),
  itau(6),
  neon(5),
  nubank(2),
  original(4),
  safra(3),
  santander(3),
  xp(3);

  final int value;

  const FinancialInstitutionEnum(this.value);

  static FinancialInstitutionEnum? getByValue(int value) => FinancialInstitutionEnum.values.firstWhereOrNull((v) => v.value == value);
}

extension FinancialInstitutionExtension on FinancialInstitutionEnum {
  String get description => switch (this) {
        FinancialInstitutionEnum.wallet => R.strings.wallet,
        FinancialInstitutionEnum.acesso => 'Acesso',
        FinancialInstitutionEnum.agibank => 'Agibank',
        FinancialInstitutionEnum.banrisul => 'Banrisul',
        FinancialInstitutionEnum.bb => 'Banco do Brasil',
        FinancialInstitutionEnum.bmg => 'bmg',
        FinancialInstitutionEnum.bnb => 'Banco do Nordeste',
        FinancialInstitutionEnum.bradesco => 'Bradesco',
        FinancialInstitutionEnum.bs2 => 'BS2',
        FinancialInstitutionEnum.c6bank => 'C6 Bank',
        FinancialInstitutionEnum.caixa => 'Caixa',
        FinancialInstitutionEnum.citibank => 'Citibank',
        FinancialInstitutionEnum.digio => 'Digio',
        FinancialInstitutionEnum.hsbc => 'HSBC',
        FinancialInstitutionEnum.inter => 'Banco Inter',
        FinancialInstitutionEnum.itau => 'Itaú',
        FinancialInstitutionEnum.neon => 'Neon',
        FinancialInstitutionEnum.nubank => 'Nubank',
        FinancialInstitutionEnum.original => 'Original',
        FinancialInstitutionEnum.safra => 'Safra',
        FinancialInstitutionEnum.santander => 'Santander',
        FinancialInstitutionEnum.xp => 'XP',
      };

  Widget get icon => switch (this) {
        FinancialInstitutionEnum.wallet => const Icon(Icons.account_balance_wallet_outlined),
        FinancialInstitutionEnum.acesso => SvgPicture.asset('assets/icons/acesso.svg'),
        FinancialInstitutionEnum.agibank => SvgPicture.asset('assets/icons/agibank.svg'),
        FinancialInstitutionEnum.banrisul => SvgPicture.asset('assets/icons/banrisul.svg'),
        FinancialInstitutionEnum.bb => SvgPicture.asset('assets/icons/bb.svg'),
        FinancialInstitutionEnum.bmg => SvgPicture.asset('assets/icons/bmg.svg'),
        FinancialInstitutionEnum.bnb => SvgPicture.asset('assets/icons/bnb.svg'),
        FinancialInstitutionEnum.bradesco => SvgPicture.asset('assets/icons/bradesco.svg'),
        FinancialInstitutionEnum.bs2 => SvgPicture.asset('assets/icons/bs2.svg'),
        FinancialInstitutionEnum.c6bank => SvgPicture.asset('assets/icons/c6.svg'),
        FinancialInstitutionEnum.caixa => SvgPicture.asset('assets/icons/caixa.svg'),
        FinancialInstitutionEnum.citibank => SvgPicture.asset('assets/icons/citibank.svg'),
        FinancialInstitutionEnum.digio => SvgPicture.asset('assets/icons/digio.svg'),
        FinancialInstitutionEnum.hsbc => SvgPicture.asset('assets/icons/hsbc.svg'),
        FinancialInstitutionEnum.inter => SvgPicture.asset('assets/icons/inter.svg'),
        FinancialInstitutionEnum.itau => SvgPicture.asset('assets/icons/itau.svg'),
        FinancialInstitutionEnum.neon => SvgPicture.asset('assets/icons/neon.svg'),
        FinancialInstitutionEnum.nubank => SvgPicture.asset('assets/icons/nubank.svg'),
        FinancialInstitutionEnum.original => SvgPicture.asset('assets/icons/original.svg'),
        FinancialInstitutionEnum.safra => SvgPicture.asset('assets/icons/safra.svg'),
        FinancialInstitutionEnum.santander => SvgPicture.asset('assets/icons/santander.svg'),
        FinancialInstitutionEnum.xp => SvgPicture.asset('assets/icons/xp.svg'),
      };
}
