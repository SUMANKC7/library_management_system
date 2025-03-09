import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/models/book.dart';
import 'package:librarymanagementsystem/providers/borrowing_provider.dart';
import 'package:librarymanagementsystem/widgets/book_cover.dart';
import 'package:librarymanagementsystem/widgets/rating_stars.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  
  const BookDetailsScreen({
    super.key,
    required this.book,
  });
  
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch $url');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BorrowingProvider>(
        builder: (context, borrowingProvider, child) {
          final isBorrowed = borrowingProvider.isBookBorrowed(book.id);
          final borrowing = borrowingProvider.getBorrowingForBook(book.id);
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      
                    ),
                  ),
                  background: Hero(
                    tag: 'book_cover_${book.id}',
                    child: BookCover(
                      imageUrl: book.thumbnail,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book metadata
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book cover (smaller size for this view)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: BookCover(
                              imageUrl: book.thumbnail,
                              height: 150,
                              width: 100,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  book.authors.join(', '),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 8),
                                RatingStars(rating: book.rating),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: book.categories.map((category) {
                                    return Chip(
                                      label: Text(category),
                                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Borrowing status
                      if (isBorrowed && borrowing != null)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: borrowing.isOverdue
                                ? Colors.red.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Borrowing Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    borrowing.isOverdue
                                        ? Icons.warning
                                        : Icons.check_circle,
                                    color: borrowing.isOverdue
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    borrowing.isOverdue
                                        ? 'Overdue by ${-borrowing.daysRemaining} days'
                                        : '${borrowing.daysRemaining} days remaining',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: borrowing.isOverdue
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text('Due date: ${_formatDate(borrowing.dueDate)}'),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  borrowingProvider.returnBook(borrowing.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Book has been returned successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text('Return Book',style: TextStyle(color:Colors.white),),
                              ),
                            ],
                          ),
                        ),
                      
                      SizedBox(height: 24),
                      
                      // Book details
                      Text(
                        'Book Details',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8),
                      _buildDetailRow('Publisher', book.publisher),
                      _buildDetailRow('Published Date', book.publishedDate),
                      _buildDetailRow('Pages', book.pageCount.toString()),
                      _buildDetailRow('Language', book.language.toUpperCase()),
                      _buildDetailRow('Maturity Rating', book.maturityRating),
                      
                      SizedBox(height: 24),
                      
                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        book.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Preview link
                      if (book.previewLink.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () => _launchUrl(book.previewLink),
                          icon: Icon(Icons.launch),
                          label: Text('Preview Book'),
                        ),
                      
                      SizedBox(height: 60), // Extra space for the FAB
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<BorrowingProvider>(
        builder: (context, borrowingProvider, child) {
          final isBorrowed = borrowingProvider.isBookBorrowed(book.id);
          
          if (isBorrowed) {
            return SizedBox.shrink(); // Hide FAB if already borrowed
          }
          
          return FloatingActionButton.extended(
            onPressed: () {
              try {
                borrowingProvider?.borrowBook(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Book borrowed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            label: Text('Borrow'),
            icon: Icon(Icons.bookmark_add),
          );
        },
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}


                                        