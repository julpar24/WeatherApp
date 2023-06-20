//
//  APIManager.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 12/06/2023.
//

import Foundation
import Alamofire

final class APIManager {
  
  static let sessionManager: Session = {
    
    let configuration = URLSessionConfiguration.af.default
    
    configuration.timeoutIntervalForRequest = 30
    
    return Session(configuration: configuration)
  }()
  
}

// MARK: - API MANAGER EXTENSION
extension APIManager {
    func getRequest(type: Endpoint, parameters: Parameters?) -> DataRequest {
        return APIManager.sessionManager.request(type.url,
                                                 method: type.httpMethod,
                                                 parameters: parameters,
                                                 encoding: type.encoding).validate()
    }
}
