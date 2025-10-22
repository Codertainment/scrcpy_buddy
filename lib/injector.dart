import 'package:process/process.dart';
import 'package:provider/provider.dart';
import 'package:scrcpy_buddy/service/adb_service.dart';

import 'application/adb_result_parser.dart';

List<Provider> get providers => [
  Provider<ProcessManager>(create: (_) => const LocalProcessManager()),
  Provider<AdbResultParser>(create: (_) => AdbResultParser()),

  // For AdbService, which depends on ProcessManager and AdbResultParser.
  // We use `context.read<T>()` to get the dependencies from other providers.
  Provider<AdbService>(
    create: (context) => AdbService(
      context.read<ProcessManager>(),
      context.read<AdbResultParser>(),
    ),
  ),
];