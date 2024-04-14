import 'package:flutter/material.dart';
import 'package:habitpunk/src/ui/pages/shop_page.dart';

// Define a mapping from category names to icons.
// You would replace these Icons with the actual icons for each category.
final Map<String, IconData> categoryIcons = {
  'Hats': Icons.place, // Replace with the actual icon for Hats
  'Outfits': Icons.checkroom, // Replace with the actual icon for Outfits
  'Facials': Icons.face, // Replace with the actual icon for Facials
  'Weapons': Icons.place, // Replace with the actual icon for Weapons
  'Backgrounds': Icons.landscape, // Replace with the actual icon for Backgrounds
  'Pets': Icons.pets, // Replace with the actual icon for Pets
  'Capes': Icons.cloud, // Replace with the actual icon for Capes
  'Chips': Icons.memory, // Replace with the actual icon for Chips
};

class CustomizationPage extends StatefulWidget {
  @override
  _CustomizationPageState createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
   final List<String> categories = categoryIcons.keys.toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.store),
            onPressed: () {
              // Navigate to the ShopPage
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShopPage()),
                );
            },
          ),
        ],
        backgroundColor: Color.fromARGB(255, 5, 23, 37)
      ),
      body: Column(
        children: [
       
          TabBar(
            controller: _tabController,
            tabs: categories.map((String category) => Tab(icon: Icon(categoryIcons[category]), // Use the icon for each category
              text: category,)).toList(),
            isScrollable: true,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                // Replace with your item widgets
                return ItemsListWidget(category: category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}



class ItemsListWidget extends StatelessWidget {
  final String category;

  ItemsListWidget({required this.category});

  @override
  Widget build(BuildContext context) {
    // Generate a list of items for the category
    List<Widget> items = List.generate(5, (index) => ItemCard(itemName: '$category Item $index', itemAssetPath: '',));

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}

class ItemCard extends StatelessWidget {
  final String itemName;
  final String itemAssetPath; // The path relative to the assets directory

  ItemCard({required this.itemName, required this.itemAssetPath});

  @override
  Widget build(BuildContext context) {
    // Set the size for the square button
    
    final double size = 40;
    // Set the width for the container
    final double containerWidth = MediaQuery.of(context).size.width * 0.15; // Let's say you want 15% of the screen width
    return GestureDetector(
      onTap: () {
        // Handle the tap event
      },
      child: Container(
        width: containerWidth, // Use the containerWidth variable here
        height: size, // Adjust the height as needed
        
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(color: Colors.purple, width: 2), // Border styling
        
        ),
         child: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding inside the container
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/placeholder.png', // Local asset image
            image: itemAssetPath,
            width: size, // Make the image width the same as the size
            height: size,
            fit: BoxFit.contain,
            imageErrorBuilder: (context, error, stackTrace) {
              // If the main image fails to load, this builder will be used to create an error widget
              return Image.asset(
                'assets/images/placeholder.png', // Fallback to a local asset image
                width: size,
                height: size,
                fit: BoxFit.contain,
              );
            },
          ),
        ),
      ),
    );
  }
}


