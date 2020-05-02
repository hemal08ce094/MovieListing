//
//  NetworkAccess.swift
//  MoviesApp
//
//  Created by Hemal on 02/05/20.
//  Copyright © 2020 Hemal. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case cancel(Error?)
    case failure(Error?)
}

public class NetworkAccess {
    
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    public enum QueryType {
        case json, path
    }
    
    static func fetchData<T: Requestable>(req: T,completionHandler: @escaping (NetworkResult<T.ResponseType>) -> Void) {
        let url = req.baseUrl.appendingPathComponent(req.endpoint)
        let request = prepareRequest(for: url, req: req)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let err = error {
                
                if let urlError = error as? URLError, urlError.code == URLError.cancelled {
                    // cancelled
                    completionHandler(NetworkResult.cancel(urlError))
                } else {
                    // other failures
                    completionHandler(NetworkResult.failure(err))
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                DispatchQueue.main.async {
                    do {
                        let object = try decoder.decode(T.ResponseType.self, from: data)
                        completionHandler(NetworkResult.success(object))
                    } catch let error {
                        completionHandler(NetworkResult.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    private static func prepareRequest<T: Requestable>(for url: URL, req: T) -> URLRequest {
        
        var request : URLRequest? = nil
        
        switch req.query {
        case .json:
            request = URLRequest(url: url, cachePolicy: req.cachePolicy,
                                 timeoutInterval: req.timeout)
            if let params = req.parameters {
                do {
                    let body = try JSONSerialization.data(withJSONObject: params, options: [])
                    request!.httpBody = body
                } catch {
                    assertionFailure("Error : while attemping to serialize the data for preparing httpBody \(error)")
                }
            }
        case .path:
            var query = ""
            
            req.parameters?.forEach { key, value in
                query = query + "\(key)=\(value)&"
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = query
            request = URLRequest(url: components.url!, cachePolicy: req.cachePolicy, timeoutInterval: req.timeout)
        }
        
        request!.allHTTPHeaderFields = req.headers
        request!.httpMethod = req.method.rawValue
        
        return request!
    }
}
