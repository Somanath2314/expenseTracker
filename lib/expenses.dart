// ignore_for_file: must_be_immutable

import 'package:expense_track/Widgets/chart.dart';
import 'package:expense_track/Widgets/expenses_list.dart';
import 'package:expense_track/Widgets/new_expenses.dart';
import 'package:expense_track/model/expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({
    super.key,
  });
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  List<Expense> registeredExpenses = [];

  void somethingOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => newExpenses(onSavedButton: addingUp),
    );
  }

  void addingUp(Expense expenseNew) {
    setState(() {
      registeredExpenses.add(expenseNew);
    });
  }

  void removeUp(Expense expensedel) {
    final idxValue = registeredExpenses.indexOf(expensedel);
    setState(() {
      registeredExpenses.remove(expensedel);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Expense Deleted',
          ),
          action: SnackBarAction(
              label: 'Redo',
              onPressed: () {
                setState(() {
                  registeredExpenses.insert(idxValue, expensedel);
                });
              }),
        ),
      );
    });
  }

  @override
  Widget build(context) {
    double width = (MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);

    Widget mainContent = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Text(
          "Great no expenses yet!, Add if you have one:)",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );

    if (registeredExpenses.isNotEmpty)
      mainContent =
          ExpensesList(expenses: registeredExpenses, removal: removeUp);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Flutter Expense Tracker'), actions: [
        IconButton(onPressed: somethingOverlay, icon: Icon(Icons.add)),
      ]),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: registeredExpenses)),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
