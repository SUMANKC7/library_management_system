import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/models/borrowing.dart';
import 'package:librarymanagementsystem/providers/borrowing_provider.dart';
import 'package:librarymanagementsystem/screens/book_details_screen.dart';
import 'package:librarymanagementsystem/widgets/book_cover.dart';
import 'package:provider/provider.dart';


class BorrowingListItem extends StatelessWidget {
  final Borrowing borrowing;
  
  const BorrowingListItem({
    Key? key,
    required this.borrowing,
  }) : super(key: key);
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  @override
  Widget build(BuildContext context) {
    final book = borrowing.book;
    final isReturned = borrowing.isReturned;
    final isOverdue = borrowing.isOverdue;
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(book: book),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BookCover(
                  imageUrl: book.thumbnail,
                  height: 100,
                  width: 70,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      book.authors.join(', '),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isReturned
                              ? Icons.assignment_turned_in
                              : isOverdue
                                  ? Icons.warning
                                  : Icons.schedule,
                          size: 16,
                          color: isReturned
                              ? Colors.green
                              : isOverdue
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                        SizedBox(width: 4),
                        Text(
                          isReturned
                              ? 'Returned on ${_formatDate(borrowing.returnDate!)}'
                              : isOverdue
                                  ? 'Overdue by ${-borrowing.daysRemaining} days'
                                  : '${borrowing.daysRemaining} days remaining',
                          style: TextStyle(
                            color: isReturned
                                ? Colors.green
                                : isOverdue
                                    ? Colors.red
                                    : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('Due: ${_formatDate(borrowing.dueDate)}'),
                    SizedBox(height: 4),
                    Text('Borrowed: ${_formatDate(borrowing.borrowDate)}'),
                    
                    if (!isReturned)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<BorrowingProvider>(context, listen: false)
                                .returnBook(borrowing.id);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size(100, 36),
                          ),
                          child: Text('Return'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}