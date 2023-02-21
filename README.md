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

## Parameters

| Parameter Name | Description |
| -------------- | ----------- |
| list | List of options to select from |
| label | `label` key in a Map to show as an option. Defaults to 'label' |
| id | `id` key in a Map to identify an item. Defaults to 'id' |
| onChange | `onChange` callback, passes new list as argument |
| numberOfItemsLabelToShow | Number of items to show as text, beyond that it will show `n` selected |
| initiallySelected | Initially selected list |
| boxDecoration | Decoration for anchor element |
| isLarge | Dropdown size |
| width | Anchor and modal width |
| whenEmpty | Text to show when nothing is selected |
| includeSelectAll | Includes a select all button when `true` |
| includeSearch | Includes a search option when `true` |
| textStyle | `TextStyle?` for the text on anchor element |
| duration | `Duration?` for debounce in search option. Defaults to 300 milliseconds. |


> I will keep adding more functionalities.
