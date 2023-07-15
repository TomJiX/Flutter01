import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'all_screens.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> cartItems = []; // Items in the cart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BasketPage(cartItems: cartItems)),
              );
            },
          ),
        ],
      ),
      body: Column( 
        children: [
          Expanded(child: LimitedListView(cartItems: cartItems)),
        ],
      ),
    );
  }
}

class LimitedListView extends StatefulWidget {
  final List<Item> cartItems; // Items in the cart

  LimitedListView({required this.cartItems});

  @override
  _LimitedListViewState createState() => _LimitedListViewState();
}

class _LimitedListViewState extends State<LimitedListView> {
  List<Item> items = []; // All items from JSON
  List<Item> filteredItems = []; // Filtered items
  List<String> filters = []; // Selected filters

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      String jsonString = await rootBundle.loadString('lib/assets/data.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      items = jsonData.map((itemJson) => Item.fromJson(itemJson)).toList();
      _filterItems();
    } catch (e) {
      print('Failed to fetch items: $e');
    }
  }

  void _filterItems() {
    if (filters.isEmpty) {
      filteredItems = List.from(items);
    } else {
      filteredItems = items.where((item) => filters.contains(item.category)).toList();
    }
    setState(() {});
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (filters.contains(filter)) {
        filters.remove(filter);
      } else {
        filters.add(filter);
      }
    });
    _filterItems();
  }

  void _addToCart(Item item) {
    setState(() {
      widget.cartItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            FilterButton(
              filter: 'Category A',
              isSelected: filters.contains('Category A'),
              onTap: _toggleFilter,
            ),
            FilterButton(
              filter: 'Category B',
              isSelected: filters.contains('Category B'),
              onTap: _toggleFilter,
            ),
            FilterButton(
              filter: 'Category C',
              isSelected: filters.contains('Category C'),
              onTap: _toggleFilter,
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return ExpansionTile(
                title: Text(item.name),
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    _addToCart(item);
                  },
                ),
                children: [
                  Text('Additional Content'),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class Item {
  final String name;
  final String category;

  Item({required this.name, required this.category});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['item'],
      category: json['category'],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String filter;
  final bool isSelected;
  final Function(String) onTap;

  FilterButton({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap(filter);
      },
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
      child: Text(
        filter,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
