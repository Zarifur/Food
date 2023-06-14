import 'dart:convert';

class ProductModel {
  int _totalSize;
  String _limit;
  String _offset;
  List<Product> _products;

  ProductModel(
      {int totalSize, String limit, String offset, List<Product> products}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._products = products;
  }

  int get totalSize => _totalSize;
  String get limit => _limit;
  String get offset => _offset;
  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'].toString();
    _offset = json['offset'].toString();
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int _id;
  String _name;
  String _description;
  String _image;
  double _price;
  List<Variation> _variations;
  List<AddOns> _addOns;
  double _tax;
  String _availableTimeStarts;
  String _availableTimeEnds;
  int _status;
  String _createdAt;
  String _updatedAt;
  List<String> _attributes;
  List<CategoryId> _categoryIds;
  List<ChoiceOption> _choiceOptions;
  double _discount;
  String _discountType;
  String _taxType;
  int _setMenu;
  List<Rating> _rating;
  List<MealItem> _sides;
  List<MealItem> _drinks;
  List<MealItem> _dips;
  double _meal_price;
  List<Item> _structure;
  int  _item_ttl_free; 
  Product(
      {int id,
        String name,
        String description,
        String image,
        double price,
        List<Variation> variations,
        List<AddOns> addOns,
        double tax,
        String availableTimeStarts,
        String availableTimeEnds,
        int status,
        String createdAt,
        String updatedAt,
        List<String> attributes,
        List<CategoryId> categoryIds,
        List<ChoiceOption> choiceOptions,
        double discount,
        String discountType,
        String taxType,
        int setMenu,
        List<Rating> rating,
        List<MealItem> sides,
        List<MealItem> drinks,
        List<MealItem> dips,
        double meal_price,
        List<Item> structure,
        int item_ttl_free}) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._image = image;
    this._price = price;
    this._variations = variations;
    this._addOns = addOns;
    this._tax = tax;
    this._availableTimeStarts = availableTimeStarts;
    this._availableTimeEnds = availableTimeEnds;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._attributes = attributes;
    this._categoryIds = categoryIds;
    this._choiceOptions = choiceOptions;
    this._discount = discount;
    this._discountType = discountType;
    this._taxType = taxType;
    this._setMenu = setMenu;
    this._rating = rating;
    this._sides = sides;
    this._drinks = drinks;
    this._dips = dips;
    this._meal_price = meal_price;
    this._structure = structure;
    this._item_ttl_free = item_ttl_free;
  }

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get image => _image;
  double get price => _price;
  List<Variation> get variations => _variations;
  List<AddOns> get addOns => _addOns;
  double get tax => _tax;
  String get availableTimeStarts => _availableTimeStarts;
  String get availableTimeEnds => _availableTimeEnds;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  List<String> get attributes => _attributes;
  List<CategoryId> get categoryIds => _categoryIds;
  List<ChoiceOption> get choiceOptions => _choiceOptions;
  double get discount => _discount;
  String get discountType => _discountType;
  String get taxType => _taxType;
  int get setMenu => _setMenu;
  List<Rating> get rating => _rating;
  List<MealItem> get sides => _sides;
  List<MealItem> get drinks => _drinks;
  List<MealItem> get dips => _dips;


  double get mealPrice => _meal_price;
  List<Item> get structure => _structure;
  int get item_ttl_free=> _item_ttl_free;
  String productType;


  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _image = json['image'];
    _price = json['price'].toDouble();
    if (json['variations'] != null) {
      _variations = [];
      json['variations'].forEach((v) {
        _variations.add(new Variation.fromJson(v));
      });
    }
  //Added by Me Sopan
    if(json["meal_price"] != null){
      _meal_price =  json["meal_price"] is String ? double.parse(json["meal_price"]):json["meal_price"].toDouble();
      _sides =[];
      _drinks = [];
      _dips=[];
      if(json['sides']!=null){
        if(json['sides'] is String){
          jsonDecode(json['sides']).forEach((v){
          _sides.add(MealItem.fromJson(v));
        });
        }else{
          json['sides'].forEach((v){
            _sides.add(MealItem.fromJson(v));
          });
        }
      }
      if(json['drinks']!=null){
        
        if(json['drinks'] is String){
          jsonDecode(json['drinks']).forEach((v){
          _drinks.add(MealItem.fromJson(v));
        });
        }else{
          json['drinks'].forEach((v){
            _drinks.add(MealItem.fromJson(v));
          });
        }  
      }
      if(json['dips'] != null){
        //  List<dynamic> dips = jsonDecode(json['dips']);
        if(json['dips'] is String){
          jsonDecode(json['dips']).forEach((v){
          _dips.add(MealItem.fromJson(v));
        });
        }else{
          json['dips'].forEach((v){
            _dips.add(MealItem.fromJson(v));
          });
        }  
      }

    }
    
    if (json['structure'] != null) {
      _structure = [];
      if(json['structure'] is String){
          jsonDecode(json['structure']).forEach((v) {
          _structure.add(new Item.fromJson(v));
        });
        }else{
          json['structure'].forEach((v) {
          _structure.add(new Item.fromJson(v));
        });
        }  
      // json['structure'].forEach((v) {
      //   _structure.add(new Item.fromJson(v));
      // });
    }else{
      _structure = [];
      _structure.add(new Item(item: "None",item_defAmount: -1,item_maxAmount: -1,item_Price: -1,item_freeAmount: -1));
    }

    _item_ttl_free = json['item_ttl_free'];

    //Added by Me Sopan end

    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns.add(new AddOns.fromJson(v));
      });
    }
    _tax = json['tax'].toDouble();
    // _tax = json['tax'].toDouble();
    _availableTimeStarts = json['available_time_starts'] ?? '';
    _availableTimeEnds = json['available_time_ends'] ?? '' ;
    _status = json['status'] ?? 0;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _attributes = json['attributes'].cast<String>();
    if (json['category_ids'] != null) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds.add(new CategoryId.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions.add(new ChoiceOption.fromJson(v));
      });
    }
    _discount = json['discount'].toDouble();
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];
    _setMenu = json['set_menu'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating.add(new Rating.fromJson(v));
      });
    }
    productType=  json["product_type"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['description'] = this._description;
    data['image'] = this._image;
    data['price'] = this._price;
    if (this._variations != null) {
      data['variations'] = this._variations.map((v) => v.toJson()).toList();
    }
    // if (this._variations != null) {
    //   data['variations'] = this._variations.map((v) => v.toJson()).toList();
    // }

    if (this._structure != null) {
      data['structure'] = this._structure.map((v) => v.toJson()).toList();
    }

    if(this._meal_price != null){
      data['meal_price'] = this._meal_price;
      data['sides'] = this._sides.map((v) => v.toJson()).toList();
      data['drinks'] = this._drinks.map((v) => v.toJson()).toList();
      data['dips'] = this._dips.map((v) => v.toJson()).toList();
    }
    data['item_ttl_free'] = this._item_ttl_free;
    if (this._addOns != null) {
      data['add_ons'] = this._addOns.map((v) => v.toJson()).toList();
    }
    data['tax'] = this._tax;
    data['available_time_starts'] = this._availableTimeStarts;
    data['available_time_ends'] = this._availableTimeEnds;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['attributes'] = this._attributes;
    if (this._categoryIds != null) {
      data['category_ids'] = this._categoryIds.map((v) => v.toJson()).toList();
    }
    if (this._choiceOptions != null) {
      data['choice_options'] =
          this._choiceOptions.map((v) => v.toJson()).toList();
    }
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['tax_type'] = this._taxType;
    data['set_menu'] = this._setMenu;
    if (this._rating != null) {
      data['rating'] = this._rating.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealItem{
  String _name;
  double _price;

  MealItem({String Name,double Price}) {
    this._name = Name;
    this._price = Price;
  }

  MealItem.fromJson(Map<String, dynamic> json) {
    String pr = json['Price'].toString();
    _name = json['Name'];
    _price = double.parse(pr);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this._name;
    data['Price'] = this._price;
    return data;
  }

  String get name => _name;
  double get price => _price;

}

class Item{
    String _name;
    int _default_amount;
    int _max_amount;
    int _free_amount;
    double _price;

  Item({String item, int item_defAmount,int item_maxAmount,double item_Price,int item_freeAmount}) {
    this._name = item;
    this._price = item_Price;
    this._default_amount = item_defAmount;
    this._max_amount = item_maxAmount;
    this._free_amount = item_freeAmount;
  }

  Item.fromJson(Map<String, dynamic> json) {
    _name = json['item'];
    _price = json['item_Price'] is String ? double.parse(json['item_Price']):json['item_Price'].toDouble();
    _default_amount = json['item_defAmount'] is String ? int.parse(json['item_defAmount']):json['item_defAmount'];
    _max_amount = json['item_maxAmount'] is String ? int.parse(json['item_maxAmount']):json['item_maxAmount'];
    _free_amount = json['item_freeAmount'] is String ? int.parse(json['item_freeAmount']):json['item_freeAmount'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_defAmount'] = this._default_amount;
    data['item_freeAmount'] = this._free_amount;
    data['item_maxAmount'] = this._max_amount;
    data['item'] = this._name;
    data['item_Price'] = this._price;
    return data;
  }

  String get name => _name;
  double get price => _price;
  int get maxAmount => _max_amount;
  int get defaultAmount => _default_amount;
  int get freeAmount => _free_amount;

}

class Variation {
  String _type;
  double _price;
  //Added by Me Sopan
  double _varMealPrice;
  Variation({String type, double price,double varMealPrice}) {
    this._type = type;
    this._price = price;
    this._varMealPrice =varMealPrice;
  }

  String get type => _type;
  double get price => _price;
  double get varMealPrice => _varMealPrice;
  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    if(json['price'] != null) {
      _price = double.parse('${json['price']}');
    }
    if(json['var_meal_price'] != null){
      _varMealPrice = double.parse('${json['var_meal_price']}');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['price'] = this._price;
    data['var_meal_price'] = this._varMealPrice;
    return data;
  }
}

class AddOns {
  int _id;
  String _name;
  double _price;
  String _createdAt;
  String _updatedAt;

  AddOns({int id, String name, double price, String createdAt, String updatedAt}) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  String get name => _name;
  double get price => _price;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  AddOns.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['price'] = this._price;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class CategoryId {
  String _id;

  CategoryId({String id}) {
    this._id = id;
  }

  String get id => _id;

  CategoryId.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    return data;
  }
}

class ChoiceOption {
  String _name;
  String _title;
  List<String> _options;

  ChoiceOption({String name, String title, List<String> options}) {
    this._name = name;
    this._title = title;
    this._options = options;
  }

  String get name => _name;
  String get title => _title;
  List<String> get options => _options;

  ChoiceOption.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['title'] = this._title;
    data['options'] = this._options;
    return data;
  }
}

class Rating {
  String _average;
  int _productId;

  Rating({String average, int productId}) {
    this._average = average;
    this._productId = productId;
  }

  String get average => _average;
  int get productId => _productId;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'];
    _productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this._average;
    data['product_id'] = this._productId;
    return data;
  }
}