// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_state_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountStateRes _$AccountStateResFromJson(Map<String, dynamic> json) {
  return AccountStateRes(json['id'] as int, json['favorite'] as bool,
      json['rated'], json['watchlist'] as bool);
}

Map<String, dynamic> _$AccountStateResToJson(AccountStateRes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'favorite': instance.favorite,
      'rated': instance.rated,
      'watchlist': instance.watchlist
    };

Rated _$RatedFromJson(Map<String, dynamic> json) {
  return Rated((json['value'] as num)?.toDouble());
}

Map<String, dynamic> _$RatedToJson(Rated instance) =>
    <String, dynamic>{'value': instance.value};
