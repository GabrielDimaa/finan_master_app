import 'package:collection/collection.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum FinancialInstitutionEnum {
  wallet(0),
  acesso(1),
  agibank(2),
  banrisul(3),
  bb(4),
  bmg(5),
  bnb(6),
  bradesco(7),
  bs2(8),
  c6bank(9),
  caixa(10),
  citibank(11),
  digio(12),
  hsbc(13),
  inter(14),
  itau(15),
  neon(16),
  nubank(17),
  original(18),
  safra(19),
  santander(20),
  xp(21);

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

  Widget icon([double size = 36]) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: switch (this) {
        FinancialInstitutionEnum.wallet => Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(color: Color(0xFF2A7953)),
          child: Icon(Icons.account_balance_wallet_outlined, size: size / 1.5, color: Colors.white),
        ),
        FinancialInstitutionEnum.acesso => SvgPicture.asset('assets/icons/banks/acesso.svg', height: size, width: size),
        FinancialInstitutionEnum.agibank => SvgPicture.asset('assets/icons/banks/agibank.svg', height: size, width: size),
        FinancialInstitutionEnum.banrisul => SvgPicture.asset('assets/icons/banks/banrisul.svg', height: size, width: size),
        FinancialInstitutionEnum.bb => SvgPicture.asset('assets/icons/banks/bb.svg', height: size, width: size),
        FinancialInstitutionEnum.bmg => SvgPicture.asset('assets/icons/banks/bmg.svg', height: size, width: size),
        FinancialInstitutionEnum.bnb => SvgPicture.asset('assets/icons/banks/bnb.svg', height: size, width: size),
        FinancialInstitutionEnum.bradesco => SvgPicture.asset('assets/icons/banks/bradesco.svg', height: size, width: size),
        FinancialInstitutionEnum.bs2 => SvgPicture.asset('assets/icons/banks/bs2.svg', height: size, width: size),
        FinancialInstitutionEnum.c6bank => SvgPicture.asset('assets/icons/banks/c6.svg', height: size, width: size),
        FinancialInstitutionEnum.caixa => SvgPicture.asset('assets/icons/banks/caixa.svg', height: size, width: size),
        FinancialInstitutionEnum.citibank => SvgPicture.asset('assets/icons/banks/citibank.svg', height: size, width: size),
        FinancialInstitutionEnum.digio => SvgPicture.asset('assets/icons/banks/digio.svg', height: size, width: size),
        FinancialInstitutionEnum.hsbc => SvgPicture.asset('assets/icons/banks/hsbc.svg', height: size, width: size),
        FinancialInstitutionEnum.inter => SvgPicture.asset('assets/icons/banks/inter.svg', height: size, width: size),
        FinancialInstitutionEnum.itau => SvgPicture.asset('assets/icons/banks/itau.svg', height: size, width: size),
        FinancialInstitutionEnum.neon => SvgPicture.asset('assets/icons/banks/neon.svg', height: size, width: size),
        FinancialInstitutionEnum.nubank => SvgPicture.asset('assets/icons/banks/nubank.svg', height: size, width: size),
        FinancialInstitutionEnum.original => SvgPicture.asset('assets/icons/banks/original.svg', height: size, width: size),
        FinancialInstitutionEnum.safra => SvgPicture.asset('assets/icons/banks/safra.svg', height: size, width: size),
        FinancialInstitutionEnum.santander => SvgPicture.asset('assets/icons/banks/santander.svg', height: size, width: size),
        FinancialInstitutionEnum.xp => SvgPicture.asset('assets/icons/banks/xp.svg', height: size, width: size),
      },
    );
  }
}
