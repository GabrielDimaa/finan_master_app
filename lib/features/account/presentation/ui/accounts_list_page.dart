import 'package:finan_master_app/di/dependency_injection.dart';
import 'package:finan_master_app/features/account/domain/entities/account_entity.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_details_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/account_form_page.dart';
import 'package:finan_master_app/features/account/presentation/ui/components/account_list_tile.dart';
import 'package:finan_master_app/features/account/presentation/view_models/accounts_list_view_model.dart';
import 'package:finan_master_app/shared/classes/form_result_navigation.dart';
import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/app_router.dart';
import 'package:finan_master_app/shared/presentation/ui/components/message_error_widget.dart';
import 'package:finan_master_app/shared/presentation/ui/components/navigation/nav_drawer.dart';
import 'package:finan_master_app/shared/presentation/ui/components/no_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountsListPage extends StatefulWidget {
  static const String route = 'accounts-list';
  static const int indexDrawer = 2;

  const AccountsListPage({Key? key}) : super(key: key);

  @override
  State<AccountsListPage> createState() => _AccountsListPageState();
}

class _AccountsListPageState extends State<AccountsListPage> with ThemeContext {
  final AccountsListViewModel viewModel = DI.get<AccountsListViewModel>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    viewModel.findAll.execute();
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
        child: ListenableBuilder(
          listenable: viewModel.findAll,
          builder: (_, __) {
            if (viewModel.findAll.running) return const Center(child: CircularProgressIndicator());
            if (viewModel.findAll.hasError) return MessageErrorWidget(viewModel.findAll.error.toString());
            if (viewModel.findAll.result?.isEmpty != false) return NoContentWidget(child: Text(strings.noAccountsRegistered));

            return ListView.separated(
              itemCount: viewModel.findAll.result?.length ?? 0,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final AccountEntity account = viewModel.findAll.result![index];
                return Column(
                  children: [
                    AccountListTile(
                      account: account,
                      onTap: () => goAccount(account),
                    ),
                    if (index == viewModel.findAll.result!.length - 1) const SizedBox(height: 50),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> goAccount([AccountEntity? account]) async {
    late final FormResultNavigation<AccountEntity>? result;

    if (account == null) {
      result = await context.pushNamedWithAd(AccountFormPage.route, extra: account);
    } else {
      result = await context.pushNamed(AccountDetailsPage.route, extra: account);
    }

    if (result == null) return;

    viewModel.findAll.execute();
  }
}
