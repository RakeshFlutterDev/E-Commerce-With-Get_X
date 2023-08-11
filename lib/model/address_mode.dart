class AddressModel {
  String? selectedOption;
  String? selectedAddress;
  String? address;
  String? houseNo;
  String? street;
  String? locality;

  AddressModel({
    this.selectedOption,
    this.selectedAddress,
    this.address,
    this.houseNo,
    this.street,
    this.locality,
  });

  AddressModel copyWith({
    String? houseNo,
    String? address,
    String? locality,
    String? street,
    String? selectedOption,
  }) {
    return AddressModel(
      houseNo: houseNo ?? this.houseNo,
      address: address ?? this.address,
      locality: locality ?? this.locality,
      street: street ?? this.street,
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedOption': selectedOption,
      'selectedAddress': selectedAddress,
      'houseNo': houseNo,
      'address': address,
      'street': street,
      'locality': locality,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      selectedOption: json['selectedOption'],
      selectedAddress: json['selectedAddress'],
      houseNo: json['houseNo'],
      address: json['address'],
      street: json['street'],
      locality: json['locality'],
    );
  }
}
