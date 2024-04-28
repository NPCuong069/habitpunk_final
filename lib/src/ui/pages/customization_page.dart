import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/item.dart';
import 'package:habitpunk/src/riverpod/item_provider.dart';
import 'package:habitpunk/src/riverpod/user_provider.dart';
import 'package:habitpunk/src/ui/pages/shop_page.dart';

// You would replace these Icons with the actual icons for each category.
final Map<String, IconData> categoryIcons = {
  'Hats': Icons.place, // Replace with the actual icon for Hats
  'Outfits': Icons.checkroom, // Replace with the actual icon for Outfits
  'Facials': Icons.face, // Replace with the actual icon for Facials
  'Weapons': Icons.place, // Replace with the actual icon for Weapons
  'Backgrounds':
      Icons.landscape, // Replace with the actual icon for Backgrounds
  'Pets': Icons.pets, // Replace with the actual icon for Pets
  'Capes': Icons.cloud, // Replace with the actual icon for Capes
  'Chips': Icons.memory, // Replace with the actual icon for Chips
};

class CustomizationPage extends ConsumerStatefulWidget {
  @override
  _CustomizationPageState createState() => _CustomizationPageState();
}

class _CustomizationPageState extends ConsumerState<CustomizationPage>
    with SingleTickerProviderStateMixin {
  late TabController? _tabController;
  final Map<String, String> categories = {
    'Hats': 'hat',
    'Armors': 'armor',
    'Facials': 'facial',
    'Weapons': 'weapon',
    'Backgrounds': 'background',
    'Pets': 'pet',
    'Capes': 'cape',
    'Chips': 'chip',
  };

  Map<String, int> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final itemAsyncValue =
          ref.watch(itemProvider); // Watch the itemProvider state
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: categories.keys.map((String category) {
                  return Tab(text: category);
                }).toList(),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 5, 23, 37)),
        body: itemAsyncValue.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (List<Item> items) {
            // Organize items by category
            final Map<String, List<Item>> categoryItems = {};
            for (String category in categories.keys) {
              final String type = categories[category]!;
              categoryItems[category] = items
                  .where((item) => item.type.trim().toLowerCase() == type)
                  .toList();
            }

            return TabBarView(
              controller: _tabController,
              children: categories.keys.map((category) {
                return ItemsListWidget(
                  category: category,
                  userItems: categoryItems[category] ?? [],
                  selectedItemId: selectedItems[category],
                  onItemSelected: (itemId) {
                    setState(() {
                      selectedItems[category] = itemId!;
                    });
                  },
                   ref: ref,
                );
              }).toList(),
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

class ItemsListWidget extends StatelessWidget {
  final String category;
  final List<dynamic>
      userItems; // Assuming you have an Item model with id, name, and coin fields
  final int? selectedItemId;
  final Function(int?) onItemSelected;
  final WidgetRef ref;

  ItemsListWidget({
    Key? key,
    required this.category,
    required this.userItems, // You need to pass the user items to this widget
    required this.selectedItemId,
    required this.onItemSelected,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: userItems.length,
      itemBuilder: (context, index) {
        var item = userItems[index];

        return ItemCard(
          itemName: item.name, // Assuming 'name' is a field in your item model
          itemId: item.id, // Assuming 'id' is a field in your item model
          itemCoins: item.coin, // Pass the coin value
          isSelected: item.id == selectedItemId,
          onTap: () {
            onItemSelected(item.id);
            ref
                .read(userProvider.notifier)
                .updateEquipment(category.toLowerCase(), item.id);
          },
          ref: ref,
        );
      },
    );
  }
}

class ItemCard extends StatelessWidget {
  final String itemName;
  final int itemId;
  final int itemCoins;
  final bool isSelected;
  final VoidCallback onTap;
  final WidgetRef ref;

  ItemCard({
    Key? key,
    required this.itemName,
    required this.itemId,
    required this.itemCoins,
    required this.isSelected,
    required this.onTap,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Correct the path if your images are located in the assets folder
    String imagePath = 'assets/images/items/${itemId.toString()}.png';
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: isSelected ? 4.0 : 0.0,
            borderOnForeground: true,
            shape: isSelected
                ? RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  )
                : null,
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
              height:
                  8), // Provide some spacing between the image and the coin text
        ],
      ),
    );
  }
}
