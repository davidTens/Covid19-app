//
//  CountriesCache.swift
//  Covid19 app
//
//  Created by David T on 6/4/21.
//

import UIKit
import CoreData

class CountriesCache {
    
    public static let shared = CountriesCache()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {}
    
    func loadCountries(completion: @escaping (Result<Global, ErrorHandling>) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Countries")
        let sort = NSSortDescriptor(key: "country", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let caches = try context.fetch(request) as! [Countries]
            
            for data in caches  {
                if let country = data.value(forKey: "country"), let totalConfirmed = data.value(forKey: "totalConfirmed"), let totalRecovered = data.value(forKey: "totalRecovered"), let totalDeaths = data.value(forKey: "totalDeaths"), let newConfirmed = data.value(forKey: "newConfirmed"), let newRecovered = data.value(forKey: "newRecovered"), let newDeaths = data.value(forKey: "newDeaths") {
                    
                    let country = [Country(country: country as! String, newConfirmed: newConfirmed as! Int, newRecovered: newRecovered as! Int, newDeaths: newDeaths as! Int, totalConfirmed: totalConfirmed as! Int, totalDeaths: totalDeaths as! Int, totalRecovered: totalRecovered as! Int)]
                    
                    let global = Global(countries: country)
                    completion(.success(global))
                }
            }
        } catch {
            completion(.failure(.invalidData))
        }
    }
}

