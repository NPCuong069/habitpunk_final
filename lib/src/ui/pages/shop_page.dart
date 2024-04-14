import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  // This map can be replaced with your actual shop data

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> categories = ['Hats', 'Outfits', 'Facials', 'Weapons', 'Backgrounds', 'Pets', 'Capes', 'Chips'];
  final Map<String, GlobalKey> categoryKeys = {};

  @override
  void initState() {
    super.initState();
    // Create a GlobalKey for each category to be able to jump to it on tab tap
    for (var category in categories) {
      categoryKeys[category] = GlobalKey();
    }
  }

  void _scrollToCategory(String category) {
    final key = categoryKeys[category];
    if (key?.currentContext != null) {
      // Scroll to the selected category
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // The PreferredSize widget is no longer necessary since we're not using a TabBar.
    // We can just place the SingleChildScrollView directly in the AppBar.
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((String category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: () => _scrollToCategory(category),
                    child: Text(category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        // Using ListView.builder is more efficient for a large number of categories.
        controller: _scrollController,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          String category = categories[index];
          return ShopCategorySection(
            key: categoryKeys[category],
            category: category,
            items: List.generate(3, (index) => '$category Item ${index + 1}'),
          );
        },
      ),
    );
  }
}

class ShopCategorySection extends StatelessWidget {
  final String category;
  final List<String> items;

  ShopCategorySection({Key? key, required this.category, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(category, style: Theme.of(context).textTheme.headline6),
        ),
        Container(
          height: 100, // Adjust the height according to your design
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => SizedBox(width: 8),
            itemBuilder: (context, index) => ShopItemCard(itemName: items[index]),
          ),
        ),
      ],
    );
    // Your existing ShopCategorySection code
  }
}

class ShopItemCard extends StatelessWidget {
  final String itemName;

  ShopItemCard({required this.itemName});

  @override
  Widget build(BuildContext context) {
    // Customize this card as per your shop item's design
    return Container(
      width: 80, // Adjust the width according to your design
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket), // Replace with item image or icon
          Text(itemName),
        ],
      ),
    );
  }
}
