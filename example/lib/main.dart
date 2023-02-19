import 'package:flutter/material.dart';

import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MultiSelect Dropdown demo',
      home: MultiSelectExample(),
    );
  }
}

class MultiSelectExample extends StatelessWidget {
  const MultiSelectExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MultiSelectDropdown(
              list: const [
                {'id': 'dog', 'label': 'Dog'},
                {'id': 'cat', 'label': 'Cat'},
                {'id': 'mouse', 'label': 'Mouse'},
                {'id': 'rabbit', 'label': 'Rabbit'},
              ],
              initiallySelected: const [],
              onChange: (newList) {
                // your logic
                // typically setting state
              },
              numberOfItemsLabelToShow: 2, // label to be shown for 2 items
              whenEmpty:
                  'Choose from the list', // text to show when selected list is empty
            ),
            const SizedBox(
              height: 20,
            ),
            MultiSelectDropdown.simpleList(
              list: const [
                'Dog',
                'Cat',
                'Horse',
                'Snake',
                'Mouse',
                'Rabbit',
                'Cow',
                'Sheep',
              ],
              initiallySelected: const [],
              onChange: (newList) {
                // your logic
              },
              includeSearch: true,
              includeSelectAll: true,
              isLarge: true, // Modal size will be a little large
              // Give a definite width when rendering this widget in a row
              width: 150, // Must be a definite number
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
