class AppleLoginModel {
  String token;
  String uniqueId;
  String medium;
  String email;
  String firstName;
  String lastName;
  AppleLoginModel({this.token, this.uniqueId, this.medium, this.email,this.firstName,this.lastName});

  AppleLoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    uniqueId = json['unique_id'];
    medium = json['medium'];
    email = json['email'];
    firstName = json['f_name'];
    lastName = json['l_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['unique_id'] = this.uniqueId;
    data['medium'] = this.medium;
    data['email'] = this.email;
    data['f_name'] = this.firstName;
    data['l_name'] = this.lastName;
    return data;
  }
}
