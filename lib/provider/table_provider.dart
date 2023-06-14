import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/base/api_response.dart';
import '../data/model/response/table_model.dart';
import '../data/repository/table_repo.dart';
import '../helper/api_checker.dart';

class TableProvider extends ChangeNotifier {
  final TableRepo tableRepo;
  // final SharedPreferences sharedPreferences;
  TableProvider({ @required this.tableRepo});

  List<TableModel> _tableList;


  
  List<TableModel> get tableList => _tableList;

  Future<void> getTableList(BuildContext context, bool reload) async {
    if (tableList == null || reload) {
      ApiResponse apiResponse = await tableRepo.getTableList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _tableList = [];
        apiResponse.response.data.forEach((v) =>
            _tableList.add(TableModel.fromJson(v)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }
 


  // Future<void> setPlaceOrder(String placeOrder)async{
  //   await sharedPreferences.setString(AppConstants.PLACE_ORDER_DATA, placeOrder);
  // }
  // String getPlaceOrder(){
  //   return sharedPreferences.getString(AppConstants.PLACE_ORDER_DATA);
  // }
  // Future<void> clearPlaceOrder()async{
  //   await sharedPreferences.remove(AppConstants.PLACE_ORDER_DATA);
  // }


}