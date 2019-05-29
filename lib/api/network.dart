import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
	factory Network() => Network.internal();
	
	Network.internal();
	
	final JsonDecoder _decoder = new JsonDecoder();
	
	Future<dynamic> get(String url, {Map<String, String> headers, encoding}) {
		return http.get(url, headers: headers).then((http.Response response) {
			String res = response.body;
			int status_code = response.statusCode;
			
			print("API Response : " + res);
			
			if (status_code < 200 || status_code > 400 || json == null) {
				res = "{\"status\":" + status_code.toString() + ",\"message\":\"error\",\"response\":" + res + "}";
				
				throw new Exception(status_code);
			}
			
			return _decoder.convert(res);
		});
	}
	
	Future<dynamic> post(String url, {Map<String, String> headers, body, encoding}) {
		return http.post(url, body: body, headers: headers, encoding: encoding).then((http.Response response) {
			String res = response.body;
			int status_code = response.statusCode;
			
			print("API Response : " + res);
			
			if (status_code < 200 || status_code > 400 || json == null) {
				res = "{\"status\":" + status_code.toString() + ",\"message\":\"error\",\"response\":" + res + "}";
				
				throw new Exception( status_code);
			}
			
			return _decoder.convert(res);
		});
	}
}
