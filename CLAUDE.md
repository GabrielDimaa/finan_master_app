# CLAUDE.md

Este arquivo orienta o Claude Code (claude.ai/code) ao trabalhar com o código deste repositório.

## Idioma

- Responda ao usuário em português (pt-BR).
- Mensagens de commit, comentários no código, descrições de PR e documentação devem ser escritos em português (pt-BR).
- O código permanece em inglês: nomes de classes, métodos, variáveis, arquivos, pastas, tabelas e colunas do banco de dados.

## Projeto

Finan Master é um app Flutter de finanças pessoais (despesas, receitas, transferências, contas, cartões de crédito e faturas, relatórios). Os dados ficam armazenados localmente em SQLite; o Firebase é usado para autenticação (e-mail/senha e login com Google) e para um registro da conta do usuário no Firestore.

## Comandos

```bash
flutter pub get
flutter run --dart-define-from-file=.env      # .env está no .gitignore; contém FIREBASE_* e AES_KEY/AES_IV
flutter analyze                                 # lints: flutter_lints (ver analysis_options.yaml)
flutter gen-l10n                                # regenera lib/l10n/generated (também roda no build, `generate: true`)
flutter build apk --dart-define-from-file=.env
```

Versão do Flutter: fixada em `.fvmrc` (FVM; use `fvm flutter ...` para usar a versão exata). O `pubspec.yaml` declara a mínima em `environment.flutter`. Ao atualizar o Flutter, atualize os dois.

Não existe pasta `test/`: o projeto não tem testes automatizados no momento.

A configuração vem de defines de compilação lidos em `lib/shared/classes/env.dart` (`String.fromEnvironment`). Rodar sem `--dart-define-from-file=.env` deixa os valores de Firebase/AES vazios. O Android também precisa de `android/app/google-services.json` (fora do git). O banco funciona no Windows via `sqflite_common_ffi`.

## Arquitetura

Clean architecture organizada por feature. Cada `lib/features/<feature>/` tem:

- `domain/`: `entities/`, `enums/`, `repositories/` (interfaces `I*Repository`) e `use_cases/` (cada caso de uso é uma interface `I<Nome>` + implementação, ex.: `IExpenseSave` / `ExpenseSave`).
- `infra/`: `models/` (linhas do banco), `data_sources/` (`I*LocalDataSource` + implementação, baseados em `shared/infra/data_sources/local_data_source.dart`) e `repositories/` (implementações das interfaces do domínio).
- `helpers/`: factories que convertem entre entity e model (`ExpenseFactory.fromEntity/toEntity/newEntity`).
- `presentation/`: páginas/componentes em `ui/` e `view_models/` (ou `notifiers/`).

`lib/shared/` reúne o que é comum entre features: `Entity`/`Model` base, o wrapper do SQLite, drivers (anúncios, auth, criptografia AES, file picker, compartilhamento), o router, tema/locale e componentes de UI reutilizáveis.

### Peças transversais

- **Injeção de dependência**: `lib/di/dependency_injection.dart` registra tudo no `get_it` (acessado via `DI.get<T>()`). Todo novo data source, repository, use case ou view model precisa ser registrado ali. O `setup()` também inicializa Firebase, SQLite e SharedPreferences; o `reset()` do `main.dart` descarta o DI e reinicia o app (usado após restaurar backup/logout).
- **View models + Commands**: view models são `ChangeNotifier`s que expõem ações assíncronas como `Command0` / `Command1` (`lib/shared/presentation/commands/command.dart`), que controlam `running`/`error`/`completed`/`result`. As páginas obtêm o view model via `DI.get<...>()` e reconstroem com `ListenableBuilder`.
- **EventNotifier** (`shared/presentation/notifiers/event_notifier.dart`): singleton global; os repositories chamam `notify(EventType.x)` após gravações para que outras telas (home, listagens) recarreguem.
- **Banco local**: `shared/infra/data_sources/database_local/database_local.dart` é o singleton do sqflite. A versão do schema é `_version`; `_onCreate` pede a cada data source local que execute `createTable(batch)`, e `_onUpgrade` contém migrations incrementais `if (oldVersion < N)`. Alterar o schema exige incrementar `_version`, atualizar o `createTable` do data source e adicionar um passo de migration. Os nomes das tabelas ficam em `shared/infra/data_sources/constants/tables_names_constant.dart`.
- **Transações do banco**: métodos de escrita de repositories/data sources aceitam um `ITransactionExecutor? txn` opcional. Operações com vários passos abrem uma transação via `IDatabaseLocalTransaction.openTransaction` / `ILocalDBTransactionRepository` e repassam o `txn`; quando `txn == null`, os métodos geralmente chamam a si mesmos dentro de uma nova transação.
- **Extrato (statements)**: o saldo das contas é calculado a partir das linhas de `statement` criadas junto com receitas/despesas/transferências/pagamentos de fatura (`features/statement`), e não armazenado na conta.
- **Backup/restauração**: o backup copia o arquivo do SQLite (`IDatabaseLocal.getFileDatabase`) e o compartilha; a restauração substitui o arquivo do banco e o app é reiniciado.
- **Rotas**: `go_router`, configurado em `shared/presentation/ui/app_router.dart`.
- **Localização**: arquivos ARB em `lib/l10n` (`app_en.arb` é o template, além de `app_pt.arb`); código gerado em `lib/l10n/generated`. Em widgets use `strings` do mixin `ThemeContext`; fora de widgets use `AppLocale.strings`. Toda string nova deve ser adicionada aos dois arquivos ARB.
