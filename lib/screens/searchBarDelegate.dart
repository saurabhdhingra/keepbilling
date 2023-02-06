import 'package:flutter/material.dart';
import 'package:keepbilling/widgets/infoPages/customExpansionTile.dart';
import '../../utils/constants.dart';

class SearchBar extends SearchDelegate<String> {
  final List searchList;

  final Map properties;

  SearchBar(this.searchList, this.properties);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: const Icon(Icons.chevron_left, color: Colors.black, size: 35));
  }

  @override
  Widget buildResults(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    List<Map> matchQuery = [];
    for (var item in searchList) {
      if (item["${properties["title"]}"]
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0),
          child: Theme(
            data: theme,
            child: CustomExpansionTile(
             
              data: result,
              properties: properties,
            ),
          ),
        );
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map> matchQuery = [];

    for (var item in searchList) {
      if (item["${properties["title"]}"]
          .toLowerCase()
          .contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index]["${properties["title"]}"];
        return ListTile(
          title: Text(result),
        );
      },
      itemCount: matchQuery.length,
    );
  }

  Widget description(String text, double width, double height) {
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
      child: Text(
        text,
        style: TextStyle(fontSize: height * 0.015, color: Colors.black87),
      ),
    );
  }
}
