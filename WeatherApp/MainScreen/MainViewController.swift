//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 09/06/2023.
//

import UIKit

protocol MainViewControllerProtocol {
    func hideLoadingView()
    func setData(weather: CurrentWeather?)
    func reloadData()
}

final class MainViewController: UIViewController, HasCustomView {
    var presenter: MainPresenter?
    typealias CustomView = MainViewProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        LocationManager.shared.start()
    }

    override func loadView() {
        guard let presenter = presenter else { return }
        view = MainView(delegate: presenter)
    }
    
    func showLoadingView() {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: nil)
    }
}

extension MainViewController: MainViewControllerProtocol {
    func hideLoadingView() {
        dismiss(animated: true)
    }
    
    func setData(weather: CurrentWeather?) {
        customView.setData(weather: weather)
    }
    
    func reloadData() {
        customView.reloadData()
    }
}
