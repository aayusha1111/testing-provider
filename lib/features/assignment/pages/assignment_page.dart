import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/dashboard/presentation/dashboard.dart';
import 'package:provider_test/features/assignment/pages/add_assignment.dart';
import 'package:provider_test/features/assignment/pages/assigned_page.dart';
import 'package:provider_test/features/assignment/pages/submitted_page.dart';
import 'package:provider_test/features/assignment/provider/assignment_provider.dart';
import 'package:provider_test/features/core/utils/constants/app_color.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  int _selectedIndex = 0; 
  PageController pageController = PageController();

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentProvider>(
      builder: (context, value, child) =>  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
        Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Dashboard()),
              (Route<dynamic> route) => false,
            );
          }, icon: Icon(Icons.arrow_back_ios)),
          title: Text("Assignment",),
        ),
        body: Column(
          children: [
            
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 InkWell(
                   onTap: () => _onTabTapped(0), // Calls the navigation handler
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: Column(
                       children: [
                         Icon(Icons.edit_note,size: 40,),
                         Text(
                           "Assigned",
                           style: TextStyle(
                             color: _selectedIndex == 0 ? secondaryColor : Colors.grey,
                             fontWeight: FontWeight.bold,
                             
                           ),
                         ),
                         const SizedBox(height: 8),
                         // The active tab indicator line
                         Container(
                           height: 3,
                           width: 80, // Adjust width as needed
                           color: _selectedIndex == 0 ? secondaryColor : Colors.transparent,
                         ),
                       ],
                     ),
                   ),
                 ),
                       
                 // Add horizontal space between the tabs
                 const SizedBox(width: 40), // Creates the visual "farther" effect
                       
                 // 2. Submitted Button/Tab
                 InkWell(
                   onTap: () => _onTabTapped(1), // Calls the navigation handler
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                     child: Column(
                       children: [
                         Icon(Icons.description,size: 35,),
                         Text(
                           
                           "Submitted",
                           style: TextStyle(
                             color: _selectedIndex == 1 ? secondaryColor : Colors.grey,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         const SizedBox(height: 8),
                         // The active tab indicator line
                         Container(
                           height: 3,
                           width: 80,
                           color: _selectedIndex == 1 ? secondaryColor : Colors.transparent,
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
      
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      _selectedIndex = value; // Only need to update the index
                    });
                  },
                  controller: pageController,
                  children: [AssignedPage(), SubmittedPage()],
                ),
              ),
            ),
          ],
        ),
      
      floatingActionButton: Consumer<UserRoleProvider>(
        builder: (context, roleProvider, _) {
          if (!roleProvider.isLoaded) return SizedBox.shrink(); 
      if (roleProvider.role == "admin" || roleProvider.role == "teacher") {
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  AddAssignment(),
              ),
            );
          },
          backgroundColor: secondaryColor,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        );
      } else {
        return SizedBox.shrink();
      }
        },
      )
      ),
    );
  }
}