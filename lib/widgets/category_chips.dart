import 'package:flutter/material.dart';
import 'package:librarymanagementsystem/screens/search_screen.dart';

class CategoryChips extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  
  const CategoryChips({
    Key? key,
    required this.categories,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                // Pass the selected category to SearchScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      initialCategory: categories[index]['name'],
                    ),
                  ),
                );
              },
              child: Chip(
                elevation: 3,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                label: Text(
                  categories[index]['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                avatar: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    categories[index]['icon'],
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
