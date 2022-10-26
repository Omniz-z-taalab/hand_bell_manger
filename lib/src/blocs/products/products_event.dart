import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';

abstract class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// fetch featured
class FetchFeaturedProductsEvent extends ProductsEvent {
  final Company company;

  FetchFeaturedProductsEvent({required this.company});
}

// fetch categories
class FetchCategoriesProductsEvent extends ProductsEvent {
  final Company company;

  FetchCategoriesProductsEvent({required this.company});
}

// fetch products
class FetchProductsByCategoryEvent extends ProductsEvent {
  final Company company;
  final int categoryId;

  FetchProductsByCategoryEvent(
      {required this.company, required this.categoryId});
}

// remove featured product
class RemoveFeaturedProductEvent extends ProductsEvent {
  final Company company;
  final Product model;

  RemoveFeaturedProductEvent({required this.company, required this.model});
}

// remove product
class RemoveProductEvent extends ProductsEvent {
  final Company company;
  final Product model;

  RemoveProductEvent({required this.company, required this.model});
}

// fetch details

class FetchProductDetails extends ProductsEvent {
  final int? id;

  FetchProductDetails({required this.id});
}
