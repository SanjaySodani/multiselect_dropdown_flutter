<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

* A simple multiselect dropdown which has **Select All** and **Search** options. 
* You can use a simple list or a list of maps.

## Features

![MultiSelect Dropdown demo](https://github.com/SanjaySodani/media/blob/main/multiselect_dropdown_flutter.gif "Demo")

* Use `MultiSelectDropdown` for list of maps.
* Use `MultiSelectDropdown.simpleList` for a simple list.

## Getting started

* Add the package in your flutter project.
* Import the package `import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';`.

## Usage

```dart
class MultiSelectExample extends StatelessWidget {
  const MultiSelectExample({super.key});

  final List myList2 = const ['Dog', 'Cat', 'Mouse', 'Rabbit'];

  final List myList = const [
    {'id': 'dog', 'label': 'Dog'},
    {'id': 'cat', 'label': 'Cat'},
    {'id': 'mouse', 'label': 'Mouse'},
    {'id': 'rabbit', 'label': 'Rabbit'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MultiSelectDropdown(
            list: myList,
            initiallySelected: const [],
            onChange: (newList) {
              // your logic
            },
          ),
          const SizedBox(height: 50),
          MultiSelectDropdown.simpleList(
            list: myList2,
            initiallySelected: const [],
            onChange: (newList) {
              // your logic
            },
            includeSearch: true,
            includeSelectAll: true,
          ),
        ],
      ),
    );
  }
}
```

> I will keep adding more functionalities.
