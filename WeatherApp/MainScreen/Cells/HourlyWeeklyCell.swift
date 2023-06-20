//
//  HourlyWeeklyCell.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 15/06/2023.
//

import UIKit

protocol HourlyWeeklyCellProtocol {
    func selectItem()
    func deselectItem()
}

final class HourlyWeeklyCell: UICollectionViewCell {
    private lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func configureCell(title: String){
        self.title.text = title
    }
}

extension HourlyWeeklyCell: ViewCodable {
    func buildViewHierarchy() {
        contentView.addSubview(title)
        contentView.addSubview(horizontalLine)
    }
    
    func setupConstraints() {
        title.layout.applyConstraint { (view) in
            view.centerXAnchor(equalTo: safeCenterXAnchor)
            view.centerYAnchor(equalTo: safeCenterYAnchor)
        }
        
        horizontalLine.layout.applyConstraint { (view) in
            view.topAnchor(equalTo: title.bottomAnchor, constant: 8)
            view.leadingAnchor(equalTo: safeLeadingAnchor)
            view.trailingAnchor(equalTo: safeTrailingAnchor)
            view.bottomAnchor(equalTo: safeBottomAnchor)
            view.heightAnchor(equalToConstant: 3)
        }
    }
    
    func configureView() {
        backgroundColor = UIColor(red: 72/255, green: 49/255, blue: 157/255, alpha: 0.2)
        horizontalLine.isHidden = true
    }
    
    func setupTouchEvents() {
      
    }
}

extension HourlyWeeklyCell: HourlyWeeklyCellProtocol {
    func selectItem() {
        horizontalLine.isHidden = false
        title.textColor = .white
    }
    
    func deselectItem() {
        horizontalLine.isHidden = true
        title.textColor = .lightGray
    }
}

