//
//  NYTimesApi.swift
//  NYTimes
//
//  Created by Arturo Jamaica Garcia on 06/04/17.
//  Copyright © 2017 Arturo Jamaica. All rights reserved.
//

import Foundation
import Moya

let NY_API_KEY = "28fed6d7f29348f984a91bbbfe14eada"


public enum NYTimes {
    case articlesearch(String)
    case mostviewed(String,String)
    
}

extension NYTimes: TargetType {
    public var baseURL: URL { return URL(string: "https://api.nytimes.com/svc")! }
    
    public var path: String {
        switch self {
        case .mostviewed(let section,let date):
            return "/mostpopular/v2/mostviewed/\(section)/\(date).json"
        case .articlesearch(let q):
            return "/search/v2/articlesearch.json"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameters: [String: Any]? {
        var param = ["api-key" : NY_API_KEY]
        switch self {
        case .articlesearch(let q):
            param["q"] = q
            break
        case .mostviewed(_,_):
            break
        default:
            break
            
        }
        return param
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .request
    }
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    public var sampleData: Data {
        
        switch self {
        case .articlesearch:
            return "".data(using: String.Encoding.utf8)!
        case .mostviewed(_,_):
            return "".data(using: String.Encoding.utf8)!
        }
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

//MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

let NYTimesProvider = MoyaProvider<NYTimes>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
