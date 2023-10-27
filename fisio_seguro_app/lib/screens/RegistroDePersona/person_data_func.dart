// ignore_for_file: file_names

import 'package:flutter/material.dart';

mixin PersonData on State {
  final List<List<String>> persons = [
    ['Ethan_0', 'Clark_0', '555-876-5432', 'ethanclark_0@example.com', 'K12345', "True"],
    ['Ava_1', 'Davis_1', '555-345-6789', 'avadavis_1@example.com', 'L98765', "False"],
    ['Ethan_2', 'Ethan_2', '555-246-912', 'ethan_2ethan_2_2@example.com', 'C24690', "True"],
    ['Ava_3', 'Ava_3', '555-369-368', 'ava_3ava_3_3@example.com', 'D37035', "True"],
    ['Ethan_4', 'Clark_4', '555-492-824', 'ethan_4clark_4_4@example.com', 'E49380', "False"],
    ['Ava_5', 'Davis_5', '555-615-280', 'ava_5davis_5_5@example.com', 'F61725', "True"],
    ['Ethan_6', 'Ethan_6', '555-738-736', 'ethan_6ethan_6_6@example.com', 'G74070', "True"],
  ]; // Your person data here

  late List<List<String>> originalOrder;
  int? sortColumnIndex;
  bool sortAscending = true;

  @override
  void initState() {
    super.initState();
    originalOrder = List.from(persons);
  }

  void sort<T>(int columnIndex, bool ascending) {
    if (sortColumnIndex == columnIndex && !sortAscending) {
      // Reset to original order when clicked consecutively
      persons.setAll(0, originalOrder);
      sortColumnIndex = null;
    } else {
      persons.sort((a, b) {
        final comparableA = a[columnIndex] as T;
        final comparableB = b[columnIndex] as T;
        return ascending
            ? (comparableA as Comparable<T>).compareTo(comparableB)
            : (comparableB as Comparable<T>).compareTo(comparableA);
      });
      if (mounted) {
        setState(() {
          sortColumnIndex = columnIndex;
          sortAscending = ascending;
        });
      }
    }
  }
}
