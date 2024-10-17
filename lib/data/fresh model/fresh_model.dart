class FreshModel {
  double? confidence;
  String? expiryDate;
  String? fruitClass;
  ShelfLife? shelfLife;

  FreshModel(
      {this.confidence, this.expiryDate, this.fruitClass, this.shelfLife});

  FreshModel.fromJson(Map<String, dynamic> json) {
    confidence = json['confidence'];
    expiryDate = json['expiry_date'];
    fruitClass = json['fruit_class'];
    shelfLife = json['shelf_life'] != null
        ? new ShelfLife.fromJson(json['shelf_life'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confidence'] = this.confidence;
    data['expiry_date'] = this.expiryDate;
    data['fruit_class'] = this.fruitClass;
    if (this.shelfLife != null) {
      data['shelf_life'] = this.shelfLife!.toJson();
    }
    return data;
  }
}

class ShelfLife {
  int? estimatedDays;
  String? freezer;
  String? refrigerator;
  String? shelf;

  ShelfLife({this.estimatedDays, this.freezer, this.refrigerator, this.shelf});

  ShelfLife.fromJson(Map<String, dynamic> json) {
    estimatedDays = json['estimated_days'];
    freezer = json['freezer'];
    refrigerator = json['refrigerator'];
    shelf = json['shelf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['estimated_days'] = this.estimatedDays;
    data['freezer'] = this.freezer;
    data['refrigerator'] = this.refrigerator;
    data['shelf'] = this.shelf;
    return data;
  }
}
