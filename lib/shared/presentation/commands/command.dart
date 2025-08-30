import 'dart:async';
import 'package:flutter/foundation.dart';

/// Defines a command action that returns a  type [T].
/// Used by [Command0] for actions without arguments.
typedef CommandAction0<T> = Future<T> Function();

/// Defines a command action that returns a type [T].
/// Takes an argument of type [A].
/// Used by [Command1] for actions with one argument.
typedef CommandAction1<T, A> = Future<T> Function(A);

/// Facilitates interaction with a view model.
///
/// Encapsulates an action,
/// exposes its running and error states,
/// and ensures that it can't be launched again until it finishes.
///
/// Use [Command0] for actions without arguments.
/// Use [Command1] for actions with one argument.
///
/// Actions must return a type [T].
///
/// Consume the action result by listening to changes,
/// then call to [clearResult] when the state is consumed.
abstract class Command<T> extends ChangeNotifier {
  bool _running = false;

  Exception? _error;

  bool _completed = false;

  T? _result;

  /// Whether the action is running.
  bool get running => _running;

  /// Whether the action completed with an error.
  bool get hasError => _error != null;

  Exception? get error => _error;

  /// Whether the action completed successfully.
  bool get completed => _completed;

  /// The result of the most recent action.
  ///
  /// Returns `null` if the action is running or completed with an error.
  T? get result => _result;

  void throwIfError() {
    if (hasError) throw error!;
  }

  /// Clears the most recent action's result.
  void clearResult() {
    _result = null;
    _completed = false;
    notifyListeners();
  }

  /// Execute the provided [action], notifying listeners and
  /// setting the running and result states as necessary.
  Future<void> _execute(CommandAction0<T> action) async {
    // Ensure the action can't launch multiple times.
    // e.g. avoid multiple taps on button
    if (_running) return;

    // Notify listeners.
    // e.g. button shows loading state
    _running = true;
    _completed = false;
    _error = null;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
      _completed = true;
    } on Exception catch (e) {
      _error = e;
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// A [Command] that accepts no arguments.
final class Command0<T> extends Command<T> {
  /// Creates a [Command0] with the provided [CommandAction0].
  Command0(this._action);

  final CommandAction0<T> _action;

  /// Executes the action.
  Future<void> execute() async {
    await _execute(() => _action());
  }
}

/// A [Command] that accepts one argument.
final class Command1<T, A> extends Command<T> {
  /// Creates a [Command1] with the provided [CommandAction1].
  Command1(this._action);

  final CommandAction1<T, A> _action;

  /// Executes the action with the specified [argument].
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}