import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base_example/common/common.dart';

class ShopHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShopHomePageState();
}

class ShopHomePageState extends State<ShopHomePage>
    with SingleTickerProviderStateMixin {
  List<String> tabTitles;
  List<Widget> tabBodys;
  TabController tabController;
  var _tabCurIndex;

  @override
  void initState() {
    super.initState();
    KeyboardVisibility.onChange.listen((bool visible) {
      if (!visible) FocusScope.of(context).unfocus();
    });
    tabTitles = [
      "tab1",
      "tab2",
      "tab3",
      "tab4",
      "tab5",
      "tab6",
      "tab7",
      "tab8",
      "tab9",
    ];
    tabBodys = [
      ShopHomeBody(),
      ShopHomeBody(),
      ShopHomeBody(),
      ShopHomeBody(),
      ShopHomeBody(),
      ShopHomeBody(),
      ShopHomeBody(),
      ShopHomeBody(),
      ShopHomeBody(),
    ];
    tabController = TabController(length: tabTitles.length, vsync: this)
      ..addListener(() {
        //点击tab时会触发两次监听-https://juejin.im/post/5c9c3323e51d45360d0064f0
        if (tabController.index.toDouble() == tabController.animation.value) {
          print(tabController.index);
          setState(() {
            _tabCurIndex = tabController.index;
          });
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: _buildAppBar(context),
      body: TabBarView(controller: tabController, children: tabBodys));

  _buildAppBar(BuildContext context) => AppBar(
        //是否占用状态栏 false占用
        primary: true,
        titleSpacing: 0.0,
        toolbarOpacity: 1.0,
        bottomOpacity: 1.0,
        leading: IconButton(
          icon: Icon(Icons.mms),
          tooltip: 'Navigation menu',
          onPressed: () {},
        ),
        title: TextField(
          autofocus: false,
          textAlign: TextAlign.center,
          onSubmitted: (String text) {},
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(5),
            hintText: "小苹果",
            border: OutlineInputBorder(
//                border: InputBorder.none,
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
//                border: InputBorder.none,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.face),
            onPressed: () {},
          ),
        ],
        bottom: _buildTabBar(),
      );

  _buildTabBar() => TabBar(
//      onTap: (int index) {
//        setState(() {
//          _tabCurIndex = index;
//        });
//      },
      isScrollable: true,
      controller: tabController,
      labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      labelColor: Colors.blueAccent,
      unselectedLabelColor: Colors.black45,
      labelPadding: EdgeInsets.only(left: 20, right: 20, top: 10),
      indicatorColor: Colors.blueAccent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
          insets: EdgeInsets.only(left: 15, right: 15),
          borderSide: BorderSide(width: 4.0, color: Colors.blueAccent)),
      tabs: tabTitles
          .map((item) => Tab(
                text: tabTitles.indexOf(item).isOdd ? null : item,
                icon: tabTitles.indexOf(item).isOdd
                    ? tabTitles.indexOf(item) == _tabCurIndex
                        ? Image.network(
                            'https://img.zcool.cn/community/0372d195ac1cd55a8012062e3b16810.jpg')
                        : FlutterLogo()
                    : null,
              ))
          .toList());
}

class ShopHomeBody extends StatefulWidget {
  @override
  ShopHomeBodyState createState() => ShopHomeBodyState();
}

class ShopHomeBodyState extends State<ShopHomeBody>
    with AutomaticKeepAliveClientMixin {
  //保存tab页面状态
  @override
  bool get wantKeepAlive => true;

  final _datas = <String>[];
  List<String> tabTitles;

  @override
  void initState() {
    super.initState();
    //本地数据
    _datas.addAll(_datas.take(10));
    tabTitles = [
      "time1",
      "time2",
      "time3",
      "time4",
      "time5",
      "time6",
      "time7",
      "time8",
      "time9",
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          ShopHomeBodyTopWidget(),
          _buildStickyBar1(),
          ShopHomeBodyTopWidget(),
          _buildStickyBar2(),
          ShopHomeBodyBottomWidget(),
        ],
      ),
    );
  }

  Future _onRefresh() async {
    // 延迟3秒后添加新数据， 模拟网络加载
    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _datas.clear();
        _datas.addAll(_datas.take(20));
      });
    });
  }

  _buildStickyBar1() => SliverPersistentHeader(
        pinned: true, //是否固定在顶部
        floating: true,
        delegate: SliverAppBarDelegate(
          minHeight: 50, //收起的高度
          maxHeight: 50, //展开的最大高度
          child: DefaultTabController(
            initialIndex: 4,
            length: tabTitles.length,
            child: Material(
                color: Colors.pinkAccent,
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.black45,
                    labelPadding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    indicatorColor: Colors.blueAccent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: UnderlineTabIndicator(
                        insets: EdgeInsets.only(left: 15, right: 15),
                        borderSide:
                            BorderSide(width: 4.0, color: Colors.blueAccent)),
                    tabs: tabTitles.map((item) => Tab(text: item)).toList())),
          ),
        ),
      );

  _buildStickyBar2() => SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: false,
      delegate: SliverAppBarDelegate(
          minHeight: 50, //收起的高度
          maxHeight: 50, //展开的最大高度
          child: DefaultTabController(
            initialIndex: 4,
            length: tabTitles.length,
            child: Material(
                color: Colors.greenAccent,
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.black45,
                    labelPadding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    indicatorColor: Colors.blueAccent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: UnderlineTabIndicator(
                        insets: EdgeInsets.only(left: 15, right: 15),
                        borderSide:
                            BorderSide(width: 4.0, color: Colors.blueAccent)),
                    tabs: tabTitles
                        .map((item) => Tab(
                              text: item,
                            ))
                        .toList())),
          )));
}

