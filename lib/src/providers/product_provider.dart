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

  final collapsedHeight = 60.0;
  final tabHeight = 80.0;
  final heightTabCollapsed = 140.0;

  final productHeight = 180.0;
  final categoryHeight = 55.0;

  final productsPizza = [
    Product(
      name: 'Pizza',
      image: 'images/product_image/pizza1.jpg',
      description:
          'La pizza es un plato salado de origen italiano que consiste en una base generalmente redonda y aplanada de masa a base de trigo con levadura para hornear.',
      price: '\$1800',
    ),
    Product(
      name: 'Pizza',
      image: 'images/product_image/pizza2.jpg',
      description:
          'La pizza es un plato salado de origen italiano que consiste en una base generalmente redonda y aplanada de masa a base de trigo con levadura para hornear.',
      price: '\$1900',
    ),
    Product(
      name: 'Pizza',
      image: 'images/product_image/pizza3.jpg',
      description:
          'La pizza es un plato salado de origen italiano que consiste en una base generalmente redonda y aplanada de masa a base de trigo con levadura para hornear.',
      price: '\$1800',
    ),
    Product(
      name: 'Pizza',
      image: 'images/product_image/pizza4.jpg',
      description:
          'La pizza es un plato salado de origen italiano que consiste en una base generalmente redonda y aplanada de masa a base de trigo con levadura para hornear.',
      price: '\$1800',
    ),
    Product(
      name: 'Pizza',
      image: 'images/product_image/pizza5.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$2000',
    ),
  ];

  final productsPostres = [
    Product(
      name: 'Torta de Chocolate',
      image: 'images/product_image/choclate_cake.jpg',
      description:
          'La torta de chocolate es una torta con sabor a chocolate derretido, cacao o ambos.',
      price: '\$2000',
    ),
    Product(
      name: 'Cookies',
      image: 'images/product_image/cookies.jpg',
      description:
          'Una galleta es un producto alimenticio horneado a base de harina, suele ser dura, plana y con mucho sabor.',
      price: '\$500',
    ),
    Product(
      name: 'Brownie De Chocolate',
      image: 'images/product_image/postre2.jpeg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$2000',
    ),
    Product(
      name: 'Torta de Chocolate',
      image: 'images/product_image/postre3.jpg',
      description:
          'La torta de chocolate es una torta con sabor a chocolate derretido, con helado.',
      price: '\$2000',
    ),
    Product(
      name: 'Tarta de Frutilla',
      image: 'images/product_image/postre5.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$2000',
    ),
  ];

  // final products = [
  //   Product(
  //     name: 'Torta de Chocolate',
  //     image: 'images/product_image/choclate_cake.jpg',
  //     description:
  //         'La torta de chocolate es una torta con sabor a chocolate derretido, cacao o ambos.',
  //     price: '\$2000',
  //   ),
  //   Product(
  //     name: 'Pizza',
  //     image: 'images/product_image/pizza1.jpg',
  //     description:
  //         'La pizza es un plato salado de origen italiano que consiste en una base generalmente redonda y aplanada de masa a base de trigo con levadura para hornear.',
  //     price: '\$1800',
  //   ),
  //   Product(
  //     name: 'Cookies',
  //     image: 'images/product_image/cookies.jpg',
  //     description:
  //         'Una galleta es un producto alimenticio horneado a base de harina, suele ser dura, plana y con mucho sabor.',
  //     price: '\$500',
  //   ),
  //   Product(
  //     name: 'Sandwich',
  //     image: 'images/product_image/sandiwch.png',
  //     description:
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
  //     price: '\$500',
  //   ),
  //   Product(
  //     name: 'French Fries',
  //     image: 'images/product_image/french_fries.jpeg',
  //     description:
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
  //     price: '\$400',
  //   ),
  //   Product(
  //     name: 'Ceviche',
  //     image: 'images/product_image/ceviche.jpg',
  //     description:
  //         'Los ingredientes básicos son el pescado blanco (aunque se puede hacer con mariscos o una mezcla de ambos), lima, cebolla morada, cilantro y sal.',
  //     price: '\$1500',
  //   ),
  // ];

  final productsPasta = [
    Product(
      name: 'Noquis',
      image: 'images/product_image/pasta1.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$2000',
    ),
    Product(
      name: 'Ravioles',
      image: 'images/product_image/pasta2.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$2000',
    ),
    Product(
      name: 'Tallarines con Salsa',
      image: 'images/product_image/pasta3.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$2000',
    ),
    Product(
      name: 'Sorrentinos',
      image: 'images/product_image/pasta4.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$2000',
    ),
    Product(
      name: 'Tallarines con Salsa',
      image: 'images/product_image/pasta5.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$2000',
    ),
  ];

  final productsEntrada = [
    Product(
      name: 'Sandwich',
      image: 'images/product_image/sandiwch.png',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$500',
    ),
    Product(
      name: 'Papas Fritas',
      image: 'images/product_image/french_fries.jpeg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$700',
    ),
    Product(
      name: 'Rabas',
      image: 'images/product_image/entrada1.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$1200',
    ),
    Product(
      name: 'Emapanadas',
      image: 'images/product_image/entrada2.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$1000',
    ),
    Product(
      name: 'Provoleta',
      image: 'images/product_image/entrada3.jpg',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      price: '\$1000',
    ),
  ];

  bool processScroll = false;

  @override
  // ignore: must_call_super
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    listProductCategory = [];
    tabs = [];
  }

  init(TickerProvider ticker) {
    processScroll = false;
    scrollController = ScrollController();

    // final productsTwo = [...products];
    // final productsThree = [...products];
    // final productsFour = [...products];

    // productsTwo.shuffle();
    // productsThree.shuffle();
    // productsFour.shuffle();

    listProductCategory = [
      ProductCategory(
        id: 1,
        category: 'Entradas',
        products: productsEntrada,
      ),
      ProductCategory(
        id: 2,
        category: 'Pizzas',
        products: productsPizza,
      ),
      ProductCategory(
        id: 3,
        category: 'Pastas',
        products: productsPasta,
      ),
      ProductCategory(
        id: 4,
        category: 'Postre',
        products: productsPostres,
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
    if (!processScroll) {
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
  }

  void onCategorySelected(int index, {bool animationRequired = true}) async {
    final selected = tabs[index];
    for (int i = 0; i < tabs.length; i++) {
      tabs[i] = tabs[i].copyWith(selected == tabs[i]);
    }

    notifyListeners();

    if (animationRequired) {
      processScroll = true;
      await scrollController.animateTo(selected.offsetFrom,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
      processScroll = false;
    }
  }

  onPressFavorite(Product value) {
    // listProductCategory[0].products.where((element) => element.name == value.name).first.isFavorite == value.isFavorite;
    // notifyListeners();
  }
}
