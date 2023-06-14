
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  ProductWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    if(product.choiceOptions.length != 0) {
      List<double> _priceList = [];
      product.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = product.price;
    }

    double  _discountedPrice = PriceConverter.convertWithDiscount(context, product.price, product.discount, product.discountType);

    bool _isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds, context);




    return Consumer<CartProvider>(
        builder: (context, _cartProvider, child) {
          String _productImage = '';
          try{
            _productImage =  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}';
          }catch(e) {

          }
          int _cartIndex =   _cartProvider.getCartIndex(product);
          var img = Image.network(_productImage);
        return Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              fit:FlexFit.loose,
            child: Padding(
              padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
              child: InkWell(
                onTap: () {
                 ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (con) => CartBottomSheet(
                        product: product, cart: _cartIndex != null ? _cartProvider.cartList[_cartIndex] : null,
                        callback: (CartModel cartModel) {
                          showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                        },
                      ),
                  ): showDialog(context: context, builder: (con) => Dialog(
                     child: CartBottomSheet(
                       product: product, cart: _cartIndex != null ? _cartProvider.cartList[_cartIndex] : null,
                       callback: (CartModel cartModel) {
                         showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                       },
                     ),
                 )) ;
                },
                // child: Container(
                //   padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).cardColor,
                //     borderRadius: BorderRadius.circular(10),
                //     boxShadow: [BoxShadow(
                //       color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                //       blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                //       spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                //     )],
                //   ),
                //   child: Row(children: [
                //     Stack(
                //       children: [
                //         ClipRRect(
                //           borderRadius: BorderRadius.circular(10),
                //           child: FadeInImage.assetNetwork(
                //             placeholder: Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover,
                //             image: _productImage,
                //             imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover),
                //           ),
                //         ),
                //         _isAvailable ? SizedBox() : Positioned(
                //           top: 0, left: 0, bottom: 0, right: 0,
                //           child: Container(
                //             alignment: Alignment.center,
                //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                //             child: Text(getTranslated('not_available_now_break', context), textAlign: TextAlign.center, style: rubikRegular.copyWith(
                //               color: Colors.white, fontSize: 8,
                //             )),
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                //     Expanded(
                //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                //         Text(product.name, style: rubikMedium.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                //         SizedBox(height: 5),
                //         product.rating != null ? RatingBar(
                //           rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0, size: 10,
                //         ) : SizedBox(),
                //         SizedBox(height: 5),
                //         Text(
                //           '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                //               '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount,
                //               discountType: product.discountType)}' : ''}',
                //           style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                //         ),
                //         product.price > _discountedPrice ? Text('${PriceConverter.convertPrice(context, _startingPrice)}'
                //             '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}', style: rubikMedium.copyWith(
                //           color: ColorResources.COLOR_GREY,
                //           decoration: TextDecoration.lineThrough,
                //           fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                //         )) : SizedBox(),
                //       ]),
                //     ),
                //     Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  
                //         WishButton(product: product, edgeInset: EdgeInsets.all(5)),
                  
                //       Expanded(child: SizedBox()),
                //       Icon(Icons.add),
                //     ]),
                //   ]),
                // ),
                child: Column(
                    
                    children: [
                      Flexible(
                        flex:2,
                        child: Container(
                          // margin: const EdgeInsets.only(
                          //   top: 10.0,
                          // ),
                          // height:150,
                          width: double.infinity,
                          
                          // decoration: BoxDecoration(
                          //   // borderRadius: BorderRadius.circular(15.0),
                          //   borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(10),
                          //     topRight: Radius.circular(10)
                          //   ),
                          //   image: DecorationImage(
                          //     fit: BoxFit.contain,
                          //     image: NetworkImage(
                          //         '$_productImage'),
                          //     scale: 1,
                          //   ),
                          // ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)
                              ),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_image, fit: BoxFit.cover,
                              image: _productImage,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      _isAvailable ? SizedBox() : Container(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                            child: Text(getTranslated('not_available_now_break', context), textAlign: TextAlign.center, style: rubikRegular.copyWith(
                              color: Colors.white, fontSize: 8,
                            )),
                          ),
                        ),
                      Flexible(
                        child: SizedBox(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                // borderRadius: BorderRadius.circular(10),
                                borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                              ),
                                boxShadow: [BoxShadow(
                                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                                  blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                  spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                                )],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: FittedBox(
                                      // margin: const EdgeInsets.only(top: 10.0),
                                      fit:BoxFit.contain,
                                      child: Text(product.name, 
                                              style: rubikMedium.copyWith(fontSize: 14), 
                                              maxLines: 2, 
                                              overflow: TextOverflow.ellipsis
                                              ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                       margin: const EdgeInsets.fromLTRB(0,8.0,0,8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                              // product.rating != null ? RatingBar(
                                              //   rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0, size: 15,
                                              // ) : SizedBox(),
                                              // SizedBox(height: 5),
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                                                      '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount,
                                                      discountType: product.discountType)}' : ''}',
                                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                                ),
                                              ),
                                              product.price > _discountedPrice ? FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text('${PriceConverter.convertPrice(context, _startingPrice)}'
                                                    '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}', style: rubikMedium.copyWith(
                                                  color: ColorResources.COLOR_GREY,
                                                  decoration: TextDecoration.lineThrough,
                                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                )),
                                              ) : SizedBox(),
                                            ]),
                                          ),
                                          Flexible(
                                            child:  WishButton(product: product, edgeInset: EdgeInsets.all(5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                 
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              )),
          )],
        );
      }
    );
  }
  Icon starIcon(Color color) {
    return Icon(
      Icons.star,
      size: 10.0,
      color: color,
    );
  }
}
