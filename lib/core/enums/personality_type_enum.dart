enum PersonalityTypeEnum {
  ie('I/E'),
  sn('S/N'),
  ft('F/T'),
  pj('P/J');

  final String? customCode;
  const PersonalityTypeEnum([this.customCode]);
  String get code => customCode ?? name.toUpperCase();
  static PersonalityTypeEnum? fromCode(String? code) {
    if (code == null) return null;
    final upper = code.trim().toUpperCase();
    for (final val in PersonalityTypeEnum.values) {
      if (val.code == upper || val.name.toUpperCase() == upper) return val;
    }
    return null;
  }
}
