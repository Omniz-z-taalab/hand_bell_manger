import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_bloc.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_event.dart';
import 'package:hand_bill_manger/src/blocs/auction/aucations_state.dart';
import 'package:hand_bill_manger/src/blocs/global_bloc/global_bloc.dart';
import 'package:hand_bill_manger/src/common/constns.dart';
import 'package:hand_bill_manger/src/data/model/account_package/auction_model.dart';
import 'package:hand_bill_manger/src/data/model/company.dart';
import 'package:hand_bill_manger/src/data/model/local/images.dart';
import 'package:hand_bill_manger/src/data/model/local/route_argument.dart';
import 'package:hand_bill_manger/src/ui/component/custom/custom_button.dart';
import 'package:hand_bill_manger/src/ui/component/custom/expandable_text.dart';
import 'package:hand_bill_manger/src/ui/component/custom/regular_app_bar.dart';
import 'package:hand_bill_manger/src/ui/component/widgets.dart';
import 'package:hand_bill_manger/src/ui/screens/common/image_full_screen.dart';
import 'package:video_player/video_player.dart';

class AuctionDetailsScreen extends StatefulWidget {
  static const routeName = "/AuctionDetailsScreen";

  late RouteArgument routeArgument;

  AuctionDetailsScreen({required this.routeArgument});

  @override
  _AuctionDetailsScreenState createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen> {
  late AuctionModel _model;
  late AuctionsBloc _auctionsBloc;
  double _marginVer = 16;
  late Company _company;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;

  List<ImageModel> _imageList = [];

  int _imageIndex = 0;
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  bool _addVideo = false;

  @override
  void initState() {
    _model = widget.routeArgument.param;

    _company = BlocProvider.of<GlobalBloc>(context).company!;
    _auctionsBloc = BlocProvider.of<AuctionsBloc>(context);
    _imageList.addAll(_model.images!);
    if (_model.video != null && _addVideo == false) {
      initializePlayer(_model.video!.url!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey,
        appBar: RegularAppBar(label: "Auction Details"),
        body:
            BlocBuilder<AuctionsBloc, AuctionsState>(builder: (context, state) {
          if (state is AuctionsErrorState) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.error!, scaffoldKey: _scaffoldKey);
            });
            _loading = false;
          }
          if (state is AuctionCloseSuccessState) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              displaySnackBar(title: state.message, scaffoldKey: _scaffoldKey);
            });
            _model.closed = true;
            _loading = false;
          }

          return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      Container(
                          height: size.height * 0.4,
                          color: Colors.white,
                          child: PageView.builder(
                              itemCount: _imageList.length,
                              controller: PageController(viewportFraction: 1),
                              onPageChanged: (int index) {
                                setState(() => _imageIndex = index);
                                if (index == 1 && _chewieController != null) {
                                  _videoPlayerController1.pause();
                                }
                              },
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0 && _chewieController != null) {
                                  return Chewie(controller: _chewieController!);
                                } else {
                                  return InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, ImageFullScreen.routeName,
                                        arguments: RouteArgument(
                                            param: _imageList[index].thump)),
                                    child: CachedNetworkImage(
                                        imageUrl: _imageList[index].thump!,
                                        placeholder: (context, url) => Center(
                                            heightFactor: 1,
                                            widthFactor: 1,
                                            child: CircularProgressIndicator(
                                                color: mainColorLite,
                                                strokeWidth: 2)),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error,
                                                color: mainColorLite)),
                                  );
                                }
                              })),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: 16,
                        child: _imageList.isEmpty
                            ? SizedBox()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    DotsIndicator(
                                        dotsCount: _imageList.length,
                                        position: _imageIndex.toDouble(),
                                        decorator: DotsDecorator(
                                            color: Color(0x26000000),
                                            activeColor: Color(0x80000000),
                                            size: const Size.square(4.0),
                                            activeSize: const Size(10.0, 4.0),
                                            activeShape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))))
                                  ]),
                      )
                    ]),
                    SizedBox(height: _marginVer),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: _marginVer * 0.5),
                              Text(_model.title ?? "",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              SizedBox(height: _marginVer),
                              ExpandableTextWidget(text: _model.description!),
                              _divider(),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Text("Price : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: textDarkColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                              children: [
                                            TextSpan(
                                                text: _model.price.toString()),
                                            TextSpan(
                                                text: " \$",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepOrange))
                                          ]))
                                    ]),
                                    SizedBox(width: 8),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Status : ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                          Text(_model.status.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14)),
                                        ]),
                                  ]),
                              _loading == false
                                  ? SizedBox(height: _marginVer * 2)
                                  : Container(
                                      height: 100,
                                      width: double.infinity,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 16),
                                            CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                strokeWidth: 2)
                                          ])),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                        title: _model.closed == false
                                            ? "Close Auction"
                                            : "Closed",
                                        radius: 900,
                                        color: _model.closed == false
                                            ? mainColorLite
                                            : Color(0xffdbdbdb),
                                        onPress: () =>
                                            _closeAuction(_model.id!))
                                  ]),
                              SizedBox(height: 200)
                            ]))
                  ]));
        }));
  }

  Future<void> initializePlayer(String url) async {
    _videoPlayerController1 = VideoPlayerController.network(url);
    await _videoPlayerController1.initialize();
    _createChewieController();
    setState(() {
      _imageList.insert(0, ImageModel());
      _addVideo = true;
    });
  }

  void _createChewieController() {
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        // autoPlay: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(playedColor: Colors.white),
        looping: true,
        showOptions: false);
  }

  void _closeAuction(int id) {
    if (_model.closed == false) {
      _auctionsBloc.add(AuctionCloseEvent(company: _company, id: id));
    }
  }

  Widget _divider() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        width: double.infinity,
        height: 2,
        color: Color(0xffeeeeee));
  }

  @override
  void dispose() {
    if (_chewieController != null) {
      _chewieController!.pause();
    }
    super.dispose();
  }
}
