import 'package:pa_prak_mobile/load_data_source.dart';
import 'package:pa_prak_mobile/page_detail_komik.dart';
import 'package:pa_prak_mobile/search_result_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageListSearchResult extends StatefulWidget {
  final String text;
  const PageListSearchResult({Key? key, required this.text}) : super(key: key);
  @override
  State<PageListSearchResult> createState() => _PageListSearchResultState();
}

class _PageListSearchResultState extends State<PageListSearchResult> {
  bool _isLoading = false;
  bool _isDarkTheme = false;
  //
  var appBarColor = Colors.deepPurpleAccent;
  var titleColor = Colors.black;
  var cardColor = Colors.white30;


  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      appBarColor = _isDarkTheme ? Colors.deepPurpleAccent : Colors.deepPurpleAccent;
      titleColor = _isDarkTheme ? Colors.white : Colors.black;
      cardColor = _isDarkTheme ? Colors.black : Colors.white30;
    });
  }

  Future<void> _saveTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.text, style: TextStyle(color: titleColor),),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: titleColor,),
        centerTitle: true,
        actions: [
          Switch(
            value: _isDarkTheme,
            onChanged: (value) {
              setState(() {
                _isDarkTheme = value;
                appBarColor = _isDarkTheme ? Colors.deepPurpleAccent : Colors.deepPurpleAccent;
                titleColor = _isDarkTheme ? Colors.white : Colors.black;
                cardColor = _isDarkTheme ? Colors.black : Colors.white30;
                _saveTheme(_isDarkTheme);
              });
            },
            activeColor: Colors.white,
          ),
        ],
      ),
      //body: Text("TEst"),
      body: _isLoading ? _buildLoadingSection() : _buildListSearchResult(),
    );
  }

  Widget _buildListSearchResult() {
    return Container(
      child: FutureBuilder(
        future: ApiDataSource.instance.loadSearchResult(widget.text),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            SearchResultListModel searchResultListModel =
            SearchResultListModel.fromJson(snapshot.data);
            if (searchResultListModel.data!.length == 0){
              return Center(
                child: Text("Hasil tidak ditemukan"),
              );
            }
            else{
              return _buildSuccessSection(searchResultListModel);
            }
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(SearchResultListModel data) {
    return ListView.builder(
      itemCount: data.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemSearchResult(data.data![index]);
      },
    );
  }

  Widget _buildItemSearchResult(Data result) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PageDetailKomik(
                  idKomik: result.id!,
                )));
      },
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                child: result.thumb != null
                    ? Image.network(result.thumb!)
                    : Placeholder(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: titleColor),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Chapter: ${result.totalChapter!.toString()}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: titleColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}