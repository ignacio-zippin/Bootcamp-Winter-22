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

  late bool _listen;

  final collapsedHeight = 60.0;
  final tabHeight = 80.0;
  final heightTabCollapsed = 140.0;

  final productHeight = 180.0;
  final categoryHeight = 55.0;

  final products = [
    Product(
      name: 'Torta de Chocolate',
      image: 'images/product_image/choclate_cake.jpg',
      description:
          'La torta de chocolate es una torta con sabor a chocolate derretido, cacao o ambos.',
      price: '\$2000',
    ),
    Product(
      name: 'Pizza',
      image: 'images/product_image/pizza.jpg',
      description:
          'La pizza es un plato salado de origen italiano que consiste en una base generalmente redonda y aplanada de masa a base de trigo con levadura para hornear.',
      price: '\$1800',
    ),
    Product(
      name: 'Cookies',
      image: 'images/product_image/cookies.jpg',
      description:
          'Una galleta es un producto alimenticio horneado a base de harina, suele ser dura, plana y con mucho sabor.',
      price: '\$500',
    ),
    Product(
      name: 'Sandwich',
      image: 'images/product_image/sandiwch.png',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$500',
    ),
    Product(
      name: 'French Fries',
      image: 'images/product_image/french_fries.jpeg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$400',
    ),
    Product(
      name: 'Ceviche',
      image: 'images/product_image/ceviche.jpg',
      description:
          'Los ingredientes básicos son el pescado blanco (aunque se puede hacer con mariscos o una mezcla de ambos), lima, cebolla morada, cilantro y sal.',
      price: '\$1500',
    ),
  ];

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    listProductCategory = [];
    tabs = [];
    // super.dispose();
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
        category: 'Pizzas',
        products: products,
      ),
      ProductCategory(
        id: 2,
        category: 'Sandwich',
        products: productsTwo,
      ),
      ProductCategory(
        id: 3,
        category: 'Entrada',
        products: productsThree,
      ),
      ProductCategory(
        id: 4,
        category: 'Postre',
        products: productsFour,
      ),
    ];
    _listen = true;
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
        offsetFrom: heightTabCollapsed + categoryHeight * i + offsetFrom,
        offsetTo: heightTabCollapsed + offsetTo,
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
