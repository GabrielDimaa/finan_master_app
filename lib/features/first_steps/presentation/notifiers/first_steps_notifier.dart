import 'package:finan_master_app/features/first_steps/domain/entities/first_steps_entity.dart';
import 'package:finan_master_app/features/first_steps/domain/use_Cases/i_first_steps_find.dart';
import 'package:finan_master_app/features/first_steps/domain/use_Cases/i_first_steps_save.dart';
import 'package:finan_master_app/features/first_steps/helpers/first_steps_factory.dart';
import 'package:finan_master_app/shared/presentation/notifiers/event_notifier.dart';
import 'package:flutter/foundation.dart';

class FirstStepsNotifier extends ValueNotifier<FirstStepsEntity> {
  final IFirstStepsFind _firstStepsFind;
  final IFirstStepsSave _firstStepsSave;
  final EventNotifier _eventNotifier;

  FirstStepsNotifier({
    required IFirstStepsFind firstStepsFind,
    required IFirstStepsSave firstStepsSave,
    required EventNotifier eventNotifier,
  })  : _firstStepsFind = firstStepsFind,
        _firstStepsSave = firstStepsSave,
        _eventNotifier = eventNotifier,
        super(FirstStepsFactory.newEntity()) {
    _eventNotifier.addListener(onEvents);
    addListener(onListener);
  }

  Future<void> find() async => value = await _firstStepsFind.find() ?? value;

  Future<void> save() async => value = await _firstStepsSave.save(value);

  void onListener() {
    if (value.done) {
      _eventNotifier.removeListener(onEvents);
      removeListener(onListener);
    }
  }

  void onEvents() {
    if (_eventNotifier.value == EventType.expense && !value.expenseStepDone) {
      value.expenseStepDone = true;
      save();
    }

    if (_eventNotifier.value == EventType.income && !value.incomeStepDone) {
      value.incomeStepDone = true;
      save();
    }

    if (_eventNotifier.value == EventType.account && !value.accountStepDone) {
      value.accountStepDone = true;
      save();
    }

    if (_eventNotifier.value == EventType.creditCard && !value.creditCardStepDone) {
      value.creditCardStepDone = true;
      save();
    }
  }
}
