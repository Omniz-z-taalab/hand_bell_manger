import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hand_bill_manger/src/blocs/ads/ads_bloc.dart';
import 'package:hand_bill_manger/src/blocs/ads/ads_event.dart';
import 'package:hand_bill_manger/src/blocs/ads/ads_state.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/blocs/products/products_bloc.dart';
import 'package:hand_bill_manger/src/blocs/products/products_event.dart';
import 'package:hand_bill_manger/src/blocs/products/products_state.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/ad_model.dart';
import 'package:hand_bill_manger/src/data/model/ads/ads_coast_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/product.dart';
import 'package:hand_bill_manger/src/data/model/product/product_category.dart';
import 'package:hand_bill_manger/src/ui/component/company/category_product_widget.dart';
import 'package:hand_bill_manger/src/ui/component/company/company_widget.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_button.dart';
import 'package:hand_bill_manger/src/ui/component/custom/image_widget.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/custom/widgets.dart';
import 'package:hand_bill_manger/src/ui/component/product/product_ad_widget.dart';
import 'package:hand_bill_manger/src/ui/component/product/product_ver_empty_widget.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/navigation_package/sponsored/my_ads.dart';
import 'package:image_picker/image_picker.dart';

class SponsoredScreen extends StatefulWidget {
  static const routeName = "/SponsoredScreen";

  @override
  _SponsoredScreenState createState() => _SponsoredScreenState();
}

class _SponsoredScreenState extends State<SponsoredScreen> {
  final ImagePicker _picker = ImagePicker();
  int _maxImages = 1;
  List<File> _images = [];

  List<Product>? _products;

  Product? _selectedProduct;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loadingBanner = false, _loadingProduct = false, _loadingCompany = false;
  late Company _company;
  late AdsBloc _adsBloc;
  AdsCoastModel? _adsCoastModel;
  double _marginVer = 16;

  late ProductsBloc _productsBloc;
  List<CategoryProduct>? _categories;
  CategoryProduct? _selectedCategory;

  bool isSupplier = false;

  @override
  void initState() {
    _company = BlocProvider.of<GlobalBloc>(context).company!;
    if (_company.natureActivity == "Supplier") {
      isSupplier = true;
    } else {
      isSupplier = false;
    }

    _productsBloc = BlocProvider.of<ProductsBloc>(context);
    _productsBloc..add(FetchCategoriesProductsEvent(company: _company));
    _adsCoastModel =
        AdsCoastModel(banner: "0.0", company: "0.0", product: "0.0");

    _adsBloc = BlocProvider.of<AdsBloc>(context);
    _adsBloc.add(GetAdsCoastEvent(company: _company));

    super.initState();
  }

