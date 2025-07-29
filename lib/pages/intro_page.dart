import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../components/app_header.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Bienvenido'),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset('lib/images/pokemon-gym-logo.png',
                height:240,
                ),
              ),
              const  SizedBox(height:48),
          
          
              //title
              const Text('ShoppingRD', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:20,
              ),
              ),
              const  SizedBox(height:18),
          
              //sub title
              const Text('Encuentra todo lo que necesitas en un solo lugar', style: TextStyle(
              
              fontSize:15,
              color:Colors.grey,
              ),
              textAlign: TextAlign.center,
              ),
              const  SizedBox(height:38), //my class 10 roll number 
          
          
              //shop now button
              GestureDetector(
                onTap: () {
                  context.push('/home');
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12)
                  ),
                  padding: EdgeInsets.all(25),
                  child:const Center(
                  child: const Text(
                    'Compra ahora',
                    style: TextStyle(color: Colors.white,
                    fontWeight:FontWeight.bold,
                    fontSize: 15,
                    
                    )
                  ),
                  ),
                ),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}