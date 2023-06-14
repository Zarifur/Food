import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

import '../model/body/place_order_body.dart';

class TableRepo {
  final DioClient dioClient;
  TableRepo({@required this.dioClient});

  Future<ApiResponse> getTableList() async {
    try {
      final response = await dioClient.get(AppConstants.TABLE_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  
  // Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {
  //   try {
  //     final response = await dioClient.post(AppConstants.TABLE_ORDER_URI, data: orderBody.toJson());
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
}