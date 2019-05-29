class Movie extends Object {
	int id;
	String title;
	String original_title;
	String poster_path;
	
	Movie({ this.id, this.title, this.original_title, this.poster_path, });
	
	factory Movie.fromJson(Map<String, dynamic> json) {
		return Movie(
			id: json['id'] as int,
			title: json['title'] as String,
			original_title: json['original_title'] as String,
			poster_path: json['poster_path'] as String,
		);
	}
}
