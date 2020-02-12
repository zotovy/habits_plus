import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
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

    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      _pages = [
        Container(
          color: Theme.of(context).backgroundColor,
        ),
        HabitsPage(),
      ];
    }
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
                color: _currentPage == 0
                    ? Theme.of(context).textSelectionHandleColor
                    : Theme.of(context).disabledColor.withOpacity(0.25),
              ),

              // Home page
              IconButton(
                onPressed: () => setState(() {
                  _currentPage = 1;
                  _pageController.jumpToPage(_currentPage);
                }),
                icon: Icon(Icons.search),
                color: _currentPage == 1
                    ? Theme.of(context).textSelectionHandleColor
                    : Theme.of(context).disabledColor.withOpacity(0.25),
              ),

              // Add habit
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'createHabit_page'),
                child: Container(
                  margin: EdgeInsets.symmetric(),
                  width: AppLocalizations.of(context).lang == 'ru' ? 125 : 90,
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
                            AppLocalizations.of(context).translate('add'),
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
