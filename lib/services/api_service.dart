import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:librarymanagementsystem/models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  
  // Fetch books based on search query
  Future<List<Book>> searchBooks(String query, {int maxResults = 20}) async {
    if (query.isEmpty) return [];
    
    final url = '$_baseUrl?q=$query&maxResults=$maxResults';
    
    try {
      final response = await http.get(Uri.parse(url));
     
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        
        if (data['items'] == null) return [];
        
        return List<Book>.from(
          data['items'].map((item) => Book.fromJson(item))
        );
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }
  
  // Fetch book details by ID
  Future<Book> getBookById(String id) async {
    final url = '$_baseUrl/$id';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Book.fromJson(data);
      } else {
        throw Exception('Failed to load book details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching book details: $e');
    }
  }
  
  // Fetch books by category
  Future<List<Book>> getBooksByCategory(String category, {int maxResults = 10}) async {
    final url = '$_baseUrl?q=subject:$category&maxResults=$maxResults';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['items'] == null) return [];
        
        return List<Book>.from(
          data['items'].map((item) => Book.fromJson(item))
        );
      } else {
        throw Exception('Failed to load books by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books by category: $e');
    }
  }
}