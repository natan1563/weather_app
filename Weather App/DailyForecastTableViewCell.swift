//
//  DailyForecastTableViewCell.swift
//  Weather App
//
//  Created by Natã Romão on 03/06/24.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {
    static let IDENTIFIER: String = "DailyForecast"
    
    private lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TER"
        label.textColor = .contrastColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        return label
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "min 25°C"
        label.textColor = .contrastColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        return label
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "max 25°C"
        label.textColor = .contrastColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cloudIcon")
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            weekDayLabel,
            iconImageView,
            minTemperatureLabel,
            maxTemperatureLabel
        ])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        stackView.spacing = 15
    
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        setHierarchy()
        setConstrainsts()
    }
    
    private func setHierarchy() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            weekDayLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50)
        ])
    }
    
    private func setConstrainsts() {
        stackView.setContraintsToParent(contentView)
    }
}
