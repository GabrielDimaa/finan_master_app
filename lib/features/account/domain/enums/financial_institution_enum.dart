import 'package:collection/collection.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum FinancialInstitutionEnum {
  wallet(0),
  acesso(1),
  agibank(2),
  sicoob(3),
  bb(4),
  bmg(5),
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
  xp(21),
  mercadoPago(22);

  final int value;

  const FinancialInstitutionEnum(this.value);

  static FinancialInstitutionEnum? getByValue(int value) => FinancialInstitutionEnum.values.firstWhereOrNull((v) => v.value == value);
}

extension FinancialInstitutionExtension on FinancialInstitutionEnum {
  String get description => switch (this) {
        FinancialInstitutionEnum.wallet => R.strings.wallet,
        FinancialInstitutionEnum.acesso => 'Acesso',
        FinancialInstitutionEnum.agibank => 'Agibank',
        FinancialInstitutionEnum.sicoob => 'Sicoob',
        FinancialInstitutionEnum.bb => 'Banco do Brasil',
        FinancialInstitutionEnum.bmg => 'bmg',
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
        FinancialInstitutionEnum.mercadoPago => 'Mercado Pago',
      };

  Widget icon([double size = 36]) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        color: backgroundColor,
        child: switch (this) {
          FinancialInstitutionEnum.wallet => SizedBox(
              height: size,
              width: size,
              child: Icon(Icons.account_balance_wallet_outlined, size: size / 1.5, color: Colors.white),
            ),
          FinancialInstitutionEnum.acesso => SvgPicture.asset('assets/icons/banks/acesso.svg', height: size, width: size),
          FinancialInstitutionEnum.agibank => SvgPicture.asset('assets/icons/banks/agibank.svg', height: size, width: size),
          FinancialInstitutionEnum.sicoob => SvgPicture.asset('assets/icons/banks/sicoob.svg', height: size, width: size),
          FinancialInstitutionEnum.bb => SvgPicture.asset('assets/icons/banks/bb.svg', height: size, width: size),
          FinancialInstitutionEnum.bmg => SvgPicture.asset('assets/icons/banks/bmg.svg', height: size, width: size),
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
          FinancialInstitutionEnum.mercadoPago => SvgPicture.asset('assets/icons/banks/mercado-pago.svg', height: size, width: size),
        },
      ),
    );
  }

  Color get backgroundColor => switch (this) {
        FinancialInstitutionEnum.wallet => const Color(0xFF2A7953),
        FinancialInstitutionEnum.acesso => Colors.white,
        FinancialInstitutionEnum.agibank => const Color(0xFF266BFF),
        FinancialInstitutionEnum.sicoob => const Color(0xFF003641),
        FinancialInstitutionEnum.bb => const Color(0xFFFDE100),
        FinancialInstitutionEnum.bmg => const Color(0xFFFF6300),
        FinancialInstitutionEnum.bradesco => const Color(0xFFCC092F),
        FinancialInstitutionEnum.bs2 => const Color(0xFF3333CC),
        FinancialInstitutionEnum.c6bank => const Color(0xFF1F1F1F),
        FinancialInstitutionEnum.caixa => const Color(0xFF0070AF),
        FinancialInstitutionEnum.citibank => const Color(0xFF003B70),
        FinancialInstitutionEnum.digio => const Color(0xFF02306A),
        FinancialInstitutionEnum.hsbc => Colors.white,
        FinancialInstitutionEnum.neon => const Color(0xFF01B0EB),
        FinancialInstitutionEnum.nubank => const Color(0xFF8200E9),
        FinancialInstitutionEnum.original => const Color(0xFF048630),
        FinancialInstitutionEnum.safra => const Color(0xFF3C4886),
        FinancialInstitutionEnum.santander => const Color(0xFFEC0000),
        FinancialInstitutionEnum.inter => const Color(0xFFFF8700),
        FinancialInstitutionEnum.xp => const Color(0xFF000000),
        _ => Colors.white,
      };

  Color get creditCardBackgroundColor => switch (this) {
        FinancialInstitutionEnum.wallet => const Color(0xFF2A7953),
        FinancialInstitutionEnum.acesso => const Color(0xFF6C6C6C),
        FinancialInstitutionEnum.agibank => const Color(0xFF266BFF),
        FinancialInstitutionEnum.sicoob => const Color(0xFF003641),
        FinancialInstitutionEnum.bb => const Color(0xFFFDE100),
        FinancialInstitutionEnum.bmg => const Color(0xFFFF6300),
        FinancialInstitutionEnum.bradesco => const Color(0xFFCC092F),
        FinancialInstitutionEnum.bs2 => const Color(0xFF3333CC),
        FinancialInstitutionEnum.c6bank => const Color(0xFF1F1F1F),
        FinancialInstitutionEnum.caixa => const Color(0xFF0070AF),
        FinancialInstitutionEnum.citibank => const Color(0xFF003B70),
        FinancialInstitutionEnum.digio => const Color(0xFF02306A),
        FinancialInstitutionEnum.hsbc => const Color(0xFF4A426A),
        FinancialInstitutionEnum.neon => const Color(0xFF01B0EB),
        FinancialInstitutionEnum.nubank => const Color(0xFF8200E9),
        FinancialInstitutionEnum.original => const Color(0xFF048630),
        FinancialInstitutionEnum.safra => const Color(0xFF3C4886),
        FinancialInstitutionEnum.santander => const Color(0xFFEC0000),
        FinancialInstitutionEnum.inter => const Color(0xFFFF8700),
        FinancialInstitutionEnum.xp => const Color(0xFF000000),
        FinancialInstitutionEnum.mercadoPago => const Color(0xFF242A38),
        _ => Colors.white,
      };

  Color get creditCardOnBackgroundColor => switch (this) {
        FinancialInstitutionEnum.bb => const Color(0xFF003882),
        FinancialInstitutionEnum.c6bank => const Color(0xFFF4F4F4),
        FinancialInstitutionEnum.citibank => const Color(0xFFE3E4E6),
        _ => Colors.white,
      };
}
