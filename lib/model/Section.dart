class Section {
  final String name;

  Section({
    required this.name,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      name: json['name'],
    );
  }
}


