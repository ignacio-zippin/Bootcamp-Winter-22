import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/src/models/product_category.dart';
import 'package:playground_app/utils/page_args.dart';

class StickyHeaderPageController extends ControllerMVC implements IViewController {
  static late StickyHeaderPageController _this;

  factory StickyHeaderPageController() {
    _this = StickyHeaderPageController._();
    return _this;
  }

  static StickyHeaderPageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  StickyHeaderPageController._();

  late List<ProductCategory> listProductCategory;

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
  void initPage({PageArgs? arguments}) {
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
  }

  @override
  disposePage() {}

  onPressBack() {
    PageManager().goBack();
  }
}
