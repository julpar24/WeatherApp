//
//  WeatherAPIDataManager.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 12/06/2023.
//

import Foundation
import Alamofire

class WeatherAPIDataManager {
    // MARK: - Properties
    var network: NetworkingProtocol = Networking(apiManager: APIManager())
    
    // MARK: - Methods
    func getCurrentWeather(completion: @escaping (CurrentWeather?, AFError?) -> Void) {
        network.execute(Endpoint.currentWeather, parameters: nil, completion: completion)
    }
    
    func getForecast(completion: @escaping (Forecast?, AFError?) -> Void) {
        network.execute(Endpoint.fiveDayForecast, parameters: nil, completion: completion)
    }
}
