import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateWiseExpenseProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {},
);

void clearDateWiseExpense(WidgetRef ref) {
  ref.read(dateWiseExpenseProvider.notifier).update((state) => {});
}
