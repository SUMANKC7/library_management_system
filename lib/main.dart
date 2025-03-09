import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/providers/book_provider.dart';
import 'package:librarymanagementsystem/providers/borrowing_provider.dart';
import 'package:librarymanagementsystem/screens/home_screen.dart';
import 'package:librarymanagementsystem/utils/theme.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => BorrowingProvider()),
      ],
      child: MaterialApp(
        title: 'Library Management System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}