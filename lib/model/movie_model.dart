import 'movie.dart';

class MovieModel {
	int status;
	List<Movie> list;
	
	MovieModel.getList(dynamic obj) {
		list = obj.map<Movie>((json) => Movie.fromJson(json)).toList();
	}
}
