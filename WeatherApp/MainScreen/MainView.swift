//
//  MainView.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 10/06/2023.
//

import UIKit

protocol MainViewDelegate {
    var forecastData: [CellForecast] { get }
    var tabs: [String] { get }
    var icons: [Data?] { get }
    func setWeekly(isWeekly: Bool)
}

protocol MainViewProtocol {
    func setData(weather: CurrentWeather?)
}

final class MainView: UIView {
    var delegate: MainViewDelegate?
    var firstTime = true
    
    //MARK: - UI Components
    private lazy var city: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var temperature: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 60, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var weather: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var minTemp: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var maxTemp: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var minMaxView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private lazy var bottomView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var completeView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    private lazy var hourlyWeeklyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor(red: 72/255, green: 49/255, blue: 157/255, alpha: 0.2)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(HourlyWeeklyCell.self, forCellWithReuseIdentifier: "HourlyWeeklyCell")
        return collection
    }()
    
    private lazy var detailsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor(red: 72/255, green: 49/255, blue: 157/255, alpha: 0.2)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(DetailCell.self, forCellWithReuseIdentifier: "DetailCell")
        return collection
    }()
    
    //MARK: - Initializers
    init(delegate: MainViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ViewCodable Extension
extension MainView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews([background,
                     completeView,
                     hourlyWeeklyCollectionView,
                     detailsCollectionView])
        completeView.addArrangedSubviews([city,
                                          temperature,
                                          bottomView])
        bottomView.addArrangedSubviews([weather,
                                       minMaxView])
        minMaxView.addArrangedSubviews([minTemp,
                                       maxTemp])
    }
    
    func setupConstraints() {
        background.layout.applyConstraint { (view) in
            view.topAnchor(equalTo: topAnchor)
            view.leadingAnchor(equalTo: leadingAnchor)
            view.trailingAnchor(equalTo: trailingAnchor)
            view.bottomAnchor(equalTo: bottomAnchor)
        }
        
        completeView.layout.applyConstraint { (view) in
            view.topAnchor(equalTo: safeTopAnchor, constant: 51)
            view.centerXAnchor(equalTo: safeCenterXAnchor)
            view.widthAnchor(equalTo: safeWidthAnchor, multiplier: 0.29)
        }
        
        bottomView.layout.applyConstraint { (view) in
            view.widthAnchor(equalTo: completeView.widthAnchor)
        }
        
        minMaxView.layout.applyConstraint { (view) in
            view.widthAnchor(equalTo: completeView.widthAnchor)
        }
        
        hourlyWeeklyCollectionView.layout.applyConstraint { (view) in
            view.topAnchor(equalTo: completeView.bottomAnchor, constant: 230)
            view.widthAnchor(equalTo: widthAnchor)
            view.heightAnchor(equalTo: heightAnchor, multiplier: 0.06)
        }
        
        detailsCollectionView.layout.applyConstraint { (view) in
            view.topAnchor(equalTo: hourlyWeeklyCollectionView.bottomAnchor)
            view.widthAnchor(equalTo: safeWidthAnchor)
            view.bottomAnchor(equalTo: safeBottomAnchor)
        }
    }
    
    func configureView() {
        
    }
    
    func setupTouchEvents() {
    }
}

extension MainView {
    func setGradientBackground() {
        let colorTop =  UIColor(red: 46, green: 51, blue: 90, alpha: 1).cgColor
        let colorBottom = UIColor(red: 28, green: 27, blue: 51, alpha: 1).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
                
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK: - MainViewProtocol Extension
extension MainView: MainViewProtocol {
    func setData(weather: CurrentWeather?) {
        guard let weather = weather else { return }
        hourlyWeeklyCollectionView.reloadData()
        detailsCollectionView.reloadData()
        loadData(weatherData: weather)
    }
    
    func loadData(weatherData: CurrentWeather) {
        guard let dataW = weatherData.weather, dataW.count > 0 else { return }
        city.text = weatherData.name
        temperature.text = String(Int(weatherData.main?.temp?.rounded() ?? 0)) + "°"
        weather.text = dataW[0].main
        minTemp.text = "Mín: \(Int(weatherData.main?.tempMin ?? 0))°"
        maxTemp.text = "Máx: \(Int(weatherData.main?.tempMax ?? 0))°"
    }
}

//MARK: - UICollectionView Data Source Extension
extension MainView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyWeeklyCollectionView {
            return delegate?.tabs.count ?? 0
        }
        return delegate?.forecastData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyWeeklyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeeklyCell", for: indexPath)
            guard let cellCollection = cell as? HourlyWeeklyCell,
                  let delegate = delegate else { return UICollectionViewCell() }
            cellCollection.configureCell(title: delegate.tabs[indexPath.row])
            if indexPath.row == 0 && firstTime {
                cellCollection.selectItem()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath)
            guard let cellCollection = cell as? DetailCell,
                  let delegate = delegate,
                  delegate.icons.count > 0 else { return UICollectionViewCell() }
            cellCollection.applyShadow(cornerRadius: 8)
            cellCollection.isUserInteractionEnabled = false
            cellCollection.configureCell(data: delegate.forecastData[indexPath.row],
                                         iconData: delegate.icons[indexPath.row] ?? Data())
            return cell
        }
    }
}

//MARK: - UICollectionView Delegate Extension
extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == hourlyWeeklyCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? HourlyWeeklyCell else { return }
            cell.selectItem()
            if indexPath.row == 0 {
                delegate?.setWeekly(isWeekly: false)
                detailsCollectionView.reloadData()
            } else {
                if firstTime {
                    firstTime = false
                    let index = IndexPath(row: 0, section: 0)
                    guard let cell = collectionView.cellForItem(at: index) as? HourlyWeeklyCell else { return }
                    cell.deselectItem()
                }
                delegate?.setWeekly(isWeekly: true)
                detailsCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == hourlyWeeklyCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? HourlyWeeklyCell else { return }
            cell.deselectItem()
        }
    }
}

//MARK: - UICollectionViewFlowLayoutDelegate Extension
extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        if collectionView == hourlyWeeklyCollectionView {
            return CGSize(width: collectionView.frame.size.width / 2, height: 0.06 * height)
        }
        return CGSize(width: 0.15 * width, height: 0.17 * height)
    }
}
