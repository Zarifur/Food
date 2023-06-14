import 'package:flutter_restaurant/data/model/response/product_model.dart';

class CartModel {
  double _price;
  double _discountedPrice;
  List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  List<AddOn> _addOnIds;
  List<SaveItem> _itemlist;
  double _itemsCost;
  Product _product;
  int _isMeal;
  MealItem _cart_side;
  MealItem _cart_drink;
  MealItem _cart_dip;



  CartModel(
        double price,
        double discountedPrice,
        List<Variation> variation,
        double discountAmount,
        int quantity,
        double taxAmount,
        List<AddOn> addOnIds,
        List<SaveItem> itemlist,
        double itemsCost,
        MealItem cart_side,
        MealItem cart_drink,
        MealItem cart_dip,
        int isMeal,
        Product product) {
    this._price = price;
    this._discountedPrice = discountedPrice;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._product = product;
    this._itemlist = itemlist;
    this._itemsCost = itemsCost;
    this._cart_side = cart_side;
    this._cart_drink = cart_drink;
    this._cart_dip = cart_dip;

    this._isMeal = isMeal;
  }

  double get price => _price;
  double get discountedPrice => _discountedPrice;
  List<Variation> get variation => _variation;
  double get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;
  double get taxAmount => _taxAmount;
  List<AddOn> get addOnIds => _addOnIds;
  List<SaveItem> get itemlist => _itemlist;

  set itemlist(List<SaveItem> qty) => _itemlist = qty;

  MealItem get cartSide => _cart_side;
  MealItem get cartDrink => _cart_drink;
  MealItem get cartDip => _cart_dip;

  int get isMeal => _isMeal;
  double get itemsCost => _itemsCost;
  Product get product => _product;

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    //Added by Me
    _itemsCost = json['items_cost'].toDouble();

    if (json['add_on_ids'] != null) {
      _addOnIds = [];
      json['add_on_ids'].forEach((v) {
        _addOnIds.add(new AddOn.fromJson(v));
      });
    }
    if(json['is_meal'] == 1){
      this._isMeal = 1;
      if(json['cart_side'] != null){
        _cart_side= MealItem.fromJson(json['cart_side']);
      }
      if(json['cart_drink'] != null){
        _cart_drink= MealItem.fromJson(json['cart_drink']);
      }
      if(json['cart_dip'] != null){
        _cart_dip= MealItem.fromJson(json['cart_dip']);
      }
    }else{
      this._isMeal = 0;
    }
    if(json['item_list'] != null){
        _itemlist = [];
        json['item_list'].forEach((v){
        _itemlist.add(new SaveItem.fromJson(v));  
      });
    }
    
    if (json['product'] != null) {
      _product = Product.fromJson(json['product']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;
    data['discounted_price'] = this._discountedPrice;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data["item_list"] = this._itemlist.map((v) => v.toJson()).toList();
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    if (this._addOnIds != null) {
      data['add_on_ids'] = this._addOnIds.map((v) => v.toJson()).toList();
    }
    if(this._isMeal == 1){
      data['is_meal'] = 1;
      if(this._cart_side != null && this._cart_side.price!=-1){
        data['cart_side']= _cart_side.toJson();
      }
      if(this._cart_drink != null && this._cart_drink.price != -1){
        data['cart_drink']= this._cart_drink.toJson();
      }
      if(this._cart_dip != null && this._cart_dip.price != -1){
        data['cart_dip']= this._cart_dip.toJson();
      }
    }else{
      data['is_meal'] = 0;
    }

    data['items_cost'] = this._itemsCost;
    
    data['product'] = this._product.toJson();
    return data;
  }
}
class SaveItem{
  Item _item;
  int _quantity;

  SaveItem({Item item, int quantity}) {
    this._item = item;
    this._quantity = quantity;
  }

  Item get item => _item;
  int get quantity => _quantity;

  SaveItem.fromJson(Map<String, dynamic> json) {
    _item = Item.fromJson(json['item']);
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this._item.toJson();
    data['quantity'] = this._quantity;
    return data;
  }
}
class AddOn {
  int _id;
  int _quantity;

  AddOn({int id, int quantity}) {
    this._id = id;
    this._quantity = quantity;
  }

  int get id => _id;
  int get quantity => _quantity;

  AddOn.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['quantity'] = this._quantity;
    return data;
  }
}
