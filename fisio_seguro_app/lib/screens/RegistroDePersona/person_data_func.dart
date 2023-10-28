// ignore_for_file: file_names

import 'package:flutter/material.dart';

mixin PersonData on State {
  final List<List<String>> persons = [
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
