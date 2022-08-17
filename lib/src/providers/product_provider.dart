import 'package:flutter/material.dart';
import 'package:playground_app/src/models/product_category.dart';

class ProductProvider with ChangeNotifier {
  static final ProductProvider _instance = ProductProvider._constructor();

  factory ProductProvider() {
    return _instance;
  }

  ProductProvider._constructor();

  List<TabCategory> tabs = [];
  List<Item> items = [];
  late List<ProductCategory> listProductCategory;
  late TabController tabController;
  late ScrollController scrollController;

  bool _listen = true;

  final productHeight = 110.0;
  final categoryHeight = 55.0;

  final products = [
    Product(
      name: 'Choclate Cake',
      image: 'images/product_image/choclate_cake.png',
      description:
          'Chocolate cake of chocolate gateau is a cake flavored with meited chocolate, cocoa powder, or both.',
      price: '\$19',
    ),
    Product(
      name: 'Pizza',
      image: 'images/product_image/pizza.jpg',
      description:
          'Pizza is a savory dish of Italian origin consisting of a usually round, flattened base of leavened wheat-based dough to bake.',
      price: '\$39',
    ),
    Product(
      name: 'Cookies',
      image: 'images/product_image/cookies.jpg',
      description:
          'A biscuit is a flour-based baked food product. Out side North America the biscuit is typically hard, flat, and much sabors.',
      price: '\$10',
    ),
    Product(
      name: 'Sandwich',
      image: 'images/product_image/sandiwch.png',
      description:
          'Trim bread from all sides and apply butter on one breast, then apply the green chutney all over.',
      price: '\$9',
    ),
    Product(
      name: 'French Fries',
      image: 'images/product_image/french_fries.jpg',
      description:
          'French fries, or simply fries, chips, finger chips, or french-fried potatoes, are potatoes cut up and put in a pot with oil.',
      price: '\$15',
    ),
    Product(
      name: 'Ceviche',
      image: 'images/product_image/ceviche.jpeg',
      description:
          'The basic ingredients are white fish (although it can be made with shellfish or a mixture of both), lime, red onion, cilantro, and salt. In Central America it is common to accompany it with soda crackers or lettuce.',
      price: '\$20',
    ),
  ];

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  init(TickerProvider ticker) {
    scrollController = ScrollController();

    final productsTwo = [...products];
    final productsThree = [...products];
    final productsFour = [...products];

    productsTwo.shuffle();
    productsThree.shuffle();
    productsFour.shuffle();

    listProductCategory = [
      ProductCategory(
        id: 1,
        category: 'Order Again',
        products: products,
      ),
      ProductCategory(
        id: 2,
        category: 'Picked For You',
        products: productsTwo,
      ),
      ProductCategory(
        id: 3,
        category: 'Startes',
        products: productsThree,
      ),
      ProductCategory(
        id: 4,
        category: 'Gimpub Sushi',
        products: productsFour,
      ),
    ];

    double offsetFrom = 0;
    double offsetTo = 0;
    for (int i = 0; i < listProductCategory.length; i++) {
      final category = listProductCategory[i];

      if (i > 0) {
        offsetFrom +=
            listProductCategory[i - 1].products.length * productHeight;
      }

      if (i < listProductCategory.length - 1) {
        offsetTo = offsetFrom +
            listProductCategory[i + 1].products.length +
            productHeight;
      } else {
        offsetTo = double.infinity;
      }

      tabs.add(TabCategory(
        productCategory: category,
        selected: (i == 0),
        offsetFrom: categoryHeight * i + offsetFrom,
        offsetTo: offsetTo,
      ));

      items.add(Item(productCategory: category));
      for (var j = 0; j < category.products.length; j++) {
        final product = category.products[j];
        items.add(Item(product: product));
      }
    }

    tabController =
        TabController(vsync: ticker, length: listProductCategory.length);

    scrollController.addListener(_onScrollListener);
  }

  void _onScrollListener() {
    for (int i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      if (scrollController.offset >= tab.offsetFrom &&
          scrollController.offset <= tab.offsetTo &&
          !tab.selected) {
        onCategorySelected(i, animationRequired: false);
        tabController.animateTo(i);
        break;
      }
    }
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      tabs[i] = tabs[i].copyWith(selected == tabs[i]);
    }

    notifyListeners();

    if (animationRequired) {
      _listen = false;
      await scrollController.animateTo(selected.offsetFrom,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
      _listen = true;
    }
  }
}
