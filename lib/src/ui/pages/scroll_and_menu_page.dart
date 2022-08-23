import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/models/product_category.dart';
import 'package:playground_app/src/providers/product_provider.dart';
import 'package:playground_app/src/ui/components/slivers/favorite/favorite_animation_component.dart';
import 'package:playground_app/src/ui/page_controllers/sliver_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';
import 'package:provider/provider.dart';

class ScrollAndMenuPage extends StatefulWidget {
  final PageArgs? args;
  const ScrollAndMenuPage(this.args, {Key? key}) : super(key: key);

  @override
  _ScrollAndMenuPageState createState() => _ScrollAndMenuPageState();
}

class _ScrollAndMenuPageState extends StateMVC<ScrollAndMenuPage>
    with TickerProviderStateMixin {
  late SliverPageController _con;

  _ScrollAndMenuPageState() : super(SliverPageController()) {
    _con = SliverPageController.con;
  }

  late ProductProvider _productProvider;

  var _maxSlide = 0.75;
  var _extraHeight = 0.1;
  late AnimationController _animationController;
  Size _screen = const Size(0, 0);
  late CurvedAnimation _animator;
  bool isVisibleEnd = false;

  @override
  void initState() {
    _productProvider = ProductProvider();
    _productProvider.init(this);
    _con.initPage(arguments: widget.args);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animator = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
      reverseCurve: Curves.easeInQuad,
    );
    isVisibleEnd = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _screen = MediaQuery.of(context).size;
    _maxSlide *= _screen.width;
    _extraHeight *= _screen.height;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _con.dispose();
    _productProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _menu3D(),
    );
  }

  _menu3D() {
    return Material(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(color: Colors.black87),
          _buildBackground(),
          _buildDrawer(),
        ],
      ),
    );
  }

  _buildBackground() => Positioned.fill(
        child: AnimatedBuilder(
          animation: _animator,
          builder: (context, widget) => Transform.translate(
            offset: Offset(_maxSlide * _animator.value, 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY((pi / 2 + 0.1) * -_animator.value),
              alignment: Alignment.centerLeft,
              child: widget,
            ),
          ),
          child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  bodyContent(),
                  IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _animator,
                      builder: (_, __) => Container(
                        color: Colors.black.withAlpha(
                          (150 * _animator.value).floor(),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );

  _buildDrawer() => Positioned.fill(
      //top: -_extraHeight,
      bottom: -_extraHeight,
      left: 0,
      right: _screen.width - _maxSlide,
      child: AnimatedBuilder(
          animation: _animator,
          builder: (context, widget) {
            return Transform.translate(
              offset: Offset(_maxSlide * (_animator.value - 1), 0),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(pi * (1 - _animator.value) / 2),
                alignment: Alignment.centerRight,
                child: widget,
              ),
            );
          },
          child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    //top: 40,
                    top: -40,
                    left: 80,
                    child: Transform.rotate(
                      angle: 90 * (pi / 180),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Silentium Apps",
                        style: TextStyle(
                          fontSize: 100,
                          color: Color(0xFFC7C0B2),
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(2.0, 0.0),
                            ),
                          ],
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isVisibleEnd = !isVisibleEnd;
                            });
                          },
                          child: Image.asset(
                            "images/product_image/logo_silentiumapps.png",
                            fit: BoxFit.contain,
                            height: 150,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _textItem("Nacho", active: true),
                        _textItem("Escopeta", active: true),
                        _textItem("Ema", active: true),
                        const SizedBox(height: 30),
                        _textItem("¡Muchas Gracias!"),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(
                          left: 10,
                          //top: _extraHeight + 10,
                          top: 10,
                          bottom: 10,
                          right: 10),
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 30,
                      color: Colors.black,
                      onPressed: _toggleDrawer,
                    ),
                  ),
                  IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _animator,
                      builder: (_, __) => Container(
                        width: _maxSlide,
                        color: Colors.black.withAlpha(
                          (150 * (1 - _animator.value)).floor(),
                        ),
                      ),
                    ),
                  ),
                ],
              ))));

  _textItem(String value, {bool active = false}) {
    return Visibility(
      visible: isVisibleEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(
            fontSize: 25,
            color: active ? const Color(0xFFBB0000) : null,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _sliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 200.0,
      collapsedHeight: 60.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          "Silentium Apps",
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        background: Image.network(
          'https://w0.peakpx.com/wallpaper/86/756/HD-wallpaper-macbook-ultra-computers-mac-dark-laptop-technology-computer-keyboard-macbook.jpg',
          fit: BoxFit.cover,
        ),
      ),
      leading: IconButton(
        alignment: Alignment.center,
        icon: const Icon(Icons.menu),
        color: Colors.white,
        onPressed: _toggleDrawer,
      ),
    );
  }

  void _toggleDrawer() {
    if (_animationController.value < 0.5) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Widget bodyContent() {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: CustomScrollView(
          controller: _productProvider.scrollController,
          slivers: <Widget>[
            _sliverAppBar(),
            SliverPersistentHeader(
              pinned: true,
              delegate: TabHeader(provider: _productProvider),
            ),
            for (var i = 0;
                i < _productProvider.listProductCategory.length;
                i++) ...[
              SliverPersistentHeader(
                delegate: MyHeaderTitle(
                  _productProvider.listProductCategory[i].category,
                ),
              ),
              SliverBodyItems(
                listItem: _productProvider.listProductCategory[i].products,
              )
            ],
          ],
        ));
  }
}

