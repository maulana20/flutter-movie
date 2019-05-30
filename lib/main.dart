import 'package:flutter/material.dart';

import 'screen/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'MOVIE',
			home: HomeScreen(),
		);
	}
}