class ShopHomeBodyTopWidget extends StatefulWidget {
  @override
  State createState() => ShopHomeBodyTopState();
}

class ShopHomeBodyTopState extends State<ShopHomeBodyTopWidget> {
  final _datas = [
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdafas',
    'fdafas',
    'fdafas',
    'fdafas',
    'fdafas',
  ];

  @override
  void initState() {
    super.initState();
    //本地数据
    _datas.addAll(_datas.take(10));
  }

  @override
  Widget build(BuildContext context) =>
      SliverList(delegate: SliverChildBuilderDelegate(
        (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2; //item的真实位置
          if (true) {
            //有限列表
            if (index < _datas.length) {
              //如果不判断到话，会继续绘制null条目，因为这个不加itemCount的话是无限循环绘制；不判断也可以，加上itemCount属性
              return ShopHomeBodyListItem(index, _datas[index]);
            } else
              return null;
          }
          // else {
          //    //无限列表
          //   if (index >= _datas.length) {
          //     //绘制到结尾了
          //     _datas.addAll(generateWordPairs().take(10));
          //   }
          //   return HomeBodyListItem(index, _datas[index]);
          // }
        },
      ));
}

class ShopHomeBodyBottomWidget extends StatefulWidget {
  @override
  State createState() => ShopHomeBodyBottomState();
}

class ShopHomeBodyBottomState extends State<ShopHomeBodyBottomWidget> {
  final _datas = [
    'fdasnifds',
    'fdasniffdds',
    'fdasnifds',
    'fdasnifds',
    'fdasfdsanifds',
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdasnifds',
    'fdafas',
    'fdaffdasas',
    'fdafdas',
    'fdafas',
    'fdaffeas',
  ];

  @override
  void initState() {
    super.initState();
    //本地数据
    _datas.addAll(_datas.take(10));
  }

  @override
  Widget build(BuildContext context) =>
      SliverList(delegate: SliverChildBuilderDelegate(
        (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2; //item的真实位置
          if (true) {
            //无限列表
            if (index >= _datas.length) {
              //绘制到结尾了
              _datas.addAll(_datas.take(10));
            }
            return ShopHomeBodyListItem(index, _datas[index]);
          }
          // else {
          //   //有限列表
          //   if (index < _datas.length) {
          //     //如果不判断到话，会继续绘制null条目，因为这个不加itemCount的话是无限循环绘制；不判断也可以，加上itemCount属性
          //     return HomeBodyListItem(index, _datas[index]);
          //   }
          // }
        },
      ));
}

class ShopHomeBodyListItem extends StatelessWidget {
  final String data;
  final int index;

  ShopHomeBodyListItem(this.index, this.data) : super();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Text('Column$index', style: Theme.of(context).primaryTextTheme.title),
          ListTile(
              title: Text(
                data,
                style: TextStyle(fontSize: 10.0),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(Global.shopCartsPage);
              })
        ],
      );
}
