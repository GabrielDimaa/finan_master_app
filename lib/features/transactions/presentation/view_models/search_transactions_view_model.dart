import 'package:finan_master_app/features/transactions/domain/entities/transaction_search_entity.dart';
import 'package:finan_master_app/features/transactions/domain/use_cases/i_transaction_find.dart';
import 'package:finan_master_app/shared/presentation/commands/command.dart';
import 'package:flutter/foundation.dart';

class TransactionsSearchViewModel extends ChangeNotifier {
  final ITransactionFind _transactionFind;

  late final Command1<void, String> search;

  TransactionsSearchViewModel({
    required ITransactionFind transactionFind,
  }) : _transactionFind = transactionFind {
    search = Command1(_search);
  }

  final int _limit = 50;
  int _offset = 0;
  bool _hasMore = true;

  String _currentText = '';

  final List<TransactionSearchEntity> _items = [];

  List<TransactionSearchEntity> get items => List.unmodifiable(_items);

  Future<void> _search(String text) async {
    if (_currentText.toLowerCase() != text.toLowerCase()) {
      reset();
      _currentText = text;
    }

    if (!_hasMore || text.isEmpty) return;

    final result = await _transactionFind.search(text: text, limit: _limit, offset: _offset);

    _items.addAll(result);
    _offset += result.length;

    if (result.length < _limit) _hasMore = false;
  }

  void reset() {
    _currentText = '';
    _offset = 0;
    _hasMore = true;
    _items.clear();

    notifyListeners();
  }
}
