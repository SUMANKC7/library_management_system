import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/providers/book_provider.dart';
import 'package:librarymanagementsystem/widgets/book_list_item.dart';
import 'package:librarymanagementsystem/widgets/filter_chip_list.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String initialCategory;
  
  const SearchScreen({
    super.key,
    this.initialCategory = '',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCategory;
  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    
    // If initial category is provided, search for books in that category
    if (_selectedCategory.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isSearching = true;
        });
        
        Provider.of<BookProvider>(context, listen: false)
          .searchBooksByCategory(_selectedCategory)
          .then((_) {
            setState(() {
              _isSearching = false;
            });
          });
      });
    }
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      Provider.of<BookProvider>(context, listen: false)
        .searchBooks(query)
        .then((_) {
          setState(() {
            _isSearching = false;
          });
        });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for books...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          
          Consumer<BookProvider>(
            builder: (context, bookProvider, child) {
              // Only show filters if we have search results
              if (bookProvider.books.isEmpty) {
                return SizedBox.shrink();
              }
              
              // Extract unique categories from search results
              final allCategories = bookProvider.books
                .expand((book) => book.categories)
                .toSet()
                .toList();
              
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Filter by category:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  
                  FilterChipList(
                    categories: ['All', ...allCategories],
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedCategory = category == 'All' ? '' : category;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          
          if (_isSearching)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Consumer<BookProvider>(
              builder: (context, bookProvider, child) {
                if (bookProvider.error.isNotEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Error: ${bookProvider.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                
                if (bookProvider.books.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _selectedCategory.isEmpty 
                                ? 'Search for books to get started' 
                                : 'No books found in ${_selectedCategory} category',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                // Filter books by selected category
                final filteredBooks = _selectedCategory.isEmpty
                    ? bookProvider.books
                    : bookProvider.filterByCategory(_selectedCategory);
                
                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      return BookListItem(book: filteredBooks[index]);
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}