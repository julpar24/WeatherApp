//
//  UIStackView+AddArrangedSubviews.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 12/06/2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
