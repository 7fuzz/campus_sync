import 'package:flutter/material.dart';

class CourseSchedulePage extends StatelessWidget {
  const CourseSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Schedule'),
        centerTitle: true,
        backgroundColor: Colors.green[400],
      ),
    );
  }
}
