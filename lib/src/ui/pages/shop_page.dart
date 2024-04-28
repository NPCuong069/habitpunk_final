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
        final items = ref.watch(itemProvider);
        if (items.isEmpty) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
            appBar: AppBar(title: Text('Shop')),
          );
        } else {
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
            body: TabBarView(
              controller: _tabController,
              children: categoryTypes.keys.map((category) {
                final filteredItems = items
                    .where((item) =>
                        item.type.trim().toLowerCase() ==
                        categoryTypes[category])
                    .toList();
                return ShopCategorySection(
                  category: category,
                  items: filteredItems,
                  ref: ref
                );
              }).toList(),
            ),
          );
        }
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
  final List<Item> items;
  final WidgetRef ref;
  const ShopCategorySection(
      {Key? key, required this.category, required this.items, required this.ref,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> sortedItems = List<Item>.from(items)..sort((a, b) {
      if (!a.owned && b.owned) {
        return -1;  // a should come before b
      } else if (a.owned && !b.owned) {
        return 1;   // b should come before a
      }
      return 0;     // no change in order for items with same owned status
    });
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: sortedItems.length,
      itemBuilder: (context, index) {
        Item item = sortedItems[index];
        return ShopItemCard(item: item, ref: ref); // Pass the entire item
      },
    );
  }
}

class ShopItemCard extends StatelessWidget {
  final Item item;
 final WidgetRef ref; 
  const ShopItemCard({
    Key? key,
    required this.item,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images/items/${item.id.toString()}.png';
    bool isOwned = item.owned;
    return InkWell(
      onTap: isOwned? null: () => _showItemDialog(
          context, item),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            child: ColorFiltered(
              colorFilter: isOwned
                  ? ColorFilter.mode(Colors.grey, BlendMode.saturation)
                  : ColorFilter.mode(Colors.transparent, BlendMode.color),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.attach_money,
                size: 20,
                color: Colors.yellow,
              ),
              Text(
                item.coin.toString(),
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
    );
  }

  void _showItemDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 5, 23, 37),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.yellow, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/items/${item.id.toString()}.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.attach_money,
                          size: 24, color: Colors.amber),
                    ),
                    TextSpan(
                      text: ' ${item.coin} coins',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                bool success =
                    await ref.read(itemProvider.notifier).buyItem(item.id);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Purchase successful!"),
                    backgroundColor: Colors.green,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Purchase failed! Not enough coins"),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text('Buy'),
            ),
          ],
        );
      },
    );
  }
}
