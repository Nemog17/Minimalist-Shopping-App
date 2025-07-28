import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/product_tile.dart';
import '../models/cart.dart';
import '../models/product.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool _isLoading = true;

  //adding product to cart method
  void addProductToCart(Product product)
  {
Provider.of<Cart>(context, listen:false).addItemToCart(product);

//alert added successfully
showDialog(context: context, builder:(context) => AlertDialog(
  title: Text('Successfully added!'),
  content: Text('Check your cart'),
),
);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Cart>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, value, child) => _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
      children: [
        //search bar
        Container( 
          padding:EdgeInsets.all(12),
          margin:EdgeInsets.symmetric(horizontal: 25),
          decoration:BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8.0)),
          child: 
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text('Search', style: TextStyle(color:Colors.grey)),
             Icon(Icons.search, color: Colors.grey,),
           ],
         ),),

        // message
        Padding(
          padding: const EdgeInsets.symmetric(vertical:20),
          child: Text('  Demo E-Commerce app built from scratch by Surja Sekhar Sengupta', style: TextStyle(color:Colors.grey[500]),),
        ),

        // flamin hot picks, just like torchics 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:25.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
            Text('Hot Picks 🔥', style: TextStyle(fontWeight: FontWeight.bold, fontSize:24,)),
            Text('See all', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
            ],
            ),
        ),

        const SizedBox(height:10),

        Expanded(child: ListView.builder(
          itemCount: value.getProductList().length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
          //create a product
          Product product = value.getProductList()[index];

          //return product
          return ProductTile(product: product,
          onTap: () => addProductToCart(product),
          );

        },
        ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:5,left:5,right:5),
          child: Divider(
            color:Colors.white,
          ),
        )
      ],
    )
    );
    
  }
}