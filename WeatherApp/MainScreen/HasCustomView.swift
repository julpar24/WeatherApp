//
//  HasCustomView.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 13/06/2023.
//

import UIKit

public protocol HasCustomView {
    associatedtype CustomView
}

extension HasCustomView where Self: UIViewController {
    
    public var customView: CustomView {
        guard let customView = view as? CustomView else {
            fatalError("Expected view to be of type \(CustomView.self) but got \(type(of: view)) instead")
        }
        return customView
    }
}
