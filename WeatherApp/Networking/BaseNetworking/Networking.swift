//
//  Networking.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 12/06/2023.
//

import Foundation
import Alamofire

protocol NetworkingProtocol {
  func execute<T: Decodable>(_ endpoint: Endpoint, parameters: Parameters?, completion: @escaping (_ data: T?, _ error: AFError?) -> Void)
}

class Networking {
  
  let apiManager: APIManager
  
  init(apiManager: APIManager) {
    self.apiManager = apiManager
  }
}

extension Networking: NetworkingProtocol {
  func execute<T>(_ endpoint: Endpoint, parameters: Parameters? = nil, completion: @escaping (T?, AFError?) -> Void) where T: Decodable {
    apiManager.getRequest(type: endpoint, parameters: parameters).validate().responseDecodable(of: T.self) { (dataResponse: AFDataResponse<T>) in
      switch dataResponse.result {
      case .success:
        completion(dataResponse.value, nil)
      case .failure(let error):
        completion(nil, error)
      }
    }
  }
}