class TabComponent extends StatelessWidget {
  const TabComponent({required this.tabCategory, Key? key}) : super(key: key);

  final TabCategory tabCategory;
  @override
  Widget build(BuildContext context) {
    final selected = tabCategory.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        elevation: selected ? 6 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Text(tabCategory.productCategory.category.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ),
      ),
    );
  }
}

class CategoryItemComponent extends StatelessWidget {
  const CategoryItemComponent({this.category, Key? key}) : super(key: key);
  final ProductCategory? category;
  final categoryHeight = 55.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      child: Text(category?.category ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}

class ProductItemComponent extends StatelessWidget {
  const ProductItemComponent({this.product, Key? key}) : super(key: key);
  final Product? product;
  final productHeight = 110.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: productHeight,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 110,
                child: Image.asset(
                  product!.image,
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(product?.name ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 5),
                Text(product?.description ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10)),
                Text(product?.price ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class TabHeader extends SliverPersistentHeaderDelegate {
  TabHeader({required this.provider});

  final ProductProvider provider;
  double headerHight = 80.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Colors.white,
        height: 80,
        child: TabBar(
          onTap: provider.onCategorySelected,
          controller: provider.tabController,
          indicatorWeight: 0.1,
          isScrollable: true,
          tabs: context
              .watch<ProductProvider>()
              .tabs
              .map((e) => TabComponent(tabCategory: e))
              .toList(),
        ));
  }

  @override
  double get maxExtent => headerHight;

  @override
  double get minExtent => headerHight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class SliverBodyItems extends StatelessWidget {
  const SliverBodyItems({
    Key? key,
    required this.listItem,
  }) : super(key: key);

  final List<Product> listItem;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var product = listItem[index];
          return SizedBox(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              product.image,
                            ),
                          ),
                        ),
                        height: 140,
                        width: 130,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Stack(clipBehavior: Clip.none, children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.description,
                                maxLines: 4,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.price,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          Positioned(
                              top: -10,
                              right: -5,
                              child: FavoriteAnimationComponent(
                                isFavorite: product.isFavorite,
                                functionReturn: (
                                  bool value,
                                ) {
                                  product.isFavorite = value;
                                  ProductProvider().onPressFavorite(product);
                                },
                              ))
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        childCount: listItem.length,
      ),
    );
  }
}

class MyHeaderTitle extends SliverPersistentHeaderDelegate {
  MyHeaderTitle(
    this.title,
  );
  final String title;
  final categoryHeight = 55.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: categoryHeight,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => categoryHeight;

  @override
  double get minExtent => categoryHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
