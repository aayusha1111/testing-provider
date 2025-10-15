import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/login/provider/test_provider.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<TestProvider>(
        builder: (context, testProvider, child) => Column(
          children: [
            Text("${testProvider.a}"),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    testProvider.increaseValue();
                  },
                  child: Text("Add"),
                ),

                ElevatedButton(
                  onPressed: () {
                    testProvider.decreaseValue();
                  },
                  child: Text("Subtract"),
                ),
              ],
            ),

            TextFormField(
              decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: (){
                  testProvider.showPassword();
                },
                 icon: Icon(testProvider.passwordVisibilty?Icons.visibility:Icons.visibility_off)),
                 border: OutlineInputBorder(),
                 
              ),
            )
          ],

        
        ),
      ),
    );
  }
}
