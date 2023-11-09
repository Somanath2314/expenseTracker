// import 'package:expense_track/expenses.dart';
import 'package:expense_track/model/expense.dart';
import 'package:flutter/material.dart';

class newExpenses extends StatefulWidget {
  newExpenses({super.key, required this.onSavedButton});

  Function onSavedButton;
  @override
  State<newExpenses> createState() {
    return _newExpensesState();
  }
}

class _newExpensesState extends State<newExpenses> {
  String inputedValue = '';

  // void onSaved(String value) {
  //   inputedValue = value;
  // }

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  Category onSelectCategory = Category.leisure;
  DateTime? selectedDate;
  void datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void submitExpenses() {
    final enteredAmount = double.tryParse(amountController.text);
    final amountIvalid = enteredAmount == null || enteredAmount <= 0;
    if (titleController.text.trim().isEmpty ||
        amountIvalid ||
        selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid Input"),
                content: const Text(
                    'Please make sure you entered the correct title, amount, date and Category'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("Okay"),
                  )
                ],
              ));
      return;
    }
    widget.onSavedButton(
      Expense(
          title: titleController.text,
          amount: enteredAmount,
          date: selectedDate!,
          category: onSelectCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Widget build(context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyBoardSpace),
              child: Column(
                children: [
                  if (width > 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLength: 50,
                            // onChanged: (){},
                            controller: titleController,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        SizedBox(width: 26),
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixText: '\$ ', label: Text('Amount')),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      maxLength: 50,
                      // onChanged: (){},
                      controller: titleController,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width > 600)
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton(
                            value: onSelectCategory,
                            items: Category.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                onSelectCategory = value;
                              });
                            }),
                        // Spacer(),
                        SizedBox(
                          width: width * 0.61,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(selectedDate == null
                                  ? 'Not selected'
                                  : formatter.format(selectedDate!)),
                              IconButton(
                                  onPressed: datePicker,
                                  icon: const Icon(
                                      Icons.calendar_month_outlined)),
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixText: '\$ ', label: Text('Amount')),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.3,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(selectedDate == null
                                  ? 'Not selected'
                                  : formatter.format(selectedDate!)),
                              IconButton(
                                  onPressed: datePicker,
                                  icon: const Icon(
                                      Icons.calendar_month_outlined)),
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      if (width <= 600)
                        DropdownButton(
                            value: onSelectCategory,
                            items: Category.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                onSelectCategory = value;
                              });
                            }),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 16),
                          )),
                      ElevatedButton(
                        onPressed: () {
                          submitExpenses();
                        },
                        child: const Text(
                          'Save Expense',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
