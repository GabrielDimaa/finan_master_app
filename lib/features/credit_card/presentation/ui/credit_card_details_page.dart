import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_app_bar.dart';
import 'package:finan_master_app/shared/presentation/ui/components/sliver/sliver_scaffold.dart';
import 'package:flutter/material.dart';

class CreditCardDetailsPage extends StatefulWidget {
  static const route = 'credit-card-details';

  final CreditCardEntity creditCard;

  const CreditCardDetailsPage({Key? key, required this.creditCard}) : super(key: key);

  @override
  State<CreditCardDetailsPage> createState() => _CreditCardDetailsPageState();
}

class _CreditCardDetailsPageState extends State<CreditCardDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      appBar: SliverAppBarMedium(
        title: Text('Descrição do cartão'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // MonthlyFilter(
            //   startDate: widget.notifier.startDate,
            //   onChange: (DateTime date) => widget.notifier.findByPeriod(date.getInitialMonth(), date.getFinalMonth()),
            // ),
          ],
        ),
      ),
    );
  }
}
