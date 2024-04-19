import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = ['Hats', 'Outfits', 'Facials', 'Weapons', 'Backgrounds', 'Pets', 'Capes', 'Chips'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: categories.map((String category) {
              return Tab(text: category);
            }).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((String category) {
          return ShopCategorySection(
            category: category,
            items: List.generate(3, (index) => '$category Item ${index + 1}'),
          );
        }).toList(),
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
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return ShopItemCard(itemName: items[index]);
      },
    );
  }
}

class ShopItemCard extends StatelessWidget {
  final String itemName;

  ShopItemCard({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(child: Text(itemName)),
    );
  }
}
