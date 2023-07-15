import 'package:flutter/material.dart';
import 'all_screens.dart';
import 'package:flutter/widgets.dart';

class BasketPage extends StatelessWidget {
  final List<Item> cartItems; // Items in the cart
  const BasketPage({Key? key, required this.cartItems}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.category),
          );
        },
      ),
    );
  }
}
