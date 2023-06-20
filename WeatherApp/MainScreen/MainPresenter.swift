//
//  MainPresenter.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 11/06/2023.
//

import Foundation

final class MainPresenter {
    //MARK: - Properties
    var view: MainViewControllerProtocol?
    var cellForecast: [CellForecast]?
    var isWeekly: Bool?
    var iconsData = [Data?]()
    var group = DispatchGroup()
    
    //MARK: - Constants
    struct Constants {
        static let hourlyForecast = "HOURLY_FORECAST".localized
        static let weeklyForecast = "WEEKLY_FORECAST".localized
    }
    
    //MARK: - Initializer
    init(view: MainViewControllerProtocol?) {
        self.view = view
        LocationManager.shared.delegate = self
    }
    
    //MARK: - Services calls
    func getWeatherData() {
        let apiDataManager = WeatherAPIDataManager()
        apiDataManager.getCurrentWeather { [weak self] (weatherData, _) in
            self?.getForecastData(weather: weatherData)
        }
    }
    
    func getForecastData(weather: CurrentWeather?) {
        let apiDataManager = WeatherAPIDataManager()
        apiDataManager.getForecast { [weak self] (result, _) in
            self?.cellForecast = self?.createForecast(isWeekly: isWeekly, forecast: result)
            guard let cellForecast = self?.cellForecast else { return }
            self?.getIconsFromURL(from: cellForecast, weather: weather)
            self?.group.notify(queue: .main) {
                self?.view?.hideLoadingView()
                self?.view?.setData(weather: weather)
            }
        }
    }
    
    func getIconsFromURL(from forecast: [CellForecast], weather: CurrentWeather?) {
        let apiDataManager = WeatherAPIDataManager()
        for element in forecast {
            group.enter()
            guard let url = URL(string: "http://openweathermap.org/img/wn/\(element.icon)@2x.png") else { return }
            let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                guard let data = data else { return }
                DispatchQueue.main.async {
                        self?.iconsData.append(data)
                        self?.group.leave()
                }
            }
            dataTask.resume()
        }
    }
}

//MARK: - LocationManager Delegate Extension
extension MainPresenter: LocationManagerDelegate {
    func didUpdateLocation() {
        getWeatherData()
    }
}

//MARK: - MainViewDelegate Extension
extension MainPresenter: MainViewDelegate {
    var tabs: [String] {
        return [Constants.hourlyForecast, Constants.weeklyForecast]
    }
    
    var forecastData: [CellForecast] {
        return cellForecast ?? [CellForecast]()
    }
    
    var icons: [Data?] {
        return iconsData
    }
    
    func setWeekly(isWeekly: Bool) {
        self.isWeekly = isWeekly
    }
}

//MARK: - MainPresenterProtocol Extension
extension MainPresenter {
    func createForecast(isWeekly: Bool?, forecast: Forecast?) -> [CellForecast] {
        var cellForecast = [CellForecast]()
        guard let list = forecast?.list,
              let isWeekly = isWeekly else { return cellForecast }
        for element in list {
            if isWeekly {
                let date = element.dtTxt?.components(separatedBy: " ").first ?? ""
                cellForecast.append(CellForecast(title: date,
                                                 icon: element.weather?[0].icon ?? "",
                                                 maxTemp: String(element.main?.tempMax?.rounded() ?? 0),
                                                 minTemp: nil))
            } else {
                let time = element.dtTxt?.components(separatedBy: " ").last ?? ""
                let hour = time.components(separatedBy: ":").first ?? ""
                cellForecast.append(CellForecast(title: hour,
                                                 icon: element.weather?[0].icon ?? "",
                                                 maxTemp: String(element.main?.tempMax?.rounded() ?? 0),
                                                 minTemp: nil))
            }
        }
        return cellForecast
    }
}
