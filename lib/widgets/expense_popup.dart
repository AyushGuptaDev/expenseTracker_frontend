import 'package:expense_tracker_with_node/api_calls/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showExpenseOption({
  required BuildContext context,
  required WidgetRef ref,
  required String expenseId,
  required Offset tapPosition,
}) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final selected = await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(tapPosition, tapPosition),
      Offset.zero & overlay.size,
    ),

    items: [PopupMenuItem(value: 'delete', child: Text("Delete Expense"))],
  );

  if (!context.mounted) return;

  if (selected != null && selected == "delete") {
    Expense.deleteExpense(context: context, ref: ref, expenseId: expenseId);
  }
}
