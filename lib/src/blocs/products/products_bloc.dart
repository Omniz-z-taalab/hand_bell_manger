import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/products/products_event.dart';
import 'package:hand_bill_manger/src/blocs/products/products_state.dart';
import 'package:hand_bill_manger/src/data/response/product/product_details_response.dart';
import 'package:hand_bill_manger/src/repositories/products_repository.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  String tag = "ProductsBloc";
  ProductsRepository productsRepository = ProductsRepository();
  int page = 1;
  bool isFetching = true;

  ProductsBloc({required BuildContext context})
      : super(ProductsInitialState()) {
    productsRepository.company = BlocProvider.of<GlobalBloc>(context).company;
  }

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    // featured
    if (event is FetchFeaturedProductsEvent) {
      yield* _mapFetchFeaturedProducts(event);
    }

    // categories
    if (event is FetchCategoriesProductsEvent) {
      yield* _mapFetchCategoriesProducts(event);
    }

    if (event is FetchProductsByCategoryEvent) {
      yield* _mapFetchProducts(event);
    }

    // remove featured product
    if (event is RemoveFeaturedProductEvent) {
      yield* _mapRemoveFeaturedProduct(event);
    }
    // remove  product
    if (event is RemoveProductEvent) {
      yield* _mapRemoveProduct(event);
    }

    if (event is FetchProductDetails) {
      yield* _mapFetchProductDetails(event);
    }
  }

  // featured
  Stream<ProductsState> _mapFetchFeaturedProducts(
      FetchFeaturedProductsEvent event) async* {
    yield ProductsLoadingState();
    final response = await productsRepository.getFeaturedProducts(
        company: event.company, page: page);

    if (response.status!) {
      yield FeaturedProductsSuccessState(items: response.data);
      isFetching = false;
    } else {
      yield ProductsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // categories
  Stream<ProductsState> _mapFetchCategoriesProducts(
      FetchCategoriesProductsEvent event) async* {
    yield ProductsLoadingState();
    final response =
        await productsRepository.getCategoriesProducts(company: event.company);

    if (response.status!) {
      yield CategoriesProductsSuccessState(items: response.data);
      isFetching = false;
    } else {
      yield ProductsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // get products
  Stream<ProductsState> _mapFetchProducts(
      FetchProductsByCategoryEvent event) async* {
    yield ProductsLoadingState();
    final response = await productsRepository.getProductsByCategory(
        company: event.company, categoryId: event.categoryId, page: page);

    if (response.status!) {
      yield ProductsSuccessState(products: response.data);
      page++;
      isFetching = false;
    } else {
      yield ProductsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // remove featured product
  Stream<ProductsState> _mapRemoveFeaturedProduct(
      RemoveFeaturedProductEvent event) async* {
    yield ProductsLoadingState();
    final response = await productsRepository.removeFeatureProduct(
        model: event.model, company: event.company);

    if (response!.status!) {
      yield RemoveFeaturedProductsSuccessState(
          message: response.message!, model: event.model);
      isFetching = false;
    } else {
      yield ProductsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // remove  product
  Stream<ProductsState> _mapRemoveProduct(RemoveProductEvent event) async* {
    yield ProductsLoadingState();
    final response = await productsRepository.removeProduct(
        model: event.model, company: event.company);

    if (response!.status!) {
      yield RemoveProductsSuccessState(
          message: response.message!, model: event.model);
      isFetching = false;
    } else {
      yield ProductsErrorState(error: response.message);
      isFetching = false;
    }
  }

  // details
  Stream<ProductsState> _mapFetchProductDetails(
      FetchProductDetails event) async* {
    yield ProductsLoadingState();

    ProductDetailsResponse response =
        await productsRepository.getProductDetail( id:event.id!);
    if (response.status!) {
      yield ProductDetailsSuccessState(response: response);
    } else {
      yield ProductsErrorState(error: response.message);
    }
  }
}
