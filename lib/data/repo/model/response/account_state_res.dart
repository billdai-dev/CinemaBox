import 'package:json_annotation/json_annotation.dart';

part 'account_state_res.g.dart';

@JsonSerializable()
class AccountStateRes extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'favorite')
  bool favorite;

  @JsonKey(name: 'rated')
  var rated;

  @JsonKey(name: 'watchlist')
  bool watchlist;

  AccountStateRes(
    this.id,
    this.favorite,
    this.rated,
    this.watchlist,
  );

  factory AccountStateRes.fromJson(Map<String, dynamic> srcJson) =>
      _$AccountStateResFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccountStateResToJson(this);
}

@JsonSerializable()
class Rated extends Object {
  @JsonKey(name: 'value')
  double value;

  Rated(
    this.value,
  );

  factory Rated.fromJson(Map<String, dynamic> srcJson) =>
      _$RatedFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RatedToJson(this);
}
