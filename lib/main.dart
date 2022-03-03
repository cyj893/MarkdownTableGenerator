import 'package:flutter/material.dart';
import 'package:markdown_table_generator/cell_size_provider.dart';
import 'package:provider/provider.dart';

import 'my_hom_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CellSizeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '마크다운 표 생성기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}
