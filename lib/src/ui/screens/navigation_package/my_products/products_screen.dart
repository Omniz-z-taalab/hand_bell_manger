import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/products/products_bloc.dart';
import 'package:hand_bill_manger/src/blocs/products/products_event.dart';
import 'package:hand_bill_manger/src/blocs/products/products_state.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';
import 'package:hand_bill_manger/src/data/model/product/product_category.dart';
import 'package:hand_bill_manger/src/ui/component/company/category_product_widget.dart';
import 'package:hand_bill_manger/src/ui/component/custom/home_label.dart';
import 'package:hand_bill_manger/src/ui/component/custom/login_first_widget_sliver.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/product/product_hor_empty_widget.dart';
import 'package:hand_bill_manger/src/ui/component/product/product_hor_widget.dart';
import 'package:hand_bill_manger/src/ui/component/product/product_ver_empty_widget.dart';
import 'package:hand_bill_manger/src/ui/component/product/product_ver_widget.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:url_launcher/url_launcher.dart';


class MyProductsScreen extends StatefulWidget {

  static const routeName = "/productsScreen";

  @override
  _MyProductsScreenState createState() =>
      _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<Product>? _items, _featuredList;

  List<CategoryProduct>? _categories;
  CategoryProduct? _selectedCategory;
  late ScrollController _scrollController;
  late double offsetVisibleThreshold;
  late ProductsBloc _productsBloc;
  bool gridOrList = true;
  late Company _company;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;

  @override
  void initState() {
    _productsBloc = BlocProvider.of<ProductsBloc>(context);

    _company = BlocProvider
        .of<GlobalBloc>(context)
        .company!;
    _productsBloc
      ..add(FetchFeaturedProductsEvent(company: _company));
    _productsBloc
      ..add(FetchCategoriesProductsEvent(company: _company));

    _scrollController = ScrollController()
      ..addListener(_onScroll);


    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    if (offset + offsetVisibleThreshold >= max && !_productsBloc.isFetching) {
      setState(() {
        _productsBloc.isFetching = true;
      });
      _productsBloc.add(FetchProductsByCategoryEvent(
          company: _company,
          categoryId: _selectedCategory!.id!));
      _loading = true;
    }
  }

  void _removeFeatured(Product model) {
    _productsBloc.add(
        RemoveFeaturedProductEvent(company: _company, model: model));
  }

  void _removeProduct(Product model) {
    _productsBloc.add(
        RemoveProductEvent(company: _company, model: model));
  }


