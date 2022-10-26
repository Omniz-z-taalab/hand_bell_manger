import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hand_bill_manger/src/blocs/products/products_bloc.dart';
import 'package:hand_bill_manger/src/blocs/products/products_event.dart';
import 'package:hand_bill_manger/src/blocs/products/products_state.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/screens/details_package/product_details/product_details_board.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = "/productDetailsScreen";
  final RouteArgument routeArgument;

  ProductDetailsScreen({required this.routeArgument});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Product _product;

  double? price = 0.0;
  late ProductsBloc _productsBloc;
  int? _productId;

  @override
  void initState() {
    _productId = widget.routeArgument.param;
    _product = Product();
    // _product = Product(id: 12);

    _productsBloc = BlocProvider.of<ProductsBloc>(context);
    _productsBloc..add(FetchProductDetails(id: _productId));
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RegularAppBar(label: "Product Details"),
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _productsBloc.add(FetchProductDetails(id: _productId));
              });
            },
            child: MultiBlocListener(
                listeners: [
                  BlocListener<ProductsBloc, ProductsState>(
                      listener: (context, state) {
                    if (state is ProductDetailsSuccessState) {
                      setState(() {
                        _product = state.response!.data!;
                        // price = state.response!.data!.price;
                      });
                    }
                    if (state is ProductsErrorState) {
                      Fluttertoast.showToast(msg: state.error!);
                    }
                  }),
                ],
                child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      _product.name == null
                          ? SliverFillRemaining(
                              child: Center(child: CircularProgressIndicator()))
                          : ProductDetailsBoard(model: _product)
                    ]))));
  }
}
