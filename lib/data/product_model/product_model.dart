class Product {
  String? productName;
  String? brand;
  String? productType;
  String? manufactureDate;
  String? expiryDate;
  String? size;
  String? mrp;
  String? quantity;
  List<String>? ingredients;
  String? sterilizationMethod;
  String? directions;
  String? safetyWarning;
  NutritionalValue? nutritionalValue;
  Manufacturer? manufacturer;

  Product({
    this.productName,
    this.brand,
    this.productType,
    this.manufactureDate,
    this.expiryDate,
    this.size,
    this.mrp,
    this.quantity,
    this.ingredients,
    this.sterilizationMethod,
    this.directions,
    this.safetyWarning,
    this.nutritionalValue,
    this.manufacturer,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName'],
      brand: json['brand'],
      productType: json['productType'],
      manufactureDate: json['manufactureDate'],
      expiryDate: json['expiryDate'],
      size: json['size'],
      mrp: json['mrp'],
      quantity: json['quantity'],
      ingredients: List<String>.from(json['ingredients']),
      sterilizationMethod: json['sterilizationMethod'],
      directions: json['directions'],
      safetyWarning: json['safetyWarning'],
      nutritionalValue: json['nutritionalValue'] != null ? NutritionalValue.fromJson(json['nutritionalValue']) : null,
      manufacturer: json['manufacturer'] != null ? Manufacturer.fromJson(json['manufacturer']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'brand': brand,
      'productType': productType,
      'manufactureDate': manufactureDate,
      'expiryDate': expiryDate,
      'size': size,
      'mrp': mrp,
      'quantity': quantity,
      'ingredients': ingredients,
      'sterilizationMethod': sterilizationMethod,
      'directions': directions,
      'safetyWarning': safetyWarning,
      'nutritionalValue': nutritionalValue?.toJson(),
      'manufacturer': manufacturer?.toJson(),
    };
  }
}

class NutritionalValue {
  String? calories;
  String? protein;
  String? carbohydrates;
  String? sugars;
  String? fats;

  NutritionalValue({
    this.calories,
    this.protein,
    this.carbohydrates,
    this.sugars,
    this.fats,
  });

  factory NutritionalValue.fromJson(Map<String, dynamic> json) {
    return NutritionalValue(
      calories: json['calories'],
      protein: json['protein'],
      carbohydrates: json['carbohydrates'],
      sugars: json['sugars'],
      fats: json['fats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'sugars': sugars,
      'fats': fats,
    };
  }
}

class Manufacturer {
  String? name;
  List<String>? certifications;
  Address? address;
  Contact? contact;

  Manufacturer({
    this.name,
    this.certifications,
    this.address,
    this.contact,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      name: json['name'],
      certifications: List<String>.from(json['certifications']),
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      contact: json['contact'] != null ? Contact.fromJson(json['contact']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'certifications': certifications,
      'address': address?.toJson(),
      'contact': contact?.toJson(),
    };
  }
}

class Address {
  String? manufacturing;
  String? registered;

  Address({
    this.manufacturing,
    this.registered,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      manufacturing: json['manufacturing'],
      registered: json['registered'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manufacturing': manufacturing,
      'registered': registered,
    };
  }
}

class Contact {
  String? email;
  String? website;
  String? customerCareNumber;

  Contact({
    this.email,
    this.website,
    this.customerCareNumber,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'],
      website: json['website'],
      customerCareNumber: json['customerCareNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'website': website,
      'customerCareNumber': customerCareNumber,
    };
  }
}
