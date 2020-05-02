//
//  Requestable.swift
//  MoviesApp
//
//  Created by Hemal on 02/05/20.
//  Copyright © 2020 Hemal. All rights reserved.
//

import Foundation

public protocol Requestable {
    
    associatedtype ResponseType: Codable
    
    var endpoint: String { get }
    var method: NetworkAccess.Method { get }
    var query:  NetworkAccess.QueryType { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var baseUrl: URL { get }
    
    var timeout : TimeInterval { get }
    var cachePolicy : NSURLRequest.CachePolicy { get }
}

public extension Requestable {
    
    var defaultJSONHeader : [String: String] {
        return ["Content-Type": "application/json"]
    }
}
