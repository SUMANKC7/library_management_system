import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/providers/borrowing_provider.dart';
import 'package:librarymanagementsystem/widgets/borrowing_list_item.dart';
import 'package:provider/provider.dart';


class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({Key? key}) : super(key: key);

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Books'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Borrowed'),
            Tab(text: 'Overdue'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BorrowedBooksTab(),
          _OverdueBooksTab(),
          _BorrowingHistoryTab(),
        ],
      ),
    );
  }
}

class _BorrowedBooksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowingProvider>(
      builder: (context, borrowingProvider, child) {
        final borrowings = borrowingProvider!.activeBorrowings
            .where((borrowing) => !borrowing.isOverdue)
            .toList();
        
        if (borrowings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No books currently borrowed',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: borrowings.length,
          itemBuilder: (context, index) {
            return BorrowingListItem(borrowing: borrowings[index]);
          },
        );
      },
    );
  }
}

class _OverdueBooksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowingProvider>(
      builder: (context, borrowingProvider, child) {
        final overdueBorrowings = borrowingProvider.overdueBorrowings;
        
        if (overdueBorrowings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.green[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No overdue books',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: overdueBorrowings.length,
          itemBuilder: (context, index) {
            return BorrowingListItem(borrowing: overdueBorrowings[index]);
          },
        );
      },
    );
  }
}

class _BorrowingHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowingProvider>(
      builder: (context, borrowingProvider, child) {
        final borrowingHistory = borrowingProvider.getBorrowingHistory();
        
        if (borrowingHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No borrowing history yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: borrowingHistory.length,
          itemBuilder: (context, index) {
            return BorrowingListItem(borrowing: borrowingHistory[index]);
          },
        );
      },
    );
  }
}