import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/printing/application/providers/usecases/scan_printers_usecases_providers.dart';
import 'package:treintaypico/features/printing/application/usecases/print_ticket_usecase.dart';

final printActionProvider = StateProvider<AsyncValue<void>>(
  (_) => const AsyncData(null),
);

Future<void> runPrintAction(WidgetRef ref, PrintTicketParams params) async {
  final usecase = ref.read(printTicketUsecaseProvider);
  ref.read(printActionProvider.notifier).state = const AsyncLoading();

  final result = await usecase(params);
  result.fold(
    (Failure f) => ref.read(printActionProvider.notifier).state = AsyncError(
      f,
      StackTrace.current,
    ),
    (_) => ref.read(printActionProvider.notifier).state = const AsyncData(null),
  );
}


//TODO: runPrintAction(ref, params) desde la UI (o expone un método que internamente llame a ese helper).
// La UI escucha printActionProvider para mostrar un spinner en el botón
// y un snackbar en success/error, sin perder la lista en pantalla.