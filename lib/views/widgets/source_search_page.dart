import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../services/sources/base.dart';
import '../../services/sources/gogoanime.dart';
import '../../services/sources/index.dart';
import 'search_bar.dart';
import 'taiyaki_size.dart';
import 'tiles.dart';

class SourceSearchPage extends StatefulWidget {
  final String query;
  final Function(Map<String, String>) onLink;

  const SourceSearchPage({Key? key, required this.query, required this.onLink}) : super(key: key);

  @override
  _SourceSearchPageState createState() => _SourceSearchPageState();
}

class _SourceSearchPageState extends State<SourceSearchPage> {
  SourceBase _currentSource = GogoAnime();
  bool isLoading = false;
  List<SourceSearchResultsModel> results = [];

  @override
  void initState() {
    super.initState();
    _search(widget.query);
  }

  @override
  void dispose() {
    _currentSource.dispose();
    super.dispose();
  }

  Future _search(String query) async {
    setState(() => isLoading = true);

    try {
      final _results = await _currentSource.getSearchResults(query);
      setState(() {
        isLoading = false;
        results = _results;
      });
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
      children: [
        SearchBar(
            isLoading: isLoading,
            placeholder: 'Enter a custom query',
            onDelayedEnter: (String query) {
              setState(() => results = []);
              _search(query);
            },
            onEnter: (_) {}),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (results.isEmpty)
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                Icon(Icons.inbox, size: 75),
                Text('No results found', style: TextStyle(fontSize: 20)),
              ]))
        else
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return Scaffold(
                                body: Column(
                                  children: [
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text('Select a source',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16)),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: kTaiyakiSources.length,
                                    itemBuilder: (context, index) =>
                                        SourceTiles(
                                            onTap: () {
                                              final _newSource =
                                                  kTaiyakiSources[
                                                      index];
                                              setState(() =>
                                                  _currentSource =
                                                      _newSource);
                                            },
                                            name: kTaiyakiSources[index]
                                                .name),
                                  ),
                                ),
                                  ],
                                ),
                              );
                            });
                      },
                      child:
                          Text('Current Source: ${_currentSource.name}')),
                ),
                SizedBox(
                    height: TaiyakiSize.height * 0.85,
                    child: ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: (BuildContext context, int index) {
                          final _result = results[index];
                          return Tiles(
                            image: _result.image,
                            title: _result.title,
                            onTap: () {
                              final _link = _result.link;
                              widget.onLink({_link: _currentSource.name});
                            },
                          );
                        }))
              ])
      ],
        ),
      ),
    );
  }
}