  void _onCategorySelect(int index) {
    setState(() {
      if (_selectedCategory != null) {
        _selectedCategory!.selected =
        false;
      }
      _categories![index].selected =
      !_categories![index].selected!;
      _selectedCategory =
      _categories![index];
      if (_items != null) {
        _items!.clear();
      }

      _productsBloc.page = 1;
      _productsBloc.add(FetchProductsByCategoryEvent(
          company: _company,
          categoryId: _selectedCategory!.id!));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    offsetVisibleThreshold = size.height;
    return Scaffold(key: _scaffoldKey,
        appBar: RegularAppBar(label: "Products", widget: InkWell(
            onTap: () {
              setState(() {
                gridOrList = !gridOrList;
              });
            },
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                    gridOrList == false
                        ? Icons.list_outlined
                        : Icons.grid_view,
                    color: mainColorLite)))),
        body: MultiBlocListener(
            listeners: [
              BlocListener<ProductsBloc, ProductsState>(
                  listener: (context, state) {
                    if (state is ProductsErrorState) {
                      _items = [];
                      displaySnackBar(
                          scaffoldKey: _scaffoldKey, title: state.error!);
                    }
                    if (state is FeaturedProductsSuccessState) {
                      setState(() {
                        if (_featuredList == null) {
                          _featuredList = [];
                        }
                        _featuredList!.addAll(state.items!);
                      });
                    }

                    if (state is CategoriesProductsSuccessState) {
                      setState(() {
                        _loading = false;
                        if (_categories == null) {
                          _categories = [];
                        } else {
                          _categories!.clear();
                        }
                        _categories!.addAll(state.items!);
                        if (_categories!.isNotEmpty) {
                          _onCategorySelect(0);
                        }
                      });
                    }

                    if (state is ProductsSuccessState) {
                      setState(() {
                        _loading = false;
                        if (_items == null) {
                          _items = [];
                          _items!.addAll(state.products!);
                        } else {
                          _items!.addAll(state.products!);
                        }
                      });
                    }

                    if (state is RemoveFeaturedProductsSuccessState) {
                      setState(() {
                        _featuredList!.removeWhere((element) =>
                        element.id == state.model.id);
                      });

                      displaySnackBar(
                          title: state.message!, scaffoldKey: _scaffoldKey);
                    }
                    if (state is RemoveProductsSuccessState) {
                      setState(() {
                        _items!.removeWhere((element) =>
                        element.id == state.model.id);
                      });

                      displaySnackBar(
                          title: state.message!, scaffoldKey: _scaffoldKey);
                    }
                  }),

            ],
            child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    if (_items != null) {
                      _items!.clear();
                      _items = null;
                    }
                    if (_categories != null) {
                      _categories!.clear();
                      _categories = null;
                      _selectedCategory = null;
                    }
                  });

                  _productsBloc.page = 1;
                  _productsBloc
                    ..add(FetchFeaturedProductsEvent(company: _company));
                  _productsBloc
                    ..add(FetchCategoriesProductsEvent(company: _company));
                },
                child: CustomScrollView(controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    slivers: [

                      SliverToBoxAdapter(
                          child: InkWell(onTap: () {
                            _launchURL("https://hand-bill.com/dashboard/companies/login");
                            // FlutterClipboard.copy(
                            //     "https://hand-bill.com/dashboard/companies/login")
                            //     .then((value) {
                            //   displaySnackBar(
                            //       scaffoldKey: _scaffoldKey, title: "copied");
                            // });
                          }, child: Container(margin: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: mainColorLite)),
                              child: Column(children: [
                                Text("You can add product by this link",
                                    style: TextStyle(
                                        color: textDarkColor, fontSize: 16))
                              ],)))),
                      HomeLabel(title: "Featured"),
                      SliverToBoxAdapter(
                          child: _featuredList == null ? Container(
                              height: size.height * 0.38,
                              child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 6,
                                  itemBuilder: (context, index) {
                                    return ProductHorEmptyWidget();
                                  },
                                  separatorBuilder: (BuildContext context,
                                      int index) =>
                                      SizedBox(width: 6))) : _featuredList!
                              .length == 0 ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Featured product is empty",
                                        style: TextStyle(
                                            color: textDarkColor, fontSize: 16))
                                  ])) : Container(
                              height: size.height * 0.38,
                              child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                  _featuredList!.isNotEmpty ? _featuredList!
                                      .length : 6,
                                  itemBuilder: (context, index) {
                                    if (_featuredList!.isNotEmpty) {
                                      return ProductHorWidget(
                                          model: _featuredList![index],
                                          company: _company,
                                          isHome: true, onRemoveTap: () =>
                                          _removeFeatured(
                                              _featuredList![index]));
                                    }
                                    return ProductHorEmptyWidget();
                                  },
                                  separatorBuilder: (BuildContext context,
                                      int index) =>
                                      SizedBox(width: 6)))),
                      // HomeLabel(title: "Categories"),
                      SliverToBoxAdapter(
                          child: _categories == null ? SizedBox() : Container(
                              height: size.height * 0.05,
                              margin: EdgeInsets.only(top: 6, bottom: 8),
                              child: ListView.separated(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _categories!.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return CategoryProductWidget(
                                        model: _categories![index],
                                        onTap: () => _onCategorySelect(index));
                                  },
                                  separatorBuilder: (BuildContext context,
                                      int index) =>
                                      SizedBox(width: 8)))),
                      _items == null
                          ? SliverToBoxAdapter(
                          child: StaggeredGridView.countBuilder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              shrinkWrap: true,
                              primary: false,
                              crossAxisCount: 4,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              staggeredTileBuilder: (int x) =>
                                  StaggeredTile.count(
                                      2, x.isEven ? 4 : 3),
                              itemBuilder: (BuildContext context,
                                  int index) =>
                                  ProductVerEmptyWidget(),
                              itemCount: 6))
                          : _items!.length == 0
                          ? EmptyDataWidget(
                          label: 'products is Empty')
                          : SliverToBoxAdapter(
                          child: gridOrList == false
                              ? ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              primary: false,
                              shrinkWrap: true,
                              itemCount: _items == null
                                  ? 2
                                  : _items!.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                if (_items != null) {
                                  return ProductVerWidget(
                                      model: _items![index],
                                      company: _company);
                                }
                                return ProductVerEmptyWidget();
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                  SizedBox(height: 16))
                              : StaggeredGridView.countBuilder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              shrinkWrap: true,
                              primary: false,
                              crossAxisCount: 4,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              itemCount: _items!.length,
                              staggeredTileBuilder: (int x) =>
                                  StaggeredTile.count(2, x.isEven ? 4 : 3),
                              itemBuilder: (BuildContext context,
                                  int index) {
                                return ProductHorWidget(
                                    model: _items![index],
                                    company: _company,
                                    onRemoveTap: () =>
                                        _removeProduct(_items![index]));
                              })),
                      SliverToBoxAdapter(
                          child: _loading == true
                              ? Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: 40),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)))
                              : Container())
                    ]))));
  }
  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
