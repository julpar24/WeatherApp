//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 12/06/2023.
//

import Foundation
import Alamofire

// MARK: - Endpoint Network Protocol
protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
}

// MARK: - Endpoints

enum Endpoint {
    case currentWeather
    case fiveDayForecast
}

// MARK: - EndPointType Extension
extension Endpoint: EndPointType {
    var latitude: Double {
        return LocationManager.shared.location?.latitude ?? 0
    }
    
    var longitude: Double {
        return LocationManager.shared.location?.longitude ?? 0
    }
    
    var baseURL: String {
        switch self {
        case .currentWeather: return "https://api.openweathermap.org/data/2.5/weather"
        case .fiveDayForecast: return "https://api.openweathermap.org/data/2.5/forecast"
        }
    }
    
    var path: String {
        return "?appid=97d1ee13c6bb589e62d7c37120a7a187&units=metric"
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var url: URL {
        switch self {
        case .fiveDayForecast, .currentWeather:
            guard let url = URL(string: baseURL + path + "&lon=\(longitude)&lat=\(latitude)") else { preconditionFailure("Invalid URL") }
            return url
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
}
