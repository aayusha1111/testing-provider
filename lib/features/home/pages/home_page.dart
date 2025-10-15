import 'package:flutter/material.dart';
import 'package:provider_test/features/home/provider/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 140, // fixed height for horizontal menu
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeList.length,
            itemBuilder: (context, index) {
              final home = homeList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     IconButton(
                      icon: Icon(home.icon, size: 25),
                      onPressed: () {
                        if (home.page != null){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) =>home.page!),
                        );}
                      },
                    ),
                    const SizedBox(height: 8), // spacing between icon and text
                    Text(
                      home.homeText ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
