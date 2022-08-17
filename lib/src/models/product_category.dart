class ProductCategory {
  final int id;
  final String category;
  final List<Product> products;

  ProductCategory({
    required this.id,
    required this.category,
    required this.products,
  });
}

class Product {
  final String name;
  final String image;
  final String description;
  final String price;

  Product({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
  });
}

class TabCategory {
  final ProductCategory productCategory;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;

  TabCategory({
    required this.productCategory,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });

  TabCategory copyWith(bool selectedNew) => TabCategory(
      productCategory: productCategory,
      selected: selectedNew,
      offsetFrom: offsetFrom,
      offsetTo: offsetTo);
}

class Item {
  final ProductCategory? productCategory;
  final Product? product;

  Item({
    this.productCategory,
    this.product,
  });

  bool get isCategory => productCategory != null;
}
