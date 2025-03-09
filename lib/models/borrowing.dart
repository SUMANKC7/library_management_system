import 'package:librarymanagementsystem/models/book.dart';

class Borrowing {
  final String id;
  final Book book;
  final DateTime borrowDate;
  final DateTime dueDate;
  final DateTime? returnDate;

  Borrowing({
    required this.id,
    required this.book,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
  });

  bool get isReturned => returnDate != null;
  
  bool get isOverdue => !isReturned && DateTime.now().isAfter(dueDate);
  
  int get daysRemaining {
    if (isReturned) return 0;
    return dueDate.difference(DateTime.now()).inDays;
  }
  
  Borrowing copyWith({
    String? id,
    Book? book,
    DateTime? borrowDate,
    DateTime? dueDate,
    DateTime? returnDate,
  }) {
    return Borrowing(
      id: id ?? this.id,
      book: book ?? this.book,
      borrowDate: borrowDate ?? this.borrowDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate,
    );
  }
}