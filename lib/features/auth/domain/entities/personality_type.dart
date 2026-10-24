enum PersonalityType {
  ie('I/E'),
  sn('S/N'),
  ft('F/T'),
  pj('P/J'),
  intj('INTJ'),
  intp('INTP'),
  entj('ENTJ'),
  entp('ENTP'),
  infj('INFJ'),
  infp('INFP'),
  enfj('ENFJ'),
  enfp('ENFP'),
  istj('ISTJ'),
  isfj('ISFJ'),
  estj('ESTJ'),
  esfj('ESFJ'),
  istp('ISTP'),
  isfp('ISFP'),
  estp('ESTP'),
  esfp('ESFP');

  final String? customCode;
  const PersonalityType([this.customCode]);
  String get code => customCode ?? name.toUpperCase();
  static PersonalityType? fromCode(String? code) {
    if (code == null) return null;
    final upper = code.trim().toUpperCase();
    for (final val in PersonalityType.values) {
      if (val.code == upper || val.name.toUpperCase() == upper) return val;
    }
    return null;
  }
}

enum EnergySource {
  introversion('I', 'Introversion'),
  extraversion('E', 'Extraversion');

  final String code;
  final String label;
  const EnergySource(this.code, this.label);
}

enum InformationSource {
  sensing('S', 'Sensing'),
  intuition('N', 'Intuition');

  final String code;
  final String label;
  const InformationSource(this.code, this.label);
}

enum DecisionMaking {
  thinking('T', 'Thinking'),
  feeling('F', 'Feeling');

  final String code;
  final String label;
  const DecisionMaking(this.code, this.label);
}

enum Lifestyle {
  judging('J', 'Judging'),
  perceiving('P', 'Perceiving');

  final String code;
  final String label;
  const Lifestyle(this.code, this.label);
}
