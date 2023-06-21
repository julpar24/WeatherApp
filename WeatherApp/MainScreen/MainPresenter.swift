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
    var forecastInfo: Forecast?
    var isWeekly = false
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
            self?.forecastInfo = result
            guard let isWeekly = self?.isWeekly else { return }
            if isWeekly {
                self?.cellForecast = self?.createWeeklyForecast(forecast: result)
            } else {
                self?.cellForecast = self?.createHourlyForecast(forecast: result)
            }
            guard let cellForecast = self?.cellForecast else { return }
            self?.getIconsFromURL(from: cellForecast)
            self?.group.notify(queue: .main) {
                self?.view?.hideLoadingView()
                self?.view?.setData(weather: weather)
            }
        }
    }
    
    func getIconsFromURL(from forecast: [CellForecast]) {
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
    
    var weekly: Bool {
        return isWeekly
    }
    
    func reloadData(isWeekly: Bool) {
        self.isWeekly = isWeekly
        if isWeekly {
            cellForecast = createWeeklyForecast(forecast: forecastInfo)
        } else {
            cellForecast = createHourlyForecast(forecast: forecastInfo)
        }
        
        guard let cellForecast = cellForecast else { return }
        getIconsFromURL(from: cellForecast)
        group.notify(queue: .main) {
            self.view?.reloadData()
        }
    }
    
    func getWeekDay(dt: Int?) -> String {
        let date = Date(timeIntervalSince1970: Double(dt ?? 0))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).capitalized
    }
}

//MARK: - MainPresenterProtocol Extension
extension MainPresenter {
    func createWeeklyForecast(forecast: Forecast?) -> [CellForecast] {
        var cellForecast = [CellForecast]()
        guard let list = forecast?.list else { return cellForecast }
        for element in list {
            let weekDay = getWeekDay(dt: element.dt)
            cellForecast.append(CellForecast(title: String(weekDay.prefix(3)),
                                             icon: element.weather?[0].icon ?? "",
                                             maxTemp: Int(element.main?.tempMax?.rounded() ?? 0),
                                             minTemp: Int(element.main?.tempMin?.rounded() ?? 0),
                                             order: nil))
        }
        cellForecast = getMinMaxTemperatures(for: cellForecast)
        return cellForecast
    }
    
    func createHourlyForecast(forecast: Forecast?) -> [CellForecast] {
        var cellForecast = [CellForecast]()
        guard let list = forecast?.list else { return cellForecast }
        for element in list {
            let time = element.dtTxt?.components(separatedBy: " ").last ?? ""
            let hour = time.components(separatedBy: ":").first ?? ""
            cellForecast.append(CellForecast(title: hour,
                                             icon: element.weather?[0].icon ?? "",
                                             maxTemp: Int(element.main?.temp?.rounded() ?? 0),
                                             minTemp: Int(element.main?.tempMin?.rounded() ?? 0),
                                             order: nil))
        }
        return Array(cellForecast.prefix(8))
    }
    
    func getMinMaxTemperatures(for forecasts: [CellForecast]) -> [CellForecast] {
        var temperatureDictionary = [String: CellForecast]()
        var order = 0
        for forecast in forecasts {
            if let cellForecast = temperatureDictionary[forecast.title] {
                let newMin = min(cellForecast.minTemp, forecast.minTemp)
                let newMax = max(cellForecast.maxTemp, forecast.maxTemp)
                temperatureDictionary[forecast.title] = CellForecast(title: forecast.title,
                                                                     icon: forecast.icon,
                                                                     maxTemp: newMax,
                                                                     minTemp: newMin,
                                                                     order: order)
            } else {
                
                temperatureDictionary[forecast.title] = CellForecast(title: forecast.title,
                                                                     icon: forecast.icon,
                                                                     maxTemp: forecast.maxTemp,
                                                                     minTemp: forecast.minTemp,
                                                                     order: order)
                order += 1
            }
        }
        
        var result = [CellForecast]()
        for (day, forecast) in temperatureDictionary {
            let forecast = CellForecast(title: day,
                                        icon: forecast.icon,
                                        maxTemp: forecast.maxTemp,
                                        minTemp: forecast.minTemp,
                                        order: forecast.order)
            result.append(forecast)
        }
        result = result.sorted { $0.order ?? 0 < $1.order ?? 0}
        return result
    }
}
