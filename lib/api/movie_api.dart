import 'dart:async';

import 'package:flutter_movies/model/movie_model.dart';
import 'network.dart';

class MovieApi {
	final url = "https://api.themoviedb.org/3/";
	final api = "e5f683577a5b165fa19ab4ede9c513f3";
	
	Network _net = new Network();
	
	Future<MovieModel> search(String query) {
		final params = { "api_key": api, "query": query };
		
		return _net.post(url + "search/movie", body: params).then((dynamic res) {
			var results = MovieModel.getList(res["results"]);
			results.status = 200;
			return results;
		});
	}
}
