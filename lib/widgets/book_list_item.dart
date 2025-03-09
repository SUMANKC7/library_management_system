import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/models/book.dart';
import 'package:librarymanagementsystem/screens/book_details_screen.dart';
import 'package:librarymanagementsystem/widgets/book_cover.dart';
import 'package:librarymanagementsystem/widgets/rating_stars.dart';

class BookListItem extends StatelessWidget {
  final Book book;
  
  const BookListItem({
    super.key,
    required this.book,
  });
  
  @override
  Widget build(BuildContext context) {
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
              Hero(
                tag: 'book_cover_${book.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BookCover(
                    imageUrl: book.thumbnail,
                    height: 120,
                    width: 80,
                  ),
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
                    RatingStars(rating: book.rating),
                    SizedBox(height: 8),
                    Text(
                      book.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
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