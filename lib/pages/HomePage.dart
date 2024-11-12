import 'package:flutter/material.dart';
import 'package:islington_routine_viewer_app/data/SecondYear.dart';
import 'package:islington_routine_viewer_app/model/Field.dart';
import 'package:islington_routine_viewer_app/model/Section.dart';
import 'package:islington_routine_viewer_app/model/YearData.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> filteredData = [];
  YearData? selectedYear;
  Field? selectedField;
  Section? selectedSection;

  // Move field definitions to a separate class or configuration file
  static final List<YearData> yearDataList = [
    YearData(
      year: 2,
      fields: [
        Field(
          title: "Computing",
          sections: List.generate(
            18,
            (index) => Section(name: "C${index + 1}"),
          ),
        ),
        Field(
          title: "Networking",
          sections: List.generate(
            11,
            (index) => Section(name: "N${index + 1}"),
          ),
        ),
        Field(
          title: "Multimedia",
          sections: List.generate(
            6,
            (index) => Section(name: "M${index + 1}"),
          ),
        ),
        Field(
          title: "AI",
          sections: List.generate(
            6,
            (index) => Section(name: "A${index + 1}"),
          ),
        ),
      ],
    ),
  ];

  void filterData() {
    if (selectedYear == null ||
        selectedField == null ||
        selectedSection == null) {
      setState(() => filteredData = []);
      return;
    }

    setState(() {
      filteredData = SecondYear().routineData.where((item) {
        return item["year"] == "Year ${selectedYear!.year}" &&
            item["section"] == selectedSection!.name;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Routine Viewer'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdown<YearData>(
                value: selectedYear,
                items: yearDataList,
                hint: "Select Year",
                labelBuilder: (year) => "Year ${year.year}",
                onChanged: (yearData) {
                  setState(() {
                    selectedYear = yearData;
                    selectedField = null;
                    selectedSection = null;
                    filterData();
                  });
                },
              ),
              const SizedBox(height: 16),
              if (selectedYear != null)
                _buildDropdown<Field>(
                  value: selectedField,
                  items: selectedYear!.fields,
                  hint: "Select Field",
                  labelBuilder: (field) => field.title,
                  onChanged: (field) {
                    setState(() {
                      selectedField = field;
                      selectedSection = null;
                      filterData();
                    });
                  },
                ),
              const SizedBox(height: 16),
              if (selectedField != null)
                _buildDropdown<Section>(
                  value: selectedSection,
                  items: selectedField!.sections,
                  hint: "Select Section",
                  labelBuilder: (section) => section.name,
                  onChanged: (section) {
                    setState(() {
                      selectedSection = section;
                      filterData();
                    });
                  },
                ),
              const SizedBox(height: 24),
              _buildRoutineList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required String Function(T) labelBuilder,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        hint: Text(hint),
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(labelBuilder(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRoutineList() {
    if (filteredData.isEmpty) {
      return const Center(
        child: Text(
          'No routine data available for the selected criteria',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final item = filteredData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item['subject'] ?? 'No subject'),
              subtitle: Text('${item['day']} - ${item['time'] ?? 'No time'}'),
              trailing: Text(item['room'] ?? 'No room'),
            ),
          );
        },
      ),
    );
  }
}
