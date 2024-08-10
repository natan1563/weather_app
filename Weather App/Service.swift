//
//  Service.swift
//  Weather App
//
//  Created by Natã Romão on 10/06/24.
//

import Foundation

struct CityInput {
    let lat: String
    let lon: String
    let name: String
}

class Service {
    private let baseUrl: String = "https://api.openweathermap.org/data/2.5/forecast/daily"
    private let apiKey: String = "<MY-API-KEY>"
    private let session = URLSession.shared
    
    func fetchData(city: CityInput, _ completion: @escaping (WeatherResponse?) -> Void) {
        let urlString = "\(baseUrl)?q=\(city.name),br&lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)&units=metric&type=hour"
        guard let url = URL(string: urlString) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(nil)
                return
            }
            do {
                let forecastReponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(forecastReponse)
            } catch {
                print(error)
                completion(nil)
            }
        }
        
        task.resume()
    }
}

struct WeatherResponse: Codable {
    let city: City
    let cod: String
    let message: Double
    let cnt: Int
    let list: [WeatherList]
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherList: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Temperature
    let feels_like: FeelsLike
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
    let speed: Double
    let deg: Int
    let gust: Double
    let clouds: Int
    let pop: Double
    let rain: Double?
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

