import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'country_codes.dart';
import 'country_localizations.dart';

mixin ToAlias {}

/// Country element. This is the element that contains all the information
class CountryCode extends Equatable {
  /// the name of the country
  final String? name;

  /// the flag of the country
  final String? flagUri;

  /// the country code (IT,AF..)
  final String? code;

  /// the dial code (+39,+93..)
  final String? dialCode;

  const CountryCode({
    this.name,
    this.flagUri,
    this.code,
    this.dialCode,
  });

  @Deprecated('Use `fromCountryCode` instead.')
  factory CountryCode.fromCode(String isoCode) {
    return CountryCode.fromCountryCode(isoCode);
  }

  factory CountryCode.fromCountryCode(String countryCode) {
    final Map<String, String>? jsonCode = codes.firstWhereOrNull(
      (code) => code['code'] == countryCode,
    );
    return CountryCode.fromJson(jsonCode!);
  }

  static CountryCode? tryFromCountryCode(String countryCode) {
    try {
      return CountryCode.fromCountryCode(countryCode);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to recognize country from countryCode: $countryCode');
      }
      return null;
    }
  }

  factory CountryCode.fromDialCode(String dialCode) {
    final Map<String, String>? jsonCode = codes.firstWhereOrNull(
      (code) => code['dial_code'] == dialCode,
    );
    return CountryCode.fromJson(jsonCode!);
  }

  static CountryCode? tryFromDialCode(String dialCode) {
    try {
      return CountryCode.fromDialCode(dialCode);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to recognize country from dialCode: $dialCode');
      }
      return null;
    }
  }

  CountryCode localize(BuildContext context) {
    return copyWith(
        name: CountryLocalizations.of(context)?.translate(code) ?? name);
  }

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      name: json['name'],
      code: json['code'],
      dialCode: json['dial_code'],
      flagUri: 'flags/${json['code'].toLowerCase()}.png',
    );
  }

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode ${toCountryStringOnly()}";

  String toCountryStringOnly() {
    return '$_cleanName';
  }

  String? get _cleanName {
    return name?.replaceAll(RegExp(r'[[\]]'), '').split(',').first;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, flagUri, code, dialCode];

  CountryCode copyWith({
    String? name,
    String? flagUri,
    String? code,
    String? dialCode,
  }) {
    return CountryCode(
      name: name ?? this.name,
      flagUri: flagUri ?? this.flagUri,
      code: code ?? this.code,
      dialCode: dialCode ?? this.dialCode,
    );
  }
}
