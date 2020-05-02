//
//  MovieDetailRequest.swift
//  MoviesApp
//
//  Created by Hemal on 02/05/20.
//  Copyright © 2020 Hemal. All rights reserved.
//

import Foundation

final class MovieDetailRequest: Requestable {

    typealias ResponseType = MovieDetailResponse
    
    private var movieID :String
    
    init(movieID:String) {
        self.movieID = movieID
    }
    
    var baseUrl: URL {
        return URL(string: "https://api.themoviedb.org/")!
    }
    
    var endpoint: String {
        return "3/movie/\(self.movieID)"
    }
    
    var method: NetworkAccess.Method {
        return .get
    }
    
    var query: NetworkAccess.QueryType {
        return .path
    }
    
    var parameters: [String : Any]? {
        return ["api_key" : "2cf28df74f7463ce7ef6ffd4dca51713","language":"en-US"]
    }
    
    var headers: [String : String]? {
        return defaultJSONHeader
    }
    
    var timeout: TimeInterval {
        return 30.0
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
}
