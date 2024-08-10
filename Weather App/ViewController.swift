//
//  ViewController.swift
//  Weather App
//
//  Created by Natã Romão on 07/05/24.
//

import UIKit

class ViewController: UIViewController {
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .contrastColor
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Bahia"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .primaryColor
        
        return label
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "25°C"
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.textAlignment = .left
        label.textColor = .primaryColor
        
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "daylight")
        return imageView
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Umidade"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .contrastColor
        
        return label
    }()
    
    private lazy var humidityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "1000mm"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .contrastColor
        
        return label
    }()
    
    private lazy var humidityStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [
            humidityLabel,
            humidityValueLabel,
        ])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        
        return stackview
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vento"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .contrastColor
        
        return label
    }()
    
    private lazy var windValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "10km/h"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .contrastColor
        
        return label
    }()
    
    private lazy var windStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [
            windLabel,
            windValueLabel
        ])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        
        return stackview
    }()
    
    private lazy var stacksStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            humidityStackView,
            windStackView
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        stackView.backgroundColor = .graySoft
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 22, bottom: 12, trailing: 22)

        return stackView 
    }()
    
    private lazy var hourlyForecastLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.textColor = .contrastColor
        uiLabel.text = "PREVISÃO POR HORA"
        uiLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 67, height: 84)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(HourlyForecastCollectionViewCell.self, forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.IDENTIFIER)

        return collectionView
    }()
    
    private lazy var dailyForecastLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.textColor = .contrastColor
        uiLabel.text = "PROXIMOS DIAS"
        uiLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    private lazy var dailyForecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.IDENTIFIER)
        return tableView
    }()
    
    private let service = Service()
    private var city = CityInput(lat: "-38.3322453", lon: "-12.9499614", name: "Salvador")
    private var forecastResponse: WeatherResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }

    private func fetchData() {
        service.fetchData(city: self.city) { [weak self] response in
            self?.forecastResponse = response
            DispatchQueue.main.async {
                self?.loadData()
            }
        }
    }
    
    private func loadData() {
        cityLabel.text = city.name
        
        let firstDay = forecastResponse?.list[0]
        tempLabel.text = firstDay?.temp.day.toCelsius()
        humidityValueLabel.text = "\(firstDay?.humidity ?? 0)mm"
        windValueLabel.text = "\(firstDay?.speed ?? 0)km/h"
    }

    private func setConstraints(_ customView: UIView) {
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.topAnchor),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            headerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            cityLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            cityLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 12),
            tempLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 26),
            tempLabel.heightAnchor.constraint(equalToConstant: 71),
            
            weatherIcon.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -26),
            weatherIcon.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: 15),
            weatherIcon.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 86),
            weatherIcon.widthAnchor.constraint(equalToConstant: 86)
        ])
        
        NSLayoutConstraint.activate([
            stacksStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            stacksStackView.widthAnchor.constraint(equalToConstant: 206),
            stacksStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hourlyForecastLabel.topAnchor.constraint(equalTo: stacksStackView.bottomAnchor, constant: 29),
            hourlyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            hourlyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            hourlyForecastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hourlyCollectionView.topAnchor.constraint(equalTo: hourlyForecastLabel.bottomAnchor, constant: 22),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 84),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dailyForecastLabel.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor, constant: 29),
            dailyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            dailyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            dailyForecastTableView.topAnchor.constraint(equalTo: dailyForecastLabel.bottomAnchor, constant: 16),
            dailyForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyForecastTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupView() {
        view.backgroundColor = .yellow
        
        setHierarchy()
        setConstraints(backgroundView)
    }
    
    private func setHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        view.addSubview(stacksStackView)
        view.addSubview(hourlyForecastLabel)
        view.addSubview(hourlyCollectionView)
        view.addSubview(dailyForecastLabel)
        view.addSubview(dailyForecastTableView)

        headerView.addSubview(cityLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(weatherIcon)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastResponse?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.IDENTIFIER, for: indexPath) as? HourlyForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let forecast = forecastResponse?.list[indexPath.row]
        cell.loadData(
            time: forecast?.dt.toHourFormat(),
            icon: UIImage(named: "sunIcon"),
            temp: forecast?.temp.day.toCelsius()
        )
        
        return cell
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.IDENTIFIER, for: indexPath)
        
        return cell
    }
}
