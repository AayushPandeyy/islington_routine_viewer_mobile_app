import 'package:islington_routine_viewer_app/model/Section.dart';

class Field {
  final String title;
  final List<Section> sections;

  Field({
    required this.title,
    required this.sections,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    var sectionsFromJson = json['sections'] as List;
    List<Section> sectionList = sectionsFromJson.map((s) => Section.fromJson(s)).toList();

    return Field(
      title: json['title'],
      sections: sectionList,
    );
  }
}

