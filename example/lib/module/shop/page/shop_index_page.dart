import 'package:flutter/material.dart';
import 'package:flutter_base_example/common/common.dart';
import 'package:flutter_base_example/module/module.dart';

class ShopIndexPage extends StatefulWidget {
  @override
  State createState() => ShopIndexPageState();
}

class ShopIndexPageState extends State<ShopIndexPage> {
  int currentIndex = 0;
  List<Widget> mainPages;
  List<BottomNavigationBarItem> mainNaviItems;
  var badge = BadgeWidget(
    icon: Icon(Icons.shopping_cart),
    num: 0,
  );

  @override
  void initState() {
    super.initState();
    mainPages = [
      ShopHomePage(),
      ShopCategoryPage(),
      ShopMyShopPage(),
      ShopCartsPage(),
      ShopMinePage(),
    ];
    mainNaviItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('首页'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.category),
        title: Text('分类'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shop),
        title: Text('店铺'),
      ),
      BottomNavigationBarItem(
        icon: badge,
        title: Text('购物车'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        title: Text('我的'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        //IndexedStack会初始化所有的页面，并且保存状态
        body: IndexedStack(
          index: currentIndex,
          children: mainPages,
        ),
        //每次都会重建页面
//      body: mainPages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          fixedColor: Colors.blueAccent,
          selectedFontSize: 13.0,
          unselectedFontSize: 13.0,
          type: BottomNavigationBarType.fixed,
          items: mainNaviItems,
          onTap: onNaviItemSelect,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: Icon(Icons.add),
          onPressed: () {
            //重新创建首页
//            Navigator.pushNamedAndRemoveUntil(
//                context, '/mainPage', (Route route) => false);
            badge.num++;
            setState(() {
              if (mainNaviItems.length == 5) {
                mainPages.removeAt(2);
                mainNaviItems.removeAt(2);
              } else {
                mainPages.insert(2, ShopMyShopPage());
                mainNaviItems.insert(
                    2,
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shop),
                      title: Text('店铺'),
                    ));
              }
              currentIndex = 0;
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );

  void onNaviItemSelect(int index) => setState(() => currentIndex = index);
}
