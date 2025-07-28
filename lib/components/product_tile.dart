import 'package:flutter/material.dart';
import 'package:shopping_rd/models/product.dart';

class ProductTile extends StatelessWidget {
  Product product;
  void Function()? onTap;
  ProductTile({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.only(left:25),
      width:200,
      decoration: BoxDecoration(color:Colors.grey[100], borderRadius: BorderRadius.circular(12),
      ),
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        //product image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: product.imagePath.startsWith('http')
              ? Image.network(product.imagePath)
              : Image.asset(product.imagePath),
        ),
          

        //description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Text(product.description, style:TextStyle(color: Colors.grey[600])),
        ),

        //price details
        Padding(
          padding: const EdgeInsets.only(left:10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Column(crossAxisAlignment:CrossAxisAlignment.start ,
                children: 
              
              [
                Text(product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                ),
                const SizedBox(height: 3),
                Text('Rs.'+product.price, style: TextStyle(color:Colors.grey,),),
                
          
          
              ],),
              //plus button
              GestureDetector(
                onTap: onTap,
                child: Container( padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), bottomRight: Radius.circular(12),
                )),
                  child: Icon(Icons.add, color: Colors.white),
                  ),
              ),
          
            ]
          ),
        ),

        
        ],
      ),
    );
  }
}