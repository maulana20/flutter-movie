import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../model/movie.dart';

class MovieDetailScreen extends StatelessWidget {
	MovieDetailScreen({ this.file });
	
	final Movie file;
	
	@override
	Widget build(BuildContext context) {
		Widget titleSection = Container(
			padding: EdgeInsets.all(10.0),
			child: Column(
				children: [
					Row(children: [Text(file.original_title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0))]),
					SizedBox(height: 5.0),
					Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.calendar_today, size: 12.0), SizedBox(width: 2.0), Text(file.release_date, style: TextStyle(fontSize: 12.0))]), Text(file.original_language.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0))]),
				],
			),
		);
		
		Widget textSection = Container(
			padding: EdgeInsets.all(10.0),
			child: Column(
				children: [
					Row(children: [Text('description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0))]),
					SizedBox(height: 5.0),
					Text(file.overview, style: TextStyle(fontSize: 12.0)),
				],
			),
		);
		
		return MaterialApp(
			title: file.title,
			home: Scaffold(
				appBar: AppBar(
					leading: IconButton(
						icon: Icon(Icons.arrow_back),
						onPressed: () => Navigator.pop(context),
					),
					title: Text(file.title),
				),
				body: ListView(
					children: [
						SizedBox(height: 10.0),
						FadeInImage.memoryNetwork(
							placeholder: kTransparentImage,
							image: file.title == null ? file.poster_path : "https://image.tmdb.org/t/p/w500" + file.poster_path,
							height: 400,
						),
						titleSection,
						textSection,
					],
				),
			),
		);
	}
}
