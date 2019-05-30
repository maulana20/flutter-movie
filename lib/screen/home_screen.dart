import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/movie.dart';
import '../api/movie_api.dart';

class HomeScreen extends StatefulWidget {
	const HomeScreen();
	
	@override
	_HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	final String title = 'MOVIE';
	
	bool _searching = false;
	final inputController = TextEditingController();
	
	MovieApi _movieApi;
	List<Movie> files = new List();
	
	@override
	void initState() {
		super.initState();
		_movieApi = MovieApi();
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				leading: _searching ? const BackButton() : MenuButton(),
				title: _searching ? BuildSearch() : Text(title),
				actions: _searching ? CloseButton() : SearchButton(),
			),
			body: _searching ? GridCard() : Center(child: Text('Lakukan pencarian berdasarkan nama film')),
		);
	}
	
	// BUTTON LIST
	
	Widget MenuButton() {
		return IconButton(
			icon: Icon( Icons.menu, semanticLabel: 'menu'),
			onPressed: () {
				print('Menu button');
			},
		);
	}
	
	List<Widget> SearchButton() {
		return <Widget>[
			IconButton(
				icon: Icon(Icons.search, color: Colors.white),
				onPressed: () {
					print('Search button');
					
					setState(() {
						_searching = true;
					});
				},
			),
		];
	}
	
	List<Widget> CloseButton() {
		return <Widget>[
			IconButton(
				icon: Icon(Icons.clear, color: Colors.white,),
				onPressed: () {
					print('Close Button');
					
					setState(() {
						_searching = false;
						
						inputController.clear();
						
						_buildSearch('search query');
					});
					
				},
			),
		];
	}
	
	// ON BUILD PROCCESS
	
	Widget BuildSearch() {
		return TextField(
			controller: inputController,
			autofocus: true,
			decoration: InputDecoration(
				hintText: 'Masukan nama film',
				border: InputBorder.none,
				hintStyle: TextStyle(color: Colors.white),
			),
			style: TextStyle(color: Colors.white, fontSize: 16.0),
			onChanged: _buildSearch,
		);
	}
	
	Future _buildSearch(String text) async {
		if (text.length > 2) {
			print("Input Search : " + text);
			
			var search = await _movieApi.search(text);
			setState(() {
				files.clear();
				files.addAll(search.list);
			});
		}
	}
	
	Widget GridCard() {
		return GridView.count(
			primary: true,
			crossAxisCount: 2,
			childAspectRatio: 0.80,
			children: List.generate(files.length, (index) {
				if (files[index].poster_path != null) {
					return _gridCard(files[index].poster_path, files[index].title);
				} else {
					return _gridCard("https://dummyimage.com/300/09f.png/fff", null);
				}
			}),
		);
	}
	
	Card _gridCard(String file, String title) {
		return Card(
			child: Stack(
				children: <Widget>[
					Center(child: CircularProgressIndicator()),
					Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: <Widget>[
							AspectRatio(
								aspectRatio: 16.0 / 16.0,
								child: FadeInImage.memoryNetwork(
									placeholder: kTransparentImage,
									image: "https://image.tmdb.org/t/p/w500" + file,
								),
							),
							Expanded(
								child: Padding(
									padding: EdgeInsets.fromLTRB(14.0, 8.0, 8.0, 8.0),
									child: Column(
										mainAxisAlignment: MainAxisAlignment.end,
										crossAxisAlignment: CrossAxisAlignment.center,
										children: <Widget>[
											Text(title, style: TextStyle(fontSize: 11.0)),
										],
									),
								),
							),
						],
					),
				],
			),
		);
	}
}
