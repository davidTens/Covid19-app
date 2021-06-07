//
//  CacheAdapter.swift
//  Covid19 app
//
//  Created by David T on 6/4/21.
//

import Foundation

struct CountryCacheAdapter: CountryService {
    
    let cache: CountriesCache
    let select: (Country) -> Void
    
    func loadCountries(completion: @escaping (Result<[CountryViewModel], ErrorHandling>) -> Void) {
        cache.loadCountries { result in
            DispatchQueue.main.async {
                completion( result.map { item in
                    return item.countries.map { item in
                        CountryViewModel(item, selection: {
                            select(item)
                        })
                    }
                })
            }
        }
    }
}
