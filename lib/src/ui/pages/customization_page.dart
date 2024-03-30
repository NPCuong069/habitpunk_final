import 'package:flutter/material.dart';
import 'package:habitpunk/src/ui/pages/shop_page.dart';


class CustomizationPage extends StatelessWidget {
  final Map<String, List<String>> categories = {
    'Hats': ['Hat 1', 'Hat 2', 'Hat 3'],
    'Outfits': ['Outfit 1', 'Outfit 2', 'Outfit 3'],
    'Facials': ['Facial 1', 'Facial 2', 'Facial 3'],
    'Weapons': ['Weapon 1', 'Weapon 2', 'Weapon 3'],
    'Backgrounds': ['Background 1', 'Background 2', 'Background 3'],
    'Pets': ['Pet 1', 'Pet 2', 'Pet 3'],
    'Capes': ['Cape 1', 'Cape 2', 'Cape 3'],
    'Chips': ['Chip 1', 'Chip 2', 'Chip 3'],
    // ... add the rest of your categories here
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        actions: [
          // Add a shop button on the AppBar
          IconButton(
            icon: Icon(Icons.store),
            onPressed: () {
              // Navigate to the ShopPage when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShopPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: categories.entries.map((entry) => CategorySection(category: entry.key, items: entry.value)).toList(),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String category;
  final List<String> items;

  CategorySection({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 100, // Adjust the height according to your design
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length + 1, // +1 for the show more button
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index == items.length) {
                // Show 'Show More' button at the end
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10), // Adjust the padding as needed
                  child: TextButton(
                    onPressed: () {
                      // Implement show more functionality
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.purple, shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min, // To make the Row take only as much width as needed
                      children: [
                        Text('Show More'),
                        Icon(Icons.chevron_right), // Right arrow icon
                      ],
                    ),
                  ),
                );
              }
              return ItemCard(itemName: items[index]);
            },
          ),
        ),
      ],
    );
  }
}


class ItemCard extends StatelessWidget {
  final String itemName;

  ItemCard({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Adjust the width according to your design
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.extension, size: 40), // Placeholder for item image
          Text(itemName),
        ],
      ),
    );
  }
}
