import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/item.dart';
import 'package:habitpunk/src/riverpod/item_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, String> categoryTypes = {
    'Hats': 'hat',
    'Armors': 'armor',
    'Facials': 'facial',
    'Weapons': 'weapon',
    'Backgrounds': 'background',
    'Pets': 'pet',
    'Capes': 'cape',
    'Chips': 'chip',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categoryTypes.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final itemAsyncValue =
            ref.watch(itemProvider); // Watch the itemProvider state

        return Scaffold(
          appBar: AppBar(
            title: Text('Shop'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: categoryTypes.keys.map((String category) {
                  return Tab(text: category);
                }).toList(),
              ),
            ),
          ),
          body: itemAsyncValue.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (List<Item> items) {
              final Map<String, List<Item>> categoryItems =
                  {}; // Holds the items for each category

              // Organize items by category
              for (String category in categoryTypes.keys) {
                final String type = categoryTypes[category]!;
                categoryItems[category] = items
                    .where((item) => item.type.trim().toLowerCase() == type)
                    .toList();
              }

              categoryItems.forEach((category, items) {
                print('Category: $category');
                items.forEach((item) {
                  print('Item: ${item.name}');
                });
              });

              return TabBarView(
                controller: _tabController,
                children: categoryTypes.keys.map((category) {
                  return ShopCategorySection(
                    category: category,
                    items: categoryItems[category] ?? [],
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ShopCategorySection extends StatelessWidget {
  final String category;
  final List<dynamic> items;

  const ShopCategorySection(
      {Key? key, required this.category, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
  itemCount: items.length,
  itemBuilder: (context, index) {
    var item = items[index];
    return ShopItemCard(
      itemName: item.name, // Assuming 'name' is a field in your item model
      itemId: item.id, // Assuming 'id' is a field in your item model
      itemCoins: item.coin,
    );
      },
    );
  }
}

class ShopItemCard extends StatelessWidget {
  final String itemName;
  final int itemId; 
  final int itemCoins;

  const ShopItemCard({
    Key? key,
    required this.itemName,
    required this.itemId,
    required this.itemCoins, 
  }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    String imagePath = 'images/items/${itemId.toString()}.png';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Card( // Card now only wraps the image
          clipBehavior: Clip.antiAlias, // Add this to ensure the image corners are also rounded
          child: Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8), // Provide some spacing between the image and the coin text
        Row( // Wrap the coin text and icon in a Row
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.attach_money, // Coin icon
              size: 20,
              color: Colors.yellow,
            ),
            Stack( // Use Stack to overlay the text border on the text
              children: <Widget>[
                // Stroked text as border
                Text(
                  itemCoins.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Colors.black,
                  ),
                ),
                // Solid text as fill
                Text(
                  itemCoins.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}