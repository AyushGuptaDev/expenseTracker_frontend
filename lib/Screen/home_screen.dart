import 'package:expense_tracker_with_node/river_pod/expenses_provider.dart';
import 'package:expense_tracker_with_node/river_pod/user_provider.dart';
import 'package:expense_tracker_with_node/widgets/drawer_home.dart';
import 'package:expense_tracker_with_node/widgets/expense_adder.dart';
import 'package:expense_tracker_with_node/widgets/expense_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  Offset _tapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expensesProvider.notifier).fetchExpenses();
    });

    _scrollController.addListener(() {
      final provider = ref.read(expensesProvider);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoading &&
          provider.hasMore) {
        ref.read(expensesProvider.notifier).fetchExpenses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);

    final expenseState = ref.watch(expensesProvider);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Hello ${user!['userName']}')),

        drawer: DrawerHome(),

        body: RefreshIndicator(
          onRefresh: () async {
            ref.read(expensesProvider.notifier).clearAll();
            await Future.delayed(const Duration(milliseconds: 300));
            await ref.read(expensesProvider.notifier).fetchExpenses();
          },
          child: Builder(
            builder: (_) {
              if (expenseState.expenses.isEmpty) {
                if (expenseState.isLoading == true) {
                  return const Center(child: CircularProgressIndicator());
                } else if (expenseState.errorMessage == null) {
                  return const Center(child: Text("No expenses added yet."));
                } else {
                  return Center(
                    child: Text(
                      expenseState.errorMessage ?? "Something went wrong",
                    ),
                  );
                }
              }

              return ListView.builder(
                controller: _scrollController,

                itemCount:
                    expenseState.expenses.length +
                    (expenseState.hasMore ? 1 : 0),

                itemBuilder: (context, index) {
                  if (index < expenseState.expenses.length) {
                    final exp = expenseState.expenses[index];
                    final expenseId = exp['_id'];

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16.0,
                        left: 8,
                        right: 8,
                        top: 3,
                      ),
                      child: GestureDetector(
                        onLongPressStart: (details) {
                          _tapPosition = details.globalPosition;
                          showExpenseOption(
                            context: context,
                            ref: ref,
                            expenseId: expenseId,
                            tapPosition: _tapPosition,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(exp['title']),
                            subtitle: Text(exp['createdAt']),
                            trailing: Text('₹${exp['amount']}'),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ExpenseAdder.showBottomSheet(context, ref);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
