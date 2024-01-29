import 'package:flutter/material.dart';

import 'shoe.dart';

class Cart extends ChangeNotifier{
  //list of shoes for sale
  List<Shoe> shoeShop =[
    Shoe(name: 'Max HM02', price: ' 4000', description: 'Shoe in Blue', imagePath: 'lib/images/blue.jpg'),
    Shoe(name: 'Air Jordan ', price: ' 1200', description: 'Shoe in Red', imagePath: 'lib/images/red.jpg'),
    Shoe(name: 'CP Runner', price: ' 2400', description: 'Shoe in Neon', imagePath: 'lib/images/green.jpg'),
    Shoe(name: 'Rockstar 92', price: ' 4600', description: 'Shoe in Gold', imagePath: 'lib/images/yellow.jpg'),
  ];

  //list of items in user cart

  List<Shoe> userCart=[];

  //getting list of shoes for sale
  List<Shoe> getShoeList()
  {
    return shoeShop;

  }

  //get cart
  List<Shoe> getUserCart()
  {
    return userCart;
  }

  //add items to cart
  void addItemToCart(Shoe shoe)
  {
    userCart.add(shoe);
    notifyListeners();
  }

  //remove items from cart
void removeItemFromCart(Shoe shoe)
{
  userCart.remove(shoe);
  notifyListeners();
}
}