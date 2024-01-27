import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/presentation/notifiers/accounts_notifier.dart';
import 'package:finan_master_app/features/account/presentation/states/accounts_state.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_details_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_form_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/account_list_tile.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AccountsListPage extends StatefulWidget {
  static const String route = 'accounts-list';
  static const int indexDrawer = 2;

  const AccountsListPage({Key? key}) : super(key: key);

  @override
  State<AccountsListPage> createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> with ThemeContext {
  final AccountsNotifier notifier = GetIt.I.get<AccountsNotifier>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    notifier.findAll();
  }

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
        title: Text(strings.accounts),
        centerTitle: true,
      ),
      drawer: const NavDrawer(selectedIndex: AccountsListPage.indexDrawer),
      floatingActionButton: FloatingActionButton(
        tooltip: strings.createAccount,
        onPressed: goAccount,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: notifier,
          builder: (_, AccountsState state, __) {
            return switch (state) {
              LoadingAccountsState _ => const Center(child: CircularProgressIndicator()),
              ErrorAccountsState _ => MessageErrorWidget(state.message),
              EmptyAccountsState _ => NoContentWidget(child: Text(strings.noAccountsRegistered)),
              StartAccountsState _ => const SizedBox.shrink(),
              ListAccountsState state => ListView.separated(
                  itemCount: state.accounts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    final AccountEntity account = state.accounts[index];
                    return Column(
                      children: [
                        AccountListTile(
                          account: account,
                          onTap: () => goAccount(account),
                        ),
                        if (index == state.accounts.length - 1) const SizedBox(height: 50),
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

  Future<void> goAccount([AccountEntity? account]) async {
    late final FormResultNavigation<AccountEntity>? result;

    if (account == null) {
      result = await context.pushNamed(AccountFormPage.route, extra: account);
    } else {
      result = await context.pushNamed(AccountDetailsPage.route, extra: account);
    }

    if (result == null) return;

    notifier.findAll();
  }
}
