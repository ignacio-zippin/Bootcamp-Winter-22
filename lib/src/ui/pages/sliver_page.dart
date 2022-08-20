import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/models/product_category.dart';
import 'package:playground_app/src/providers/product_provider.dart';
import 'package:playground_app/src/ui/page_controllers/sliver_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';
import 'package:provider/provider.dart';

class SliverPage extends StatefulWidget {
  final PageArgs? args;
  const SliverPage(this.args, {Key? key}) : super(key: key);

  @override
  _SliverPageState createState() => _SliverPageState();
}

class _SliverPageState extends StateMVC<SliverPage>
    with SingleTickerProviderStateMixin {
  late SliverPageController _con;

  _SliverPageState() : super(SliverPageController()) {
    _con = SliverPageController.con;
  }

  late ProductProvider _productProvider;

  @override
  void initState() {
    _productProvider = ProductProvider();
    _productProvider.init(this);
    _con.initPage(arguments: widget.args);
    super.initState();
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
      body: bodyContent(),
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
    );
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

  // FirstVersion
  // Widget _body() {
  //   return AnimatedBuilder(
  //     animation: _productProvider,
  //     builder: (_, __) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Container(
  //           color: Colors.white,
  //           height: 80,
  //           child: Row(children: const [
  //             Text('HomePage'),
  //           ]),
  //         ),
  //         SizedBox(
  //             height: 80,
  //             child: TabBar(
  //               onTap: _productProvider.onCategorySelected,
  //               controller: _productProvider.tabController,
  //               indicatorWeight: 0.1,
  //               isScrollable: true,
  //               tabs: _productProvider.tabs
  //                   .map((e) => TabComponent(tabCategory: e))
  //                   .toList(),
  //             )),
  //         Expanded(
  //           child: ListView.builder(
  //               controller: _productProvider.scrollController,
  //               padding: const EdgeInsets.symmetric(horizontal: 20),
  //               itemCount: _productProvider.items.length,
  //               itemBuilder: (context, index) {
  //                 final item = _productProvider.items[index];
  //                 if (item.isCategory) {
  //                   return CategoryItemComponent(
  //                       category: item.productCategory);
  //                 } else {
  //                   return ProductItemComponent(product: item.product);
  //                 }
  //               }),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
          // Text(product?.name?? '',
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold, fontSize: 13)),
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
          final product = listItem[index];
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
                        child: Column(
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
