//
//  Networking.swift
//  Covid19 app
//
//  Created by David T on 6/1/21.
//

import UIKit
import CoreData

final class NetworkRequest {
    
    public static let shared = NetworkRequest()
    private let baseURL = "https://api.covid19api.com/summary"
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() { }
    
    func loadCountries(completion: @escaping (Result<Global, ErrorHandling>) -> Void) {
        
        guard let url = URL(string: baseURL)
        else {
            return completion(.failure(.apiError))
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let _ = error {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidData))
                return
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Countries")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                let countries = try JSONDecoder().decode(Global.self, from: data)
                
                if UserDefaults.standard.cacheIsAvailable() == true {
                    try self.context.execute(deleteRequest)
                    
                }
                for country in countries.countries {
                    let newData = NSEntityDescription.insertNewObject(forEntityName: "Countries", into: self.context)
                    newData.setValue(country.country, forKey: "country")
                    newData.setValue(Int64(country.totalConfirmed), forKey: "totalConfirmed")
                    newData.setValue(Int64(country.totalRecovered), forKey: "totalRecovered")
                    newData.setValue(Int64(country.totalDeaths), forKey: "totalDeaths")
                    newData.setValue(Int64(country.newConfirmed), forKey: "newConfirmed")
                    newData.setValue(Int64(country.newRecovered), forKey: "totalRecovered")
                    newData.setValue(Int64(country.newDeaths), forKey: "newDeaths")
                }
                UserDefaults.standard.setCacheIsAvailable(true)
                try self.context.save()
                completion(.success(countries))
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        task.resume()
    }
}


enum ErrorHandling: String, Error {
    case apiError = "Invalid api"
    case invalidResponse = "Invalid response"
    case invalidData = "Invalid Data"
}
