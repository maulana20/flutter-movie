import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'model/movie.dart';
import 'api/movie_api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			theme: ThemeData(
				primaryColor: const Color(0xFF02BB9F),
				primaryColorDark: const Color(0xFF167F67),
				accentColor: const Color(0xFFFFAD32),
			),
			home: MainPage(),
		);
	}
}

class MainPage extends StatefulWidget {
	const MainPage();
	
	@override
	_MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
	static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
	
	MovieApi _movieApi;
	TextEditingController _searchQuery;
	bool _isSearching = false;
	String searchQuery = "Search query";
	List<Movie> files = new List();
	
	@override
	void initState() {
		super.initState();
		_movieApi = MovieApi();
		_searchQuery = TextEditingController();
	}
	
	void _startSearch() {
		print("open search box");
		ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
		setState(() {
			_isSearching = true;
		});
	}
	
	void _stopSearching() {
		_clearSearchQuery();
		setState(() {
			_isSearching = false;
		});
	}
	
	void _clearSearchQuery() {
		print("close search box");
		setState(() {
			_searchQuery.clear();
			updateSearchQuery("Search query");
		});
	}
	
	Widget _buildTitle(BuildContext context) {
		var horizontalTitleAlignment = Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;
		
		return new InkWell(
			onTap: () => scaffoldKey.currentState.openDrawer(),
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 12.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: horizontalTitleAlignment,
					children: <Widget>[
						Text('Seach box',style: new TextStyle(color: Colors.white),),
					],
				),
			),
		);
	}
	
	Widget _buildSearchField() {
		return TextField(
			controller: _searchQuery,
			autofocus: true,
			decoration: InputDecoration(
				hintText: 'Search...',
				border: InputBorder.none,
				hintStyle: TextStyle(color: Colors.white),
			),
			style: TextStyle(color: Colors.white, fontSize: 16.0),
			onChanged: updateSearchQuery,
		);
	}
	
	Future updateSearchQuery(String newQuery) async {
		setState(() {
			searchQuery = newQuery;
		});
		
		print("search query " + newQuery);
		
		if (newQuery.length > 2) {
			var search = await _movieApi.search(newQuery);
			setState(() {
				files.clear();
				files.addAll(search.list);
			});
		}
	}
	
	List<Widget> _buildActions() {
		if (_isSearching) {
			return <Widget>[
				IconButton(
					icon: Icon(Icons.clear,color: Colors.white,),
					onPressed: () {
						if (_searchQuery == null || _searchQuery.text.isEmpty) {
							Navigator.pop(context);
							return;
						}
						_clearSearchQuery();
					},
				),
			];
		}
		
		return <Widget>[
			IconButton(
				icon: Icon(Icons.search,color: Colors.white,),
				onPressed: _startSearch,
			),
		];
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			key: scaffoldKey,
			appBar: AppBar(
				leading: _isSearching ? const BackButton() : null,
				title: _isSearching ? _buildSearchField() : _buildTitle(context),
				actions: _buildActions(),
			),
			body: GridView.count(
				primary: true,
				crossAxisCount: 2,
				childAspectRatio: 0.80,
				children: List.generate(files.length, (index) {
					if (files[index].poster_path != null) {
						return getStructuredGridCell(files[index].poster_path);
					} else {
						return getStructuredGridCell("https://dummyimage.com/300/09f.png/fff");
					}
				}),
			),
		);
	}
	
	Card getStructuredGridCell(String file) {
		return Card(
			child: Stack(
				children: <Widget>[
					Center(child: CircularProgressIndicator()),
					Center(
						child: FadeInImage.memoryNetwork(
							placeholder: kTransparentImage,
							image: "https://image.tmdb.org/t/p/w500"+file,
						),
					),
				],
			),
		);
	}
}
