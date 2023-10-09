import 'package:finan_master_app/features/credit_card/domain/entities/credit_card_entity.dart';
import 'package:finan_master_app/features/credit_card/presentation/notifiers/credit_cards_notifier.dart';
import 'package:finan_master_app/features/credit_card/presentation/states/credit_cards_state.dart';
import 'package:finan_master_app/features/credit_card/presentation/ui/credit_card_form_page.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/extensions/double_extension.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class CreditCardsPage extends StatefulWidget {
  static const String route = 'credit-cards';
  static const int indexDrawer = 1;

  const CreditCardsPage({Key? key}) : super(key: key);

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> with ThemeContext {
  final CreditCardsNotifier notifier = GetIt.I.get<CreditCardsNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: strings.menu,
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(strings.creditCards),
        centerTitle: true,
      ),
      drawer: const NavDrawer(selectedIndex: CreditCardsPage.indexDrawer),
      floatingActionButton: FloatingActionButton(
        tooltip: strings.createCreditCard,
        onPressed: goCreditCard,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (_, CreditCardsState state, __) {
            return switch (state) {
              LoadingCreditCardsState _ => const Center(child: CircularProgressIndicator()),
              ErrorCreditCardsState _ => Text(state.message),
              EmptyCreditCardsState _ => NoContentWidget(child: Text(strings.noCreditCardRegistered)),
              StartCreditCardsState _ => const SizedBox.shrink(),
              ListCreditCardsState state => ListView.separated(
                  itemCount: state.creditCards.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    final CreditCardEntity creditCard = state.creditCards[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(creditCard.description),
                          subtitle: Text('${strings.limit}: ${creditCard.amountLimit.money}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => goCreditCard(creditCard),
                        ),
                        if (index == state.creditCards.length - 1) const SizedBox(height: 50),
                      ],
                    );
                  },
                ),
            };
          },
        ),
      ),
    );
  }

  Future<void> goCreditCard([CreditCardEntity? creditCard]) async {
    final FormResultNavigation<CreditCardEntity>? result = await context.pushNamed(CreditCardFormPage.route, extra: creditCard);

    if (result == null) return;

    notifier.findAll();
  }
}
