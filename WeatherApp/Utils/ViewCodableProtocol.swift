//
//  ViewCodableProtocol.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 11/06/2023.
//

import UIKit
import SketchKit

protocol ViewCodable {
    func buildViewHierarchy()
    func setupConstraints()
    func configureView()
    func setupTouchEvents()
}

extension ViewCodable {
    func setupView() {
        self.buildViewHierarchy()
        self.setupConstraints()
        self.configureView()
        self.setupTouchEvents()
    }
}
