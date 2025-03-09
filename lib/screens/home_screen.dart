import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/providers/book_provider.dart';
import 'package:librarymanagementsystem/screens/my_books_screen.dart';
import 'package:librarymanagementsystem/screens/search_screen.dart';
import 'package:librarymanagementsystem/widgets/book_carousel.dart';
import 'package:librarymanagementsystem/widgets/category_chips.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeContent(),
    const SearchScreen(),
    const MyBooksScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(context, listen: false).fetchFeaturedBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'My Books',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                floating: true,
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SearchScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.search, color: Colors.deepPurple),
                                  SizedBox(width: 10),
                                  Text(
                                    'Search for books...',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (bookProvider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (bookProvider.error.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Error: ${bookProvider.error}',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Browse Categories',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                   CategoryChips(
  categories: [
    {'name': 'Fiction', 'icon': Icons.menu_book},
    {'name': 'Non-Fiction', 'icon': Icons.library_books},
    {'name': 'Drama', 'icon': Icons.filter_drama},
    {'name': 'Technology', 'icon': Icons.computer},
    {'name': 'History', 'icon': Icons.history},
    {'name': 'Biography', 'icon': Icons.person},
    {'name': 'Fantasy', 'icon': Icons.auto_stories},
    {'name': 'Art', 'icon': Icons.brush},
  ],
),

                    const SizedBox(height: 20),
                    _buildSectionTitle(context, 'Featured Books', onTap: () {}),
                    SizedBox(height: 10,),
                    BookCarousel(books: bookProvider.featuredBooks),
                    _buildSectionTitle(context, 'Computer Science ', onTap: () {}),
                    SizedBox(height: 10,),
                    BookCarousel(books: bookProvider.recentBooks),
                    const SizedBox(height: 20),
                     _buildSectionTitle(context, 'History Books', onTap: () {}),
                    SizedBox(height: 10,),
                    BookCarousel(books: bookProvider.recentBooks),
                    SizedBox(height: 20,),
                  ]),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text('See All', style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
      ),
    );
  }
}
