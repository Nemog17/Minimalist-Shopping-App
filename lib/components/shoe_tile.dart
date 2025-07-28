import 'package:flutter/material.dart';
import 'package:surja_ecommerce/models/shoe.dart';

class ShoeTile extends StatelessWidget {
  Shoe shoe;
  void Function()? onTap;
   ShoeTile({super.key, required this.shoe, required this.onTap});

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
        //shoe
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: shoe.imagePath.startsWith('http')
              ? Image.network(shoe.imagePath)
              : Image.asset(shoe.imagePath),
        ),
          

        //description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0),
          child: Text(shoe.description, style:TextStyle(color: Colors.grey[600])),
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
                Text(shoe.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                ),
                const SizedBox(height: 3),
                Text('Rs.'+shoe.price, style: TextStyle(color:Colors.grey,),),
                
          
          
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