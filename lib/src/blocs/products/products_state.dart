import 'package:equatable/equatable.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';
import 'package:hand_bill_manger/src/data/model/product/product_category.dart';
import 'package:hand_bill_manger/src/data/response/product/product_details_response.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitialState extends ProductsState {}

class ProductsLoadingState extends ProductsState {}

class ProductsErrorState extends ProductsState {
  final String? error;

  ProductsErrorState({required this.error});
}

// fetch featured
class FeaturedProductsSuccessState extends ProductsState {
  final List<Product>? items;

  FeaturedProductsSuccessState({required this.items});
}

// fetch categories
class CategoriesProductsSuccessState extends ProductsState {
  final List<CategoryProduct>? items;

  CategoriesProductsSuccessState({required this.items});
}

// fetch my product
class ProductsSuccessState extends ProductsState {
  final List<Product>? products;

  ProductsSuccessState({required this.products});
}

// remove feature product
class RemoveFeaturedProductsSuccessState extends ProductsState {
  final Product model;
  final String? message;

  RemoveFeaturedProductsSuccessState(
      {required this.model, required this.message});
}

// remove  product
class RemoveProductsSuccessState extends ProductsState {
  final Product model;
  final String? message;

  RemoveProductsSuccessState({required this.model, required this.message});
}

// fetch details

class ProductDetailsSuccessState extends ProductsState {
  final ProductDetailsResponse? response;

  ProductDetailsSuccessState({this.response});
}
