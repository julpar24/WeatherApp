//
//  String+Localized.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 15/06/2023.
//

import Foundation

extension String {
    ///Leer string desde Localizable.strings
    var localized: String {
        return NSLocalizedString(self, comment: "NOT_FOUND")
    }
}
