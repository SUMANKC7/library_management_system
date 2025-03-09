class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String publisher;
  final String publishedDate;
  final int pageCount;
  final String thumbnail;
  final String previewLink;
  final double rating;
  final List<String> categories;
  final String language;
  final String maturityRating;
  final String? isbn; // Added ISBN field
  
  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.publisher,
    required this.publishedDate,
    required this.pageCount,
    required this.thumbnail,
    required this.previewLink,
    required this.rating,
    required this.categories,
    required this.language,
    required this.maturityRating,
    this.isbn, // Optional ISBN parameter
  });
  
  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    
    // Safely extract imageLinks
    Map<String, dynamic> imageLinks = {};
    if (volumeInfo.containsKey('imageLinks') && volumeInfo['imageLinks'] != null) {
      imageLinks = Map<String, dynamic>.from(volumeInfo['imageLinks']);
    }
    
    // Safely handle authors list
    List<String> authorsList = [];
    if (volumeInfo.containsKey('authors') && volumeInfo['authors'] != null) {
      authorsList = List<String>.from(volumeInfo['authors']);
    } else {
      authorsList = ['Unknown Author'];
    }
    
    // Safely handle categories list
    List<String> categoriesList = [];
    if (volumeInfo.containsKey('categories') && volumeInfo['categories'] != null) {
      categoriesList = List<String>.from(volumeInfo['categories']);
    } else {
      categoriesList = ['Uncategorized'];
    }
    
    // Extract ISBN (if available)
    String? isbn;
    if (volumeInfo.containsKey('industryIdentifiers') && volumeInfo['industryIdentifiers'] != null) {
      final identifiers = volumeInfo['industryIdentifiers'] as List;
      for (final identifier in identifiers) {
        if (identifier['type'] == 'ISBN_13') {
          isbn = identifier['identifier'];
          break;
        } else if (identifier['type'] == 'ISBN_10' && isbn == null) {
          isbn = identifier['identifier'];
        }
      }
    }
    
    // Get book ID and build thumbnail URL
    String thumbnailUrl = '';
    String bookId = json['id'] ?? '';
    
    if (bookId.isNotEmpty) {
      // Keep using this format for the initial URL
      thumbnailUrl = 'https://books.google.com/books/content?id=$bookId&printsec=frontcover&img=1&zoom=1&source=gbs_api';
    } else {
      thumbnailUrl = 'https://via.placeholder.com/128x192.png?text=No+Cover';
    }
    
    return Book(
      id: bookId,
      title: volumeInfo['title'] ?? 'Unknown Title',
      authors: authorsList,
      description: volumeInfo['description'] ?? 'No description available',
      publisher: volumeInfo['publisher'] ?? 'Unknown Publisher',
      publishedDate: volumeInfo['publishedDate'] ?? 'Unknown Date',
      pageCount: volumeInfo['pageCount'] ?? 0,
      thumbnail: thumbnailUrl,
      previewLink: volumeInfo['previewLink'] ?? '',
      rating: (volumeInfo['averageRating'] != null)
          ? double.parse(volumeInfo['averageRating'].toString())
          : 0.0,
      categories: categoriesList,
      language: volumeInfo['language'] ?? 'Unknown',
      maturityRating: volumeInfo['maturityRating'] ?? 'Unknown',
      isbn: isbn, // Add the ISBN to the constructor
    );
  }
}