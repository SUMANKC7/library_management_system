import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/models/book.dart';
import 'package:librarymanagementsystem/screens/book_details_screen.dart';
import 'package:librarymanagementsystem/widgets/book_cover.dart';

class BookCarousel extends StatelessWidget {
  final List<Book> books;

  const BookCarousel({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      );
    }

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.5,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(), // Smooth scrolling effect
        padding: EdgeInsets.symmetric(horizontal: 40),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsScreen(book: book),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 22,bottom: 16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(right: 16),
                height: MediaQuery.sizeOf(context).height * 1,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: Offset(0, 8),
                    ),
                  ],
                 gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'book_cover_${book.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BookCover(
                              imageUrl: book.thumbnail,
                              bookId: book.id,
                              isbn: book.isbn,  
                              height: MediaQuery.sizeOf(context).height * 0.3,
                              width: MediaQuery.sizeOf(context).width * 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        
                      ],
                    ),

                    Positioned(
                      bottom: 8,
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          // backdropFilter: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10)),
                        ),
                        child: Center(
                          child: Text(
                            "View Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
