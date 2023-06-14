import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';


class PlaceOrderBody {
  List<Cart> _cart;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  double _orderAmount;
  String _orderType;
  int _deliveryAddressId;
  String _paymentMethod;
  String _orderNote;
  String _couponCode;
  String _deliveryTime;
  String _deliveryDate;
  int _branchId;
  double _distance;
  String _transactionReference;

  //Added by Me
  int _tableId;
  int _numberOfPeople;

  PlaceOrderBody copyWith({String paymentMethod, String transactionReference}) {
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    return this;
  }

  PlaceOrderBody(
      {@required List<Cart> cart,
        @required double couponDiscountAmount,
        @required String couponDiscountTitle,
        @required String couponCode,
        @required double orderAmount,
        @required int deliveryAddressId,
        @required String orderType,
        @required String paymentMethod,
        @required int branchId,
        @required String deliveryTime,
        @required String deliveryDate,
        @required String orderNote,
        @required double distance,
        String transactionReference,
        int tableId,
        int numberOfPeople
      }) {
    this._cart = cart;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._orderAmount = orderAmount;
    this._orderType = orderType;
    this._deliveryAddressId = deliveryAddressId;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._deliveryTime = deliveryTime;
    this._deliveryDate = deliveryDate;
    this._branchId = branchId;
    this._distance = distance;
    this._transactionReference = transactionReference;
    this._tableId = tableId;
    this._numberOfPeople = numberOfPeople;
  }

  List<Cart> get cart => _cart;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  double get orderAmount => _orderAmount;
  String get orderType => _orderType;
  int get deliveryAddressId => _deliveryAddressId;
  String get paymentMethod => _paymentMethod;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;
  String get deliveryTime => _deliveryTime;
  String get deliveryDate => _deliveryDate;
  int get branchId => _branchId;
  double get distance => _distance;
  String get transactionReference => _transactionReference;

  int get tableId => _tableId;
  int get numberOfPeople => _numberOfPeople;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _orderType = json['order_type'];
    _deliveryAddressId = json['delivery_address_id'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    _branchId = json['branch_id'];
    _distance = json['distance'];

    _tableId = json['table_id'];
    _numberOfPeople = json['number_of_people'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['order_amount'] = this._orderAmount;
    data['order_type'] = this._orderType;
    data['delivery_address_id'] = this._deliveryAddressId;
    data['payment_method'] = this._paymentMethod;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    data['delivery_time'] = this._deliveryTime;
    data['delivery_date'] = this._deliveryDate;
    data['branch_id'] = this._branchId;
    data['distance'] = this._distance;
    if(_transactionReference != null) {
      data['transaction_reference'] = this._transactionReference;
    }
    if(_tableId != null) {
      data['table_id'] = this._tableId;
      data['number_of_people'] = this._numberOfPeople;
    }    
    return data;
  }
}

class ProItem{
  String _name;
  int _quantity;

  ProItem({String name,int quantity}) {
    this._name = name;
    this._quantity = quantity;
  }

  ProItem.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['quantity'] = this._quantity;
    return data;
  }

  String get name => _name;
  int get quantity => _quantity;
}

class Cart {
  String _productId;
  String _price;
  String _variant;
  List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  List<int> _addOnIds;
  List<int> _addOnQtys;
  List<ProItem> _items;
  MealItem _side;
  MealItem _drink;
  MealItem _dip;
  int _isMeal;
  String _items_price;

  Cart(
      String productId,
        String price,
        String variant,
        List<Variation> variation,
        double discountAmount,
        int quantity,
        double taxAmount,
        List<int> addOnIds,
        List<int> addOnQtys,
        List<ProItem> items,
        MealItem side,
        MealItem drink,
        MealItem dip,
        int isMeal,
        String items_price
        ) {
    this._productId = productId;
    this._price = price;
    this._variant = variant;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._addOnQtys = addOnQtys;
    this._items = items;
    this._side = side;
    this._drink = drink;
    this._dip = dip;
    this._isMeal = isMeal;
    this._items_price = items_price;
  }

  String get productId => _productId;
  String get price => _price;
  String get itemsPrice => _items_price;
  String get variant => _variant;
  List<Variation> get variation => _variation;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  List<int> get addOnIds => _addOnIds;
  List<int> get addOnQtys => _addOnQtys;
  List<ProItem> get items => _items;
  MealItem get side => _side;
  MealItem get drink => _drink;
  MealItem get dip => _dip;
  int get isMeal => _isMeal;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'];
    _items_price = json['items_price'];
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
    _addOnIds = json['add_on_ids'].cast<int>();
    _addOnQtys = json['add_on_qtys'].cast<int>();
    if(json["items"] != null){
      _items=[];
      json['items'].forEach((v){
        _items.add(ProItem.fromJson(v));
      });
    }
    if(json["is_meal"] == 1){
      if(json['sides'] != null){
        _side= MealItem.fromJson(json['sides']);
      }
      if(json['drinks'] != null){
        _drink= MealItem.fromJson(json['drinks']);
      }
      if(json['dips'] != null){
        _dip= MealItem.fromJson(json['dips']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['price'] = this._price;
    data['items_price'] = this._items_price;
    data['variant'] = this._variant;

    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['add_on_ids'] = this._addOnIds;
    data['add_on_qtys'] = this._addOnQtys;
    if(this._items != null){
      data['items'] = this._items.map((v) => v.toJson()).toList();
    }
    if(this._isMeal == 1){
      data['is_meal'] = 1;
      if(this._side != null){
        data['sides']= _side.toJson();
      }
      if(this._drink != null){
        data['drinks']= this._drink.toJson();
      }
      if(this._dip != null){
        data['dips']= this._dip.toJson();
      }
    }else{
      data['is_meal'] = 0;
    }
    return data;
  }
}
