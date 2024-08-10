//
//  HourlyForecastCollectionViewCell.swift
//  Weather App
//
//  Created by Natã Romão on 25/05/24.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    static let IDENTIFIER = "HourlyForecastCollectionViewCell"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            hourlyLabel,
            iconImage,
            temperatureLabel
        ])
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.contrastColor?.cgColor
        stackView.layer.cornerRadius = 20

        return stackView
    }()

    private lazy var hourlyLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "13:00"
        label.textColor = .contrastColor
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "25°C"
        label.textColor = .contrastColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center

        return label
    }()
    
    private lazy var iconImage: UIImageView = {
        let iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
//        iconImage.image = UIImage(named: "sunIcon")
        iconImage.contentMode = .scaleAspectFit

        return iconImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(time: String?, icon: UIImage?, temp: String?) {
        hourlyLabel.text = time
        iconImage.image = icon
        temperatureLabel.text = temp
    }

    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        contentView.addSubview(stackView)
    }
    
    private func setConstraints() {
        stackView.setContraintsToParent(contentView)
        
        NSLayoutConstraint.activate([
            iconImage.heightAnchor.constraint(equalToConstant: 33)
        ])
    }
}
