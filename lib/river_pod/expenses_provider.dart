import 'package:expense_tracker_with_node/api_calls/expense_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesState {
  final List<Map<String, dynamic>> expenses;
  final bool isLoading;
  final bool hasMore;
  final String? nextCursor;
  final String? errorMessage;

  ExpensesState({
    required this.expenses,
    this.isLoading = false,
    this.hasMore = true,
    this.nextCursor,
    this.errorMessage,
  });

  ExpensesState copyWith({
    List<Map<String, dynamic>>? expenses,
    bool? isLoading,
    bool? hasMore,
    String? nextCursor,
    String? errorMessage,
  }) {
    return ExpensesState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ExpensesNotifier extends StateNotifier<ExpensesState> {
  final Ref ref;

  ExpensesNotifier(this.ref) : super(ExpensesState(expenses: []));

  Future<void> fetchExpenses() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final data = await ExpenseCaller.showExpense(cursor: state.nextCursor);

      final List<dynamic> expensesList = data['expenses'] ?? [];

      if (expensesList.isNotEmpty) {
        final List<Map<String, dynamic>> newExpenses =
            List<Map<String, dynamic>>.from(data['expenses']).toList();

        state = state.copyWith(
          expenses: [...state.expenses, ...newExpenses],
          hasMore: data['hasMore'],
          nextCursor: data['nextCursor'],
          isLoading: false,
          errorMessage: null,
        );
        print("expense length ${expensesList.length}  ${state.nextCursor}");
        print("hasmmoe ${data['hasMore']}");
      } else {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
          errorMessage: data['message'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      state = state.copyWith(
        isLoading: false,
        hasMore: false,
        errorMessage: "Failed to fetch expenses: $e",
      );
    }
  }

  Future<void> addExpense(Map<String, dynamic> expense) async {
    state = state.copyWith(expenses: [expense, ...state.expenses]);
  }

  Future<void> deleteExpense(String id) async {
    final updatedExpenses =
        state.expenses.where((e) => e['_id'].toString() != id).toList();
    state = state.copyWith(expenses: updatedExpenses);
  }

  Future<void> clearAll() async {
    state = ExpensesState(expenses: []);
  }
}

final expensesProvider = StateNotifierProvider<ExpensesNotifier, ExpensesState>(
  (ref) {
    return ExpensesNotifier(ref);
  },
);
