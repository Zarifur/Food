import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

class ExclusiveProductView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final _productProvider = Provider.of<ProductProvider>(context, listen: false);

    // if(!ResponsiveHelper.isDesktop(context) && productType == ProductType.LATEST_PRODUCT) {
    //   scrollController?.addListener(() {

    //     if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
    //         (_productProvider.latestProductList != null) && !_productProvider.isLoading
    //     ) {
    //       int pageSize;
    //       if (productType == ProductType.LATEST_PRODUCT) {
    //         pageSize = (_productProvider.latestPageSize / 10).ceil();
    //       }
    //       if (_productProvider.latestOffset < pageSize) {
    //         _productProvider.latestOffset ++;
    //         _productProvider.showBottomLoader();
    //         if(productType == ProductType.LATEST_PRODUCT) {
    //           _productProvider.getLatestProductList(
    //             context, false, _productProvider.latestOffset.toString(),
    //             Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    //           );
    //         }

    //       }
    //     }
    //   });

    // }
    
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;        
        productList = prodProvider.exclusiveProductList;
        if(productList == null ) {
          return 
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  width: 195,
                  child: ProductWidgetWebShimmer(),
                );},
            ),
          );
        }
        // if(productList.length == 0) {
        //   return SizedBox();
        // }

        // return SizedBox(
        //       height: 250,
        //       child: ListView.builder(
        //         scrollDirection: Axis.horizontal,
        //         physics: BouncingScrollPhysics(),
        //         itemCount: productList.length,
        //         itemBuilder: (context, index) {
        //           return Container(
        //             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        //             width: 195,
        //             child: ProductWidgetWeb(product: productList[index], fromPopularItem: true),
        //           );
        //         },
        //       ),
        // );
        return productList.length != 0 ? Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.PADDING_SIZE_SMALL,0,Dimensions.PADDING_SIZE_SMALL,0),
            child: LayoutBuilder(
              builder: (context,constraints) {
                return GridView.builder(
                  
                  itemCount: productList.length,  
                    // gridDelegate: ResponsiveHelper.isDesktop(context)
                    //  ? SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
                    // SliverGridDelegateWithFixedCrossAxisCount(  
                    //     crossAxisCount: constraints.maxWidth > 700 ? 4 : 2,  
                    //     crossAxisSpacing: 4.0,
                    //     childAspectRatio: 0.689,  
                    //     mainAxisSpacing: 2.0  
                    // ), 
                    gridDelegate: ResponsiveHelper.isDesktop(context)
                     ? SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
                    SliverGridDelegateWithFixedCrossAxisCount(  
                        // crossAxisCount: constraints.maxWidth > 700 ? constraints.maxWidth > 900 ? 5:4 :constraints.maxWidth > 500 ? 3:2,  
                        crossAxisCount: constraints.maxWidth > 800 ? constraints.maxWidth > 1000 ? 5:4 :constraints.maxWidth > 600 ? 3:2,
                        crossAxisSpacing: 4.0,
                        // childAspectRatio: constraints.maxWidth > 374 ? 0.65:1/2.3,
                        childAspectRatio: constraints.maxWidth > 300 ? 0.65:1/1.8,
                        mainAxisSpacing: 2.0,
                        // mainAxisExtent: 325,
                    ), 
                     physics:NeverScrollableScrollPhysics(),
                     shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                    return ResponsiveHelper.isDesktop(context) ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ProductWidgetWeb(product: productList[index]),
                    ) : ProductWidget(product: productList[index]);
                  },
                );
              }
            ),
          ): Center(child: Text("No Exclusive Items Available"));
      },
      
    );
  }
}
