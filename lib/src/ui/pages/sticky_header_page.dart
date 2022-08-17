import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/models/product_category.dart';
import 'package:playground_app/src/providers/product_provider.dart';
import 'package:playground_app/src/ui/components/appbar/custom_navigation_bar_component.dart';
import 'package:playground_app/src/ui/page_controllers/sticky_header_page_controller.dart';
import 'package:playground_app/utils/page_args.dart';

class StickyHeaderPage extends StatefulWidget {
  final PageArgs? args;
  const StickyHeaderPage(this.args, {Key? key}) : super(key: key);

  @override
  _StickyHeaderPageState createState() => _StickyHeaderPageState();
}

class _StickyHeaderPageState extends StateMVC<StickyHeaderPage>
    with SingleTickerProviderStateMixin {
  late StickyHeaderPageController _con;

  _StickyHeaderPageState() : super(StickyHeaderPageController()) {
    _con = StickyHeaderPageController.con;
  }

  static const _backgroundColor = Color(0xFFF6F9FA);
  static const _blueColor = Color(0xFF0D1863);
  static const _greenColor = Color(0xFF2BBEBA);
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
    //_productProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Theme(
    //   data: ThemeData.dark(),
    //   child: Scaffold(body: _body()),
    // );

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: 200.0,
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
              ),
            ];
          },
          body: _body()),
    );
  }

  Widget _body() {
    return AnimatedBuilder(
      animation: _productProvider,
      builder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            height: 80,
            child: Row(children: const [
              Text('HomePage'),
            ]),
          ),
          SizedBox(
              height: 80,
              child: TabBar(
                onTap: _productProvider.onCategorySelected,
                controller: _productProvider.tabController,
                indicatorWeight: 0.1,
                isScrollable: true,
                tabs: _productProvider.tabs
                    .map((e) => TabComponent(tabCategory: e))
                    .toList(),
              )),
          Expanded(
            child: ListView.builder(
                controller: _productProvider.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _productProvider.items.length,
                itemBuilder: (context, index) {
                  final item = _productProvider.items[index];
                  if (item.isCategory) {
                    return CategoryItemComponent(
                        category: item.productCategory);
                  } else {
                    return ProductItemComponent(product: item.product);
                  }
                }),
          ),
        ],
      ),
    );
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(tabCategory.productCategory.category.toString(),
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
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
