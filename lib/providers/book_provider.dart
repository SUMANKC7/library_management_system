import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/models/book.dart';
import 'package:librarymanagementsystem/services/api_service.dart';

class BookProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Book> _books = [];
  List<Book> _featuredBooks = [];
  List<Book> _recentBooks = [];
  List<Book> _history = [];
  bool _isLoading = false;
  String _error = '';
  
  List<Book> get books => _books;
  List<Book> get featuredBooks => _featuredBooks;
  List<Book> get recentBooks => _recentBooks;
  List<Book> get history => _history;
  bool get isLoading => _isLoading;
  String get error => _error;
  
  // Search books
  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      _books = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _books = await _apiService.searchBooks(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // Fetch books by category for the home screen
  Future<void> fetchFeaturedBooks() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      // Get some popular categories
      _featuredBooks = await _apiService.getBooksByCategory('fiction');
      _recentBooks = await _apiService.getBooksByCategory('computer science');
      _history = await _apiService.getBooksByCategory('history');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // Filter books by category
  List<Book> filterByCategory(String category) {
    if (category.isEmpty || category.toLowerCase() == 'all') {
      return _books;
    }
    return _books.where((book) => 
      book.categories.any((cat) => 
        cat.toLowerCase().contains(category.toLowerCase())
      )
    ).toList();
  }
  
  // Get a book by ID
  Future<Book?> getBookById(String id) async {
    try {
      return await _apiService.getBookById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

Future<void> searchBooksByCategory(String category) async {
  _isLoading = true;
  _error = '';
  notifyListeners();
  
  try {
    _books = await _apiService.getBooksByCategory(category);
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _isLoading = false;
    _error = e.toString();
    notifyListeners();
  }
}

}