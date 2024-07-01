import 'package:flutter/material.dart';

class UserGuidePage extends StatefulWidget {
  @override
  _UserGuidePageState createState() => _UserGuidePageState();
}

class _UserGuidePageState extends State<UserGuidePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _guideContent = [
    {'image': 'assets/image1.png', 'description': 'On the mani page'},
    {'image': 'assets/image2.png', 'description': 'Description for Image 2'},
    {'image': 'assets/image3.png', 'description': 'Description for Image 3'},
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _guideContent.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    _guideContent[index]['image']!,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  _guideContent[index]['description']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (index > 0)
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: Text('Previous'),
                          color: Colors.grey[300],
                          height: 50,
                        ),
                      ),
                    if (index > 0) SizedBox(width: 10),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          if (index < _guideContent.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          } else {
                            // End guide or navigate to the main part of the app
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          index < _guideContent.length - 1 ? 'Next' : 'End Guide',
                        ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
