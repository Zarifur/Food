import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/read_more_text.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatefulWidget {
  final Product product;
  final bool fromSetMenu;
  final Function callback;
  final CartModel cart;
  final int cartIndex;
  final bool fromCart;

  CartBottomSheet({@required this.product, this.fromSetMenu = false, this.callback, this.cart, this.cartIndex, this.fromCart = false});

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  int _cartIndex;
  String meal = "On its own";
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).initData(widget.product, widget.cart, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Variation _variation = Variation();
    
    return Consumer<CartProvider>(
        builder: (context, _cartProvider, child) {
          _cartProvider.setCartUpdate(false);
        return Stack(
          children: [
            Container(
              width: 600,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveHelper.isMobile(context)
                    ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                    : BorderRadius.all(Radius.circular(20)),
              ),
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if(productProvider.mealItems['sides'].price != -1 || productProvider.mealItems['drinks'].price != -1 || productProvider.mealItems['dips'].price != -1){
                    meal = 'As a meal';
                  }
                  double _startingPrice;
                  double _endingPrice;
                  if (widget.product.choiceOptions.length != 0) {
                    List<double> _priceList = [];
                    widget.product.variations.forEach((variation) => _priceList.add(variation.price));
                    _priceList.sort((a, b) => a.compareTo(b));
                    _startingPrice = _priceList[0];
                    if (_priceList[0] < _priceList[_priceList.length - 1]) {
                      _endingPrice = _priceList[_priceList.length - 1];
                    }
                  } else {
                    _startingPrice = widget.product.price;
                  }

                  

                  List<String> _variationList = [];
                  for (int index = 0; index < widget.product.choiceOptions.length; index++) {
                    //Added by Me
                    // _variationList.add(widget.product.choiceOptions[index].options[productProvider.variationIndex[index]].replaceAll(' ', ''));
                    _variationList.add(widget.product.choiceOptions[index].options[productProvider.variationIndex[index]].trim());
                  }
                  String variationType = '';
                  bool isFirst = true;
                  _variationList.forEach((variation) {
                    if (isFirst) {
                      variationType = '$variationType$variation';
                      isFirst = false;
                    } else {
                      variationType = '$variationType-$variation';
                    }
                  });


                  double price = widget.product.price;
                  //Added by Me
                  if(meal == 'As a meal'){
                    price = widget.product.mealPrice;
                  }
                  for (Variation variation in widget.product.variations) {
                    if (variation.type.trim() == variationType) {
                      if(meal == 'As a meal'){
                        price = variation.varMealPrice;
                      }else{
                        price = variation.price;
                      }
                      _variation = variation;
                      break;
                    }
                  }
                  double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, widget.product.discount, widget.product.discountType);
                  double addonsCost = 0;
                  List<AddOn> _addOnIdList = [];
                  for (int index = 0; index < widget.product.addOns.length; index++) {
                    if (productProvider.addOnActiveList[index]) {
                      addonsCost = addonsCost + (widget.product.addOns[index].price * productProvider.addOnQtyList[index]);
                      _addOnIdList.add(AddOn(id: widget.product.addOns[index].id, quantity: productProvider.addOnQtyList[index]));
                    }
                  }

                  DateTime _currentTime = Provider.of<SplashProvider>(context, listen: false).currentTime;
                  DateTime _start = DateFormat('hh:mm:ss').parse(widget.product.availableTimeStarts);
                  DateTime _end = DateFormat('hh:mm:ss').parse(widget.product.availableTimeEnds);
                  DateTime _startTime =
                  DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _start.hour, _start.minute, _start.second);
                  DateTime _endTime = DateTime(_currentTime.year, _currentTime.month, _currentTime.day, _end.hour, _end.minute, _end.second);
                  if (_endTime.isBefore(_startTime)) {
                    _endTime = _endTime.add(Duration(days: 1));
                  }
                  bool _isAvailable = _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);
                  //Added by Me Sopan
                  List<SaveItem> _itemlist= [];

                  for (int ind = 0; ind < widget.product.structure.length; ind++) {
                    SaveItem itm = new SaveItem(item: widget.product.structure[ind],quantity: productProvider.itemQtyList[ind]);
                    _itemlist.add(itm);
                  }

                  double itemsCost = productProvider.itemsPrice * productProvider.quantity;
                  // int totalFree = widget.product.item_ttl_free;
                  // int freeItems = 0;
                  // for (int index = 0; index < widget.product.structure.length; index++) {
                  //   //TODO:UPD for each tap
                  //   freeItems += productProvider.itemQtyList[index];
                  //   if (productProvider.itemQtyList[index] > widget.product.structure[index].freeAmount) {
                  //     // tobepaidItems += productProvider.itemQtyList[index] - widget.product.structure[index].freeAmount;
                            
                      
                  //     int qtytopay = productProvider.itemQtyList[index] - widget.product.structure[index].freeAmount;
                  //     if(freeItems <= totalFree){
                  //       continue;
                  //     }
                  //     itemsCost += widget.product.structure[index].price * qtytopay;
                  //   }
                  // }

                  

                  double price_with_meals = 0;
                  if(meal == 'As a meal'){
                    productProvider.mealItems.forEach((type, mealItm) {
                      if(mealItm.price != -1){
                        price_with_meals += mealItm.price * productProvider.quantity;
                      }
                    });
                  }
                  //Added by Me (Sopan) end
                  CartModel _cartModel = CartModel(
                    price,
                    priceWithDiscount,
                    [_variation],
                    (price - PriceConverter.convertWithDiscount(context, price, widget.product.discount, widget.product.discountType)),
                    productProvider.quantity,
                    price - PriceConverter.convertWithDiscount(context, price, widget.product.tax, widget.product.taxType),
                    _addOnIdList,
                    _itemlist,
                    itemsCost,
                    productProvider.mealItems['sides'],
                    productProvider.mealItems['drinks'],
                    productProvider.mealItems['dips'],
                    meal == 'As a meal' ? 1:0,
                    widget.product,
                  );

                  _cartIndex = _cartProvider.isExistInCart(
                    widget.product.id, variationType.isEmpty ? null : variationType, false, null,
                  );
                  print('is exit : $_cartIndex');

                  double priceWithQuantity = priceWithDiscount * productProvider.quantity;
                  double priceWithAddons = priceWithQuantity + addonsCost;
                  double totalPrice = itemsCost + priceWithAddons + price_with_meals;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 0 : Dimensions.PADDING_SIZE_EXTRA_LARGE),

                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start, children: [
                              //Product
                               _productView(
                                 context, _startingPrice, _endingPrice,
                                 price, priceWithDiscount,
                                 _cartModel,
                               ),

                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // Quantity
                             ResponsiveHelper.isMobile(context) ? Column(
                               children: [
                                 _quantityView(context, _cartModel),
                                 SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                               ],
                             ) : _description(context),



                              // Variation
                              _variationView(productProvider, variationType),
                              widget.product.choiceOptions.length > 0 ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE) : SizedBox(),


                             if(ResponsiveHelper.isMobile(context)) _description(context),

                              // Addons
                              _addonsView(context, productProvider),
                              //Added by Me Sopan Structure view
                              if(widget.product.structure.length != 0 && widget.product.structure[0].defaultAmount != -1) _itemView(context,productProvider),
                              SizedBox(height: 10),
                              //Meal Drop
                              if(widget.product.mealPrice != null) DecoratedBox(
                                decoration: BoxDecoration( 
                                  color:Theme.of(context).cardColor, //background color of dropdown button
                                  border: Border.all(color: Theme.of(context).primaryColor, width:1), //border of dropdown button
                                   borderRadius: BorderRadius.circular(25), 
                                  // boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                                  //         BoxShadow(
                                  //             color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                  //             blurRadius: 5) //blur radius of shadow
                                  //       ]
                                ),
                                 child:Padding(
                                  padding: EdgeInsets.only(left:30, right:30),
                                  child: DropdownButton(
                                    value: meal,
                                    items: <String>['On its own', 'As a meal'].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                          );
                                        }).toList(), 
                                    onChanged: (String newValue){
                                        if(newValue == 'On its own'){
                                          productProvider.setOrRemoveMealItem("sides", new MealItem(Name: "Empty",Price: -1), false);
                                          productProvider.setOrRemoveMealItem("drinks", new MealItem(Name: "Empty",Price: -1), false);
                                          productProvider.setOrRemoveMealItem("dips", new MealItem(Name: "Empty",Price: -1), false);
                                        }
                                        setState(() {
                                          meal = newValue;
                                        });
                                    },
                                     icon: Padding( //Icon at tail, arrow bottom is default icon
                                        padding: EdgeInsets.only(left:20),
                                        child:Icon(Icons.arrow_circle_down_sharp)
                                      ), 
                                      iconEnabledColor: Color.fromARGB(255, 0, 0, 0), //Icon color
                                      style: TextStyle(  //te
                                        color: Color.fromARGB(255, 0, 0, 0), //Font color
                                        fontSize: 20 //font size on dropdown button
                                      ),
                                      
                                      dropdownColor: Theme.of(context).cardColor, //dropdown background color
                                      underline: Container(), //remove underline
                                      isExpanded: true, //make true to make width 100%
                                    ),
                                  )
                              ),
                              SizedBox(height: 20),
                              //Added by Me (Sopan)
                              if(meal == 'As a meal') _typeView(context,  widget.product.sides, 'sides'),
                              if(meal == 'As a meal') _typeView(context,  widget.product.drinks, 'drinks'),
                              if(meal == 'As a meal') _typeView(context,  widget.product.dips, 'dips'),


                              Row(children: [
                                Text('${getTranslated('total_amount', context)}:', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(PriceConverter.convertPrice(context, totalPrice),
                                    style: rubikBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                    )),
                              ]),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                              
                              
                              //Add to cart Button
                             if(ResponsiveHelper.isDesktop(context)) _cartButton(_isAvailable, context, _cartModel),
                            ]),
                          ),
                        ),
                      ),

                      if(!ResponsiveHelper.isDesktop(context)) _cartButton(_isAvailable, context, _cartModel),
                    ],
                  );
                },
              ),
            ),
            ResponsiveHelper.isMobile(context)
                ? SizedBox()
                : Positioned(
              right: 10,
              top: 5,
              child: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.close)),
            ),
          ],
        );
      }
    );
  }

  Widget _addonsView(BuildContext context, ProductProvider productProvider) {
    return widget.product.addOns.length > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('addons', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
          childAspectRatio: (1 / 1.1),
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.product.addOns.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (!productProvider.addOnActiveList[index]) {
                productProvider.addAddOn(true, index);
              } else if (productProvider.addOnQtyList[index] == 1) {
                productProvider.addAddOn(false, index);
              }
            },

            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: productProvider.addOnActiveList[index] ? 2 : 20),
              decoration: BoxDecoration(
                color: productProvider.addOnActiveList[index]
                    ? Theme.of(context).primaryColor
                    : ColorResources.BACKGROUND_COLOR,
                borderRadius: BorderRadius.circular(5),
                boxShadow: productProvider.addOnActiveList[index]
                    ? [BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                  blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                  spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                )]
                    : null,
              ),
              child: Column(children: [
                Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(widget.product.addOns[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: rubikMedium.copyWith(
                            color: productProvider.addOnActiveList[index]
                                ? ColorResources.COLOR_WHITE
                                : ColorResources.COLOR_BLACK,
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                          )),
                      SizedBox(height: 5),
                      Text(
                        PriceConverter.convertPrice(context, widget.product.addOns[index].price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rubikRegular.copyWith(
                            color: productProvider.addOnActiveList[index]
                                ? ColorResources.COLOR_WHITE
                                : ColorResources.COLOR_BLACK,
                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      ),
                    ])),
                productProvider.addOnActiveList[index] ? Container(
                  height: 25,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).cardColor),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (productProvider.addOnQtyList[index] > 1) {
                            productProvider.setAddOnQuantity(false, index);
                          } else {
                            productProvider.addAddOn(false, index);
                          }
                        },
                        child: Center(child: Icon(Icons.remove, size: 15)),
                      ),
                    ),
                    Text(productProvider.addOnQtyList[index].toString(),
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                    Expanded(
                      child: InkWell(
                        onTap: () => productProvider.setAddOnQuantity(true, index),
                        child: Center(child: Icon(Icons.add, size: 15)),
                      ),
                    ),
                  ]),
                )
                    : SizedBox(),
              ]),
            ),
          );
        },
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
    ]) : SizedBox();
  }

  Widget _quantityView(
      BuildContext context,
      CartModel _cartModel,
      ) {
    return Row(children: [
      Text(getTranslated('quantity', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      Expanded(child: SizedBox()),
      _quantityButton(context, _cartModel),
    ]);
  }

  Widget _variationView(ProductProvider productProvider, String variationType) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.product.choiceOptions.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.product.choiceOptions[index].title, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              childAspectRatio: (1 / 0.25),
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.product.choiceOptions[index].options.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  productProvider.setCartVariationIndex(index, i, widget.product, variationType, context, );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    color: productProvider.variationIndex[index] != i
                        ? ColorResources.BACKGROUND_COLOR
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.product.choiceOptions[index].options[i].trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: rubikRegular.copyWith(
                      color: productProvider.variationIndex[index] != i
                          ? ColorResources.COLOR_BLACK
                          : ColorResources.COLOR_WHITE,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: index != widget.product.choiceOptions.length - 1 ? Dimensions.PADDING_SIZE_LARGE : 0),
        ]);
      },
    );
  }
  //Added by Me Sopan

  Widget _typeView(BuildContext context,List<MealItem> type,String name){
      String tname = name[0].toUpperCase() +name.substring(1);
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
      return type.length > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$tname', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        SizedBox(height: 10),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            childAspectRatio: (1 / 1.1),
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: type.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (productProvider.mealItems['$name'].name == type[index].name) {
                  productProvider.setOrRemoveMealItem('$name',type[index],false);
                } else {
                  productProvider.setOrRemoveMealItem('$name',type[index],true);
                }
              },

              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: productProvider.mealItems['$name'].name == type[index].name ? 2 : 20),
                decoration: BoxDecoration(
                  color: productProvider.mealItems['$name'].name == type[index].name
                      ? Theme.of(context).primaryColor
                      : ColorResources.BACKGROUND_COLOR,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: productProvider.mealItems['$name'].name == type[index].name
                      ? [BoxShadow(
                    color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                    blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                    spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                  )]
                      : null,
                ),
                child: Column(children: [
                  Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(type[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: rubikMedium.copyWith(
                              color: productProvider.mealItems['$name'].name == type[index].name
                                  ? ColorResources.COLOR_WHITE
                                  : ColorResources.COLOR_BLACK,
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                            )),
                        SizedBox(height: 5),
                        Text(
                          PriceConverter.convertPrice(context, type[index].price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: rubikRegular.copyWith(
                              color: productProvider.mealItems['$name'].name == type[index].name
                                  ? ColorResources.COLOR_WHITE
                                  : ColorResources.COLOR_BLACK,
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                        ),
                      ])),

                      
                ]),
              ),
            );
          },
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      ]) : SizedBox();
  }
  Widget _itemView(BuildContext context,ProductProvider productProvider) {
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add Extra", style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
              if(widget.product.item_ttl_free>0) Text("Free Additions: ${widget.product.item_ttl_free.toString()}", style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
            ],
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: widget.product.structure.length,
          //   physics: NeverScrollableScrollPhysics(),
          //   padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          //   itemBuilder: (context, index){
          //     return Row(children: [
          //       widget.product.structure[index].freeAmount > 0 ?  Text("${widget.product.structure[index].name}(Free:${widget.product.structure[index].freeAmount.toString()})", style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)):Text(widget.product.structure[index].name, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
          //       Expanded(child: SizedBox()),
          //       _itemQtyButton(productProvider, index),
          //     ]);
          //   },
          // ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              childAspectRatio: (1 / 1.1),
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.product.structure.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => productProvider.itemQtyList[index] < widget.product.structure[index].maxAmount ?  productProvider.setItmQuantity(true,index,widget.product.structure[index],widget.product.item_ttl_free) : null,

                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: productProvider.itemQtyList[index] > 0 ? 2 : 20),
                  decoration: BoxDecoration(
                    color: productProvider.itemQtyList[index] > 0
                        ? Theme.of(context).primaryColor
                        : ColorResources.BACKGROUND_COLOR,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: productProvider.itemQtyList[index] > 0
                        ? [BoxShadow(
                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                      blurRadius:Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                      spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                    )]
                        : null,
                  ),
                  child: Column(children: [
                    Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          // Text(widget.product.addOns[index].name,
                          //     maxLines: 2,
                          //     overflow: TextOverflow.ellipsis,
                          //     textAlign: TextAlign.center,
                          //     style: rubikMedium.copyWith(
                          //       color: productProvider.addOnActiveList[index]
                          //           ? ColorResources.COLOR_WHITE
                          //           : ColorResources.COLOR_BLACK,
                          //       fontSize: Dimensions.FONT_SIZE_SMALL,
                          //     )),
                          widget.product.structure[index].freeAmount > 0 ?  
                          Text("${widget.product.structure[index].name}(Free:${widget.product.structure[index].freeAmount.toString()})",
                           maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: rubikMedium.copyWith(
                                color: productProvider.itemQtyList[index] > 0
                                    ? ColorResources.COLOR_WHITE
                                    : ColorResources.COLOR_BLACK,
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                              ))
                          :Text(widget.product.structure[index].name,
                          maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: rubikMedium.copyWith(
                                color: productProvider.itemQtyList[index] > 0
                                    ? ColorResources.COLOR_WHITE
                                    : ColorResources.COLOR_BLACK,
                                fontSize: Dimensions.FONT_SIZE_SMALL,)),
                          SizedBox(height: 5),
                          Text(
                            PriceConverter.convertPrice(context, widget.product.structure[index].price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: rubikRegular.copyWith(
                                color: productProvider.itemQtyList[index] > 0
                                    ? ColorResources.COLOR_WHITE
                                    : ColorResources.COLOR_BLACK,
                                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                          ),
                        ])),
                    productProvider.itemQtyList[index] > 0 ? Container(
                      height: 25,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).cardColor),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => productProvider.itemQtyList[index] > 0 ?  productProvider.setItmQuantity(false,index,widget.product.structure[index],widget.product.item_ttl_free) : null,
                            child: Center(child: Icon(Icons.remove, size: 15)),
                          ),
                        ),
                        Text(productProvider.itemQtyList[index].toString(),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                        Expanded(
                          child: InkWell(
                            onTap: () => productProvider.itemQtyList[index] < widget.product.structure[index].maxAmount ?  productProvider.setItmQuantity(true,index,widget.product.structure[index],widget.product.item_ttl_free) : null,
                            child: Center(child: Icon(Icons.add, size: 15)),
                          ),
                        ),
                      ]),
                    )
                        : SizedBox(),
                  ]),
                ),
              );
            },
          ),
        ],
      );

  }


  Widget _description(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(getTranslated('description', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      Align(
        alignment: Alignment.topLeft,
        child: ReadMoreText(widget.product.description ?? '',
          trimLines: 2,
          trimCollapsedText: getTranslated('show_more', context),
          trimExpandedText: getTranslated('show_less', context),
          moreStyle: robotoRegular.copyWith(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
          ),
          lessStyle: robotoRegular.copyWith(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
          ),
        ),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
    ]);
  }

  Widget _cartButton(bool _isAvailable, BuildContext context, CartModel _cartModel) {
    return Column(children: [
      _isAvailable ? SizedBox() :
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Column(children: [
          Text(getTranslated('not_available_now', context),
              style: rubikMedium.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.FONT_SIZE_LARGE,
              )),
          Text(
            '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts, context)} '
                '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds, context)}',
            style: rubikRegular,
          ),
        ]),
      ),

      CustomButton(
          btnTxt: getTranslated(
             _cartIndex != -1
                ? 'update_in_cart'
                : 'add_to_cart', context,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () {
            Navigator.pop(context);
            Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel,_cartIndex);
          }
      ),
    ]);
  }

  Widget _productView(
      BuildContext context, double _startingPrice, double _endingPrice, double price,
      double priceWithDiscount,
      CartModel cartModel,
      ) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: Images.placeholder_rectangle,
          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.product.image}',
          width: ResponsiveHelper.isMobile(context)
              ? 100
              : ResponsiveHelper.isTab(context)
              ? 140
              : ResponsiveHelper.isDesktop(context)
              ? 140
              : null,
          height: ResponsiveHelper.isMobile(context)
              ? 100
              : ResponsiveHelper.isTab(context)
              ? 140
              : ResponsiveHelper.isDesktop(context)
              ? 140
              : null,
          fit: BoxFit.cover,
          imageErrorBuilder: (c, o, s) => Image.asset(
            Images.placeholder_rectangle,
            width: ResponsiveHelper.isMobile(context)
                ? 100
                : ResponsiveHelper.isTab(context)
                ? 140
                : ResponsiveHelper.isDesktop(context)
                ? 140
                : null,
            height: ResponsiveHelper.isMobile(context)
                ? 100
                : ResponsiveHelper.isTab(context)
                ? 140
                : ResponsiveHelper.isDesktop(context)
                ? 140
                : null,
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
              ),

             if(!ResponsiveHelper.isMobile(context)) WishButton(product: widget.product),



            ],
          ),
          SizedBox(height: 10),
          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     RatingBar(rating: widget.product.rating.length > 0 ? double.parse(widget.product.rating[0].average) : 0.0, size: 15),
          //     widget.product.productType != null ? VegTagView(product: widget.product) : SizedBox(),
          //   ],
          // ),
          SizedBox(height: 35),

          Row( mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,  children: [
                FittedBox(
                  child: Text(
                    '${PriceConverter.convertPrice(context, _startingPrice, discount: widget.product.discount, discountType: widget.product.discountType)}'
                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(
                    context, _endingPrice, discount: widget.product.discount, discountType: widget.product.discountType,
                    )}' : ''}',

                    style: rubikMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      overflow: TextOverflow.ellipsis,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 1,
                  ),
                ),


                price > priceWithDiscount ? FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text('${PriceConverter.convertPrice(context, _startingPrice)}'
                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                      style: rubikMedium.copyWith(color: ColorResources.COLOR_GREY, decoration: TextDecoration.lineThrough, overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ),
                ) : SizedBox(),

              ]),
            ),
           if(ResponsiveHelper.isMobile(context)) WishButton(product: widget.product),

          ]),
          if(!ResponsiveHelper.isMobile(context)) _quantityView(context, cartModel)
        ]),
      ),
    ]);
  }

  Widget _quantityButton(BuildContext context, CartModel _cartModel) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        InkWell(
          onTap: () => productProvider.quantity > 1 ?  productProvider.setQuantity(false) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.remove, size: 20),
          ),
        ),
        Text(productProvider.quantity.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),

        InkWell(
          onTap: () => productProvider.setQuantity(true),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(Icons.add, size: 20),
          ),
        ),
      ]),
    );
  }
  //Added by Sopan
  // Widget _itemQtyButton(ProductProvider productProvider, int index) {
  //   return Container(
  //     decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(5)),
  //     child: Row(children: [
  //       InkWell(
  //         onTap: () => productProvider.itemQtyList[index] > 0 ?  productProvider.setItmQuantity(false,index,widget.product.structure[index],widget.product.item_ttl_free) : null,
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(
  //               horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
  //           child: Icon(Icons.remove, size: 20),
  //         ),
  //       ),
  //       Text(productProvider.itemQtyList[index].toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),

  //       InkWell(
  //         onTap: () => productProvider.itemQtyList[index] < widget.product.structure[index].maxAmount ?  productProvider.setItmQuantity(true,index,widget.product.structure[index],widget.product.item_ttl_free) : null,
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(
  //               horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
  //           child: Icon(Icons.add, size: 20),
  //         ),
  //       ),
  //     ]),
  //   );
  // }
}

class VegTagView extends StatelessWidget {
  final Product product;
  const VegTagView({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(blurRadius: 5, color: Theme.of(context).backgroundColor.withOpacity(0.05))],
      ),

      child: SizedBox(height:  30,
        child: Row(
          children: [
            Padding(
              padding:  EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Image.asset(
                Images.getImageUrl('${product.productType}',
                ), fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

            Text(
              getTranslated('${product.productType}', context),
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          ],
        ),
      ),
    );
  }
}

