//
//  LoadingView.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 13/06/2023.
//

import UIKit

final class LoadingView: UIView {
    //MARK: - UI Components
    private lazy var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        return indicator
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        return blurEffectView
    }()

    //MARK: - Initializers
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blurEffectView.frame = bounds
        insertSubview(blurEffectView, at: 0)
        loadingActivityIndicator.center = CGPoint(
            x: bounds.midX,
            y: bounds.midY
        )
        addSubview(loadingActivityIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopAnimating() {
        loadingActivityIndicator.stopAnimating()
    }
}
