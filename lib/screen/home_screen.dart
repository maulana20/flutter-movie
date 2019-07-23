import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'movie/movie_detail_screen.dart';

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
	
	Widget MenuButton() {
		return IconButton(
			icon: Icon( Icons.menu, semanticLabel: 'menu'),
			onPressed: () {
				print('Menu button');
			},
		);
	}
	
	// BUTTON LIST
	
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
					print(files[index].title + '@' + files[index].original_title + '@' + files[index].poster_path);
					return _gridCard(files[index]);
				} else {
					files[index].poster_path = "https://dummyimage.com/300/09f.png/fff";
					files[index].title = null;
					return _gridCard(files[index]);
				}
			}),
		);
	}
	
	Card _gridCard(Movie file) {
		return Card(
			child: GestureDetector(
				onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(file: file))),
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
										image: file.title == null ? file.poster_path : "https://image.tmdb.org/t/p/w500" + file.poster_path,
									),
								),
								Padding(
									padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
									child: Column(
										mainAxisAlignment: MainAxisAlignment.end,
										crossAxisAlignment: CrossAxisAlignment.center,
										children: <Widget>[
											Row(children: [Text(file.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0))]),
											SizedBox(height: 1.0),
											Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.calendar_today, size: 8.0), Text(' '), Text(file.release_date, style: TextStyle(fontSize: 8.0))]), Text(file.original_language.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.0))] ),
										],
									),
								),
							],
						),
					],
				),
			),
		);
	}
}
