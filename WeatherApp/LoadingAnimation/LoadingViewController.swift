//
//  LoadingViewController.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 13/06/2023.
//

import UIKit

final class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = LoadingView()
    }
}
