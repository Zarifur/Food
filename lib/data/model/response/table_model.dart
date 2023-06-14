class TableModel {
  int id;
  int number;
  int capacity;
  int branchId;
  int isActive;
  String createdAt;
  String updatedAt;

  TableModel(
      {this.id,
      this.number,
      this.capacity,
      this.branchId,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    capacity = json['capacity'];
    branchId = json['branch_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['capacity'] = this.capacity;
    data['branch_id'] = this.branchId;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}