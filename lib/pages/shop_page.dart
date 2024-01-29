import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/shoe_tile.dart';
import '../models/cart.dart';
import '../models/shoe.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  //adding shoe to cart method
  void addShoeToCart(Shoe shoe)
  {
Provider.of<Cart>(context, listen:false).addItemToCart(shoe);

//alert added successfully
showDialog(context: context, builder:(context) => AlertDialog(
  title: Text('Successfully added!'),
  content: Text('Check your cart'),
),
);
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, value, child)=>Column(
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
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
          //create a shoe
          Shoe shoe= value.getShoeList()[index];

          //return shoe
          return ShoeTile(shoe: shoe,
          onTap: () => addShoeToCart(shoe),
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