import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/models/book.dart';
import 'package:librarymanagementsystem/models/borrowing.dart';
import 'package:uuid/uuid.dart';


class BorrowingProvider with ChangeNotifier {
  final List<Borrowing> _borrowings = [];
  final Uuid _uuid = Uuid();
  
  List<Borrowing> get borrowings => _borrowings;
  
  List<Borrowing> get activeBorrowings => 
    _borrowings.where((borrowing) => borrowing.returnDate == null).toList();
  
  List<Borrowing> get returnedBorrowings => 
    _borrowings.where((borrowing) => borrowing.returnDate != null).toList();
  
  List<Borrowing> get overdueBorrowings => 
    _borrowings.where((borrowing) => borrowing.isOverdue).toList();
  
  // Check if a book is currently borrowed
  bool isBookBorrowed(String bookId) {
    return activeBorrowings.any((borrowing) => borrowing.book.id == bookId);
  }
  
  // Borrow a book
  void borrowBook(Book book, {int daysToReturn = 14}) {
    if (isBookBorrowed(book.id)) {
      throw Exception('This book is already borrowed');
    }
    
    final now = DateTime.now();
    final dueDate = now.add(Duration(days: daysToReturn));
    
    final borrowing = Borrowing(
      id: _uuid.v4(),
      book: book,
      borrowDate: now,
      dueDate: dueDate,
    );
    
    _borrowings.add(borrowing);
    notifyListeners();
  }
  
  // Return a book
  void returnBook(String borrowingId) {
    final index = _borrowings.indexWhere((borrowing) => borrowing.id == borrowingId);
    
    if (index != -1) {
      final borrowing = _borrowings[index];
      if (borrowing.returnDate != null) {
        throw Exception('This book has already been returned');
      }
      
      _borrowings[index] = borrowing.copyWith(returnDate: DateTime.now());
      notifyListeners();
    }
  }
  
  // Get borrowing details for a specific book
  Borrowing? getBorrowingForBook(String bookId) {
    try {
      return activeBorrowings.firstWhere((borrowing) => borrowing.book.id == bookId);
    } catch (_) {
      return null;
    }
  }
  
  // Get borrowing history
  List<Borrowing> getBorrowingHistory() {
    return List.from(_borrowings)
      ..sort((a, b) => b.borrowDate.compareTo(a.borrowDate));
  }
}