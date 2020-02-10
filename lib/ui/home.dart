import 'package:flutter/material.dart';
import 'package:habits_plus/ui/habits.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentPage = 0;
  List<Widget> _pages;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pages = [
      Container(
        color: Colors.red,
      ),
      HabitsPage(),
    ];
    _pageController = PageController();
  }

  Widget _buildStoriesBox() {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.blueAccent),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.white),
          ),
          width: 47,
          height: 47,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).backgroundColor,
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Statistics
              IconButton(
                onPressed: () => setState(() {
                  _currentPage = 0;
                  _pageController.jumpToPage(_currentPage);
                }),
                icon: Icon(Icons.home),
                color: _currentPage == 0 ? Colors.black : Colors.black26,
              ),

              // Home page
              IconButton(
                onPressed: () => setState(() {
                  _currentPage = 1;
                  _pageController.jumpToPage(_currentPage);
                }),
                icon: Icon(Icons.search),
                color: _currentPage == 1 ? Colors.black : Colors.black26,
              ),

              // Add habit
              GestureDetector(
                onTap: () => print('Create new habit'),
                child: Container(
                  margin: EdgeInsets.symmetric(),
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    child: InkWell(
                      splashColor: Colors.white12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // appBar: _appBar(),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
