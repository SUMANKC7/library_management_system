import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCover extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final String? bookId;
  final String? isbn;
  
  const BookCover({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
    this.bookId,
    this.isbn,
  });
  
  @override
  State<BookCover> createState() => _BookCoverState();
}

class _BookCoverState extends State<BookCover> {
  int _currentUrlIndex = 0;
  late List<String> _urlCandidates;
  
  @override
  void initState() {
    super.initState();
    _initializeUrlCandidates();
  }
  
  void _initializeUrlCandidates() {
    final List<String> candidates = [];
    
    // Extract book ID if present in URL
    String? bookId = widget.bookId;
    if (bookId == null && widget.imageUrl.contains('/frontcover/')) {
      final RegExp regExp = RegExp(r'frontcover/([^?]+)');
      final match = regExp.firstMatch(widget.imageUrl);
      if (match != null && match.groupCount >= 1) {
        bookId = match.group(1);
      }
    }
    
    // Add Google Books URLs with different formats if we have a book ID
    if (bookId != null && bookId.isNotEmpty) {
      candidates.addAll([
        // HTTPS URLs with different zoom levels
        'https://books.google.com/books/content?id=$bookId&printsec=frontcover&img=1&zoom=1&source=gbs_api',
        'https://books.google.com/books/content?id=$bookId&printsec=frontcover&img=1&zoom=0&source=gbs_api',
        'https://books.google.com/books/content?id=$bookId&printsec=frontcover&img=1&zoom=5&source=gbs_api',
        'https://books.google.com/books/content?id=$bookId&printsec=frontcover&img=1&edge=curl&source=gbs_api',
      ]);
    }
    
    // Add ISBN-based OpenLibrary URL if ISBN is available
    if (widget.isbn != null && widget.isbn!.isNotEmpty) {
      candidates.add('https://covers.openlibrary.org/b/isbn/${widget.isbn}-L.jpg');
    }
    
    // Add original URL if not empty and not already included
    if (widget.imageUrl.isNotEmpty && !candidates.contains(widget.imageUrl)) {
      // Make sure URL uses HTTPS
      String secureUrl = widget.imageUrl;
      if (secureUrl.startsWith('//')) {
        secureUrl = 'https:$secureUrl';
      } else if (secureUrl.startsWith('http://')) {
        secureUrl = secureUrl.replaceFirst('http://', 'https://');
      }
      candidates.add(secureUrl);
    }
    
    // Placeholder as last resort
    candidates.add('https://via.placeholder.com/128x192.png?text=No+Cover');
    
    _urlCandidates = candidates;
  }
  
  void _tryNextUrl() {
    if (_currentUrlIndex < _urlCandidates.length - 1) {
      setState(() {
        _currentUrlIndex++;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final String currentUrl = _urlCandidates[_currentUrlIndex];
    
    return CachedNetworkImage(
      imageUrl: currentUrl,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      memCacheHeight: widget.height.toInt() * 2, // For high-resolution displays
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: widget.fit,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
      placeholder: (context, url) => Container(
        height: widget.height,
        width: widget.width,
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorListener: (error) {
        // print('Error loading image: $currentUrl');
        // print('Error details: $error');
        _tryNextUrl();
      },
      errorWidget: (context, url, error) {
        // If we're at the last URL (placeholder), show the error widget
        if (_currentUrlIndex >= _urlCandidates.length - 1) {
          return Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.book, size: widget.height * 0.3, color: Colors.grey[400]),
                  const SizedBox(height: 4),
                  Text(
                    'No Cover',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }
        
        // If not at the last URL, show a loading placeholder while we try the next URL
        return Container(
          height: widget.height,
          width: widget.width,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}