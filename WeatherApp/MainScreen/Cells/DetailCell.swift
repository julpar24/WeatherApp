//
//  DetailCell.swift
//  WeatherApp
//
//  Created by Juliana Pardal on 15/06/2023.
//

import UIKit

final class DetailCell: UICollectionViewCell {
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var temp: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var minTemp: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
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
        layer.cornerRadius = 12
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        layer.borderWidth = 1.0
    }
    
    func configureCell(data: CellForecast, iconData: Data, isWeekly: Bool) {
        title.text = data.title
        icon.image = UIImage(data: iconData)
        if isWeekly {
            temp.font = .systemFont(ofSize: 13, weight: .regular)
        }
        temp.text = isWeekly ? "Max: \(data.maxTemp)°" : "\(data.maxTemp)°"
        minTemp.isHidden = !isWeekly
        minTemp.text = "Min: \(data.minTemp)°"
    }
}

extension DetailCell: ViewCodable {
    func buildViewHierarchy() {
        contentView.addSubview(containerView)
        containerView.addArrangedSubviews([title,
                                          icon,
                                          temp,
                                          minTemp])
    }
    
    func setupConstraints() {
        containerView.layout.applyConstraint { (view) in
            view.topAnchor(equalTo: topAnchor, constant: 8)
            view.leadingAnchor(equalTo: leadingAnchor)
            view.trailingAnchor(equalTo: trailingAnchor)
            view.bottomAnchor(equalTo: bottomAnchor, constant: -8)
        }
        
        icon.layout.applyConstraint { (view) in
            view.widthAnchor(equalToConstant: 45)
            view.heightAnchor(equalToConstant: 55)
        }
    }
    
    func configureView() {
        backgroundColor = UIColor(red: 72/255, green: 49/255, blue: 157/255, alpha: 0.2)
    }
    
    func setupTouchEvents() {
      
    }
}