  double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(
            label: "Ads",
            widget: InkWell(
                onTap: () => Navigator.pushNamed(context, MyAds.routeName),
                child: Icon(Icons.add_rounded)
                // SvgPicture.asset("assets/icons/user.svg",
                // height: iconSize,
                // width: iconSize,
                // fit: BoxFit.contain,
                // color: Color(0xff2f84ed))
               )),
        body: MultiBlocListener(
            listeners: [
              BlocListener<AdsBloc, AdsState>(
                  listener: (BuildContext context, state) {
                if (state is AdsCoastSuccessState) {
                  setState(() {
                    _adsCoastModel = state.model;
                  });
                }
                if (state is AdsLoadingState) {}
                if (state is AdsErrorState) {
                  displaySnackBar(
                      scaffoldKey: _scaffoldKey, title: state.error!);
                  setState(() {
                    _loadingBanner = false;
                    _loadingProduct = false;
                    _loadingCompany = false;
                  });
                }

                if (state is AdsAddSuccessState) {
                  displaySnackBar(
                      scaffoldKey: _scaffoldKey, title: state.message);
                  setState(() {
                    _loadingBanner = false;
                    _loadingProduct = false;
                    _loadingCompany = false;
                    _images.clear();
                  });
                }
              }),
              BlocListener<ProductsBloc, ProductsState>(
                  listener: (context, state) {
                if (state is ProductsErrorState) {
                  displaySnackBar(
                      scaffoldKey: _scaffoldKey, title: state.error!);
                  _products = [];
                }

                if (state is CategoriesProductsSuccessState) {
                  setState(() {
                    if (_categories == null) {
                      _categories = [];
                      _categories!.addAll(state.items!);
                      if(_categories!.isNotEmpty) {
                        _onCategorySelect(0);
                      }
                    }
                  });
                }

                if (state is ProductsSuccessState) {
                  setState(() {
                    if (_products == null) {
                      _products = [];
                      _products!.addAll(state.products!);
                    } else {
                      _products!.addAll(state.products!);
                    }
                  });
                }
              }),
            ],
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _description(
                          label: "Banner Ad",
                          description:
                              "upload the image to display on the home page",
                          price: _adsCoastModel!.banner),
                      _images.length == 0
                          ? SizedBox()
                          : Stack(children: [
                              Container(
                                height: size.height * 0.2,
                                width: double.infinity,
                                child: LocalImageWidget(
                                    image: _images[0],
                                    // onTap: () => getImage(index),
                                    onRemoveTap: () => removeImage()),
                              ),
                            ]),
                      SizedBox(height: _marginVer),
                      AddImageBtn(
                          onTap: () => getImage(),
                          length: _images.length,
                          label: "Select image",
                          max: _maxImages),
                      _loadingBanner == false
                          ? SizedBox(height: _marginVer)
                          : Container(
                              height: 100,
                              width: double.infinity,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                        color: Theme.of(context).accentColor,
                                        strokeWidth: 2)
                                  ])),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                                title: "Send Request",
                                onPress: () => _sendBannerAdsRequest(),
                                radius: 90,
                                borderColor: mainColorLite,
                                borderWidth: 1.25,
                                verticalPadding: 12,
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                    color: mainColorLite, fontSize: 16))
                          ]),
                      SizedBox(height: _marginVer),
                      isSupplier == false
                          ? SizedBox()
                          : Column(children: [
                              _divider(),
                              _description(
                                  label: "Top Product Ad",
                                  description:
                                      "Select the product to display on the home page",
                                  price: _adsCoastModel!.product),
                              _categories == null
                                  ? Container(
                                      height: 100,
                                      width: double.infinity,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                strokeWidth: 2)
                                          ]))
                                  : _categories!.isEmpty == true
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "No Product Found",
                                                  style: TextStyle(
                                                      color: textDarkColor),
                                                )
                                              ]))
                                      : Container(
                                          height: size.height * 0.05,
                                          margin: EdgeInsets.only(
                                              top: 6, bottom: 8),
                                          child: ListView.separated(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _categories!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return CategoryProductWidget(
                                                    model: _categories![index],
                                                    onTap: () =>
                                                        _onCategorySelect(
                                                            index));
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      SizedBox(width: 8))),
                              _products == null
                                  ? SizedBox()
                                  : Container(
                                      height: size.height * 0.38,
                                      child: ListView.separated(
                                          physics: BouncingScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _products!.isNotEmpty
                                              ? _products!.length
                                              : 6,
                                          itemBuilder: (context, index) {
                                            if (_products!.isNotEmpty) {
                                              return ProductAdWidget(
                                                model: _products![index],
                                                onTap: () =>
                                                    onProductClick(index),
                                                // isHome: true,
                                                // onRemoveTap: () => _removeFeatured(index),
                                              );
                                            }
                                            return ProductVerEmptyWidget();
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  SizedBox(width: 6))),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomButton(
                                            title: "Send Request",
                                            onPress: () =>
                                                _sendProductAdsRequest(),
                                            radius: 90,
                                            borderColor: mainColorLite,
                                            borderWidth: 1.25,
                                            verticalPadding: 12,
                                            color: Colors.transparent,
                                            textStyle: TextStyle(
                                                color: mainColorLite,
                                                fontSize: 16))
                                      ])),
                              SizedBox(height: 16),
                            ]),
                      _divider(),
                      _description(
                          label: "Top Company Ad",
                          description:
                              "Your company will be displayed on the homepage",
                          price: _adsCoastModel!.company),
                      Container(
                          height: size.height * 0.4,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CompanyWidget(model: _company)])),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                    title: "Send Request",
                                    onPress: () => _sendCompanyAdsRequest(),
                                    radius: 90,
                                    borderColor: mainColorLite,
                                    borderWidth: 1.25,
                                    verticalPadding: 12,
                                    color: Colors.transparent,
                                    textStyle: TextStyle(
                                        color: mainColorLite, fontSize: 16))
                              ])),
                      SizedBox(height: 60)
                    ]))));
  }

  void _onCategorySelect(int index) {
    setState(() {
      if (_selectedCategory != null) {
        _selectedCategory!.selected = false;
      }
      _categories![index].selected = !_categories![index].selected!;
      _selectedCategory = _categories![index];
      if (_products != null) {
        _products!.clear();
      }
      _selectedProduct = null;

      _productsBloc.page = 1;
      _productsBloc.add(FetchProductsByCategoryEvent(
          company: _company, categoryId: _selectedCategory!.id!));
    });
  }

  // banner
  void _sendBannerAdsRequest() {
    if (!_company.profileCompleted()) {
      displaySnackBar(
          title: "Complete your profile", scaffoldKey: _scaffoldKey);
    } else if (_images.isNotEmpty) {
      AdsModel _adsModel = AdsModel(type: "banner", file: _images[0]);
      setState(() => _loadingBanner = true);
      _adsBloc.add(AdsAddEvent(model: _adsModel, company: _company));
    } else {
      displaySnackBar(
          scaffoldKey: _scaffoldKey, title: "You should select image first");
    }
  }

  // product
  void _sendProductAdsRequest() {
    if (!_company.profileCompleted()) {
      displaySnackBar(
          title: "Complete your profile", scaffoldKey: _scaffoldKey);
    } else if (_products == null || _products!.isEmpty) {
      displaySnackBar(
          scaffoldKey: _scaffoldKey, title: "You should add product first");
    } else if (_selectedProduct == null) {
      displaySnackBar(
          scaffoldKey: _scaffoldKey, title: "You should select product first");
    } else {
      AdsModel _adsModel = AdsModel(type: "product", id: _selectedProduct!.id!);
      setState(() => _loadingProduct = true);
      _adsBloc.add(AdsAddEvent(model: _adsModel, company: _company));
    }
  }

  // company
  void _sendCompanyAdsRequest() {
    if (!_company.profileCompleted()) {
      displaySnackBar(
          title: "Complete your profile", scaffoldKey: _scaffoldKey);
    } else {
      AdsModel _adsModel = AdsModel(type: "company", id: _company.id!);
      setState(() => _loadingProduct = true);
      _adsBloc.add(AdsAddEvent(model: _adsModel, company: _company));
    }
  }

  void onProductClick(int index) {
    setState(() {
      if (_selectedProduct != null) {
        _selectedProduct!.selected = false;
      }
      _products![index].selected = !_products![index].selected!;
      _selectedProduct = _products![index];
    });
  }

  Future<void> getImage() async {
    File? image;
    if (_maxImages > _images.length) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      image = File(pickedFile!.path);
      setState(() {
        _images.add(image!);
      });
    } else {
      Fluttertoast.showToast(msg: "max images is $_maxImages");
    }
  }

  void removeImage() {
    setState(() {
      _images.removeAt(0);
    });
  }

  Widget _description(
      {required String label, required String description, String? price}) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 6),
          Text(description,
              style: TextStyle(fontSize: 14, color: textDarkColor)),
          SizedBox(height: 6),
          RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: textDarkColor, fontWeight: FontWeight.normal),
                  children: [
                TextSpan(text: "Cost : "),
                TextSpan(
                    text: price.toString(),
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500)),
                TextSpan(text: " \$ /Per day")
              ])),
        ]));
  }

  Widget _divider() {
    return Container(
        // margin: EdgeInsets.symmetric(vertical: 16),
        height: 8,
        decoration: BoxDecoration(
            color: Color(0xffeeeeee),
            border: Border.symmetric(
              horizontal: BorderSide(color: Color(0xffe0e0e0), width: 0.5),
            )));
  }
}
