//
//  UIView+AddSubviews.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 12/06/2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
