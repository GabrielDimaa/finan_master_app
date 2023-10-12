sealed class BackupState {
  const BackupState();

  factory BackupState.start() => const StartBackupState();

  BackupState setLoading() => const LoadingBackupState();

  BackupState setFinalized() => const FinalizedBackupState();

  BackupState setError(String message) => ErrorBackupState(message);
}

class StartBackupState extends BackupState {
  const StartBackupState();
}

class LoadingBackupState extends BackupState {
  const LoadingBackupState();
}

class FinalizedBackupState extends BackupState {
  const FinalizedBackupState();
}

class ErrorBackupState extends BackupState {
  final String message;

  const ErrorBackupState(this.message);
}
