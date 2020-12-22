import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './home_screen.dart';
import './login_screen.dart';
import '../constants.dart';
import '../providers/auth.dart';
import '../screens/account_screen.dart';
import '../screens/courses_screen.dart';
import '../screens/my_courses_screen.dart';
import '../screens/my_wishlist_screen.dart';
import '../widgets/filter_widget.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Widget> _pages = [
    HomeScreen(),
    LoginScreen(),
    LoginScreen(),
    LoginScreen(),
  ];
  var _isInit = true;
  // ignore: unused_field
  var _isLoading = false;

  int _selectedPageIndex = 0;
  bool _isSearching = false;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Provider.of<Auth>(context).tryAutoLogin().then((_) {});
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      final _isAuth = Provider.of<Auth>(context, listen: false).isAuth;

      if (_isAuth) {
        _pages = [
          HomeScreen(),
          MyCoursesScreen(),
          MyWishlistScreen(),
          AccountScreen(),
        ];
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void _handleSubmitted(String value) {
    final searchText = searchController.text;
    if (searchText.isEmpty) {
      return;
    }

    searchController.clear();
    Navigator.of(context).pushNamed(
      CoursesScreen.routeName,
      arguments: {
        'category_id': null,
        'seacrh_query': searchText,
        'type': CoursesPageData.Search,
      },
    );
    // print(searchText);
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showFilterModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return FilterWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 32,
              )
            : TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tìm kiếm tại đây',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                controller: searchController,
                onFieldSubmitted: _handleSubmitted,
              ),
        backgroundColor: kBackgroundColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: kSecondaryColor,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }),
        ],
      ),
      body: _pages[_selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterModal(context),
        child: Icon(Icons.filter_list),
        backgroundColor: kDarkButtonBg,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.school),
            // ignore: deprecated_member_use
            title: Text('Khoá học'),
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.shopping_basket),
            // ignore: deprecated_member_use
            title: Text('Khoá học của tôi'),
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.favorite_border),
            // ignore: deprecated_member_use
            title: Text('Danh sách yêu thích'),
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.account_circle),
            // ignore: deprecated_member_use
            title: Text('Tài khoản'),
          ),
        ],
        backgroundColor: kBackgroundColor,
        unselectedItemColor: kSecondaryColor,
        selectedItemColor: kSelectItemColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
