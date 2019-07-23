class Movie extends Object {
	int id;
	String title;
	String original_title;
	String original_language;
	String poster_path;
	String overview;
	String release_date;
	
	Movie({ this.id, this.title, this.original_title, this.original_language, this.poster_path, this.overview, this.release_date });
	
	factory Movie.fromJson(Map<String, dynamic> json) {
		return Movie(
			id: json['id'] as int,
			title: json['title'] as String,
			original_title: json['original_title'] as String,
			original_language: json['original_language'] as String,
			poster_path: json['poster_path'] as String,
			overview: json['overview'] as String,
			release_date: json['release_date'] as String,
		);
	}
}
