import 'package:expense_track/Widgets/expenses_item.dart';
import 'package:expense_track/model/expense.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExpensesList extends StatelessWidget {
  ExpensesList({super.key, required this.expenses, required this.removal});
  Function removal;
  List<Expense> expenses;
  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        onDismissed: (direction) {
          removal(expenses[index]);
        },
        key: ValueKey(expenses[index]),
        child: ExpensesItems(expenses[index]),
      ),
    );
  }
}
