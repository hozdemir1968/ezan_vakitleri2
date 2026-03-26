class SavedTownModel {
  int? id;
  int? townId;
  String? townName;

  SavedTownModel({this.id, this.townId, this.townName});

  factory SavedTownModel.fromJson(Map<String, dynamic> json) {
    return SavedTownModel(
      id: json['id'] != null ? json['id'] as int : null,
      townId: json['townId'] != null ? json['townId'] as int : null,
      townName: json['townName'] != null ? json['townName'] as String : null,
    );
  }

  factory SavedTownModel.fromMap(Map<String, dynamic> map) {
    return SavedTownModel(id: map['id'], townId: map['townId'], townName: map['townName']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'townId': townId, 'townName': townName};
  }

  @override
  String toString() => 'SavedCityModel(id: $id, townId: $townId, townName: $townName)';
}
