//
//  APIService.swift
//  Covid19 app
//
//  Created by David T on 6/2/21.
//

import Foundation
import UIKit

protocol CountryService {
    func loadCountries(completion: @escaping (Result<[CountryViewModel], ErrorHandling>) -> Void)
}

struct CountryAPIAdapter: CountryService {
    
    let api: NetworkRequest
    let select: (Country) -> Void
    
    func loadCountries(completion: @escaping (Result<[CountryViewModel], ErrorHandling>) -> Void) {
        api.loadCountries { result in
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



struct CountryServiceWithFallback: CountryService {
    
    let primary: CountryService
    let fallback: CountryService
    
    func loadCountries(completion: @escaping (Result<[CountryViewModel], ErrorHandling>) -> Void) {
        primary.loadCountries { result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                fallback.loadCountries(completion: completion)
            }
        }
    }
}



extension CountryService {
    
    func fallback(_ fallback: CountryService) -> CountryService {
        CountryServiceWithFallback(primary: self, fallback: fallback)
    }
    
    func retry(_ retryCount: UInt = 1) -> CountryService {
        retryCount == 0 ? self : fallback(self).retry(retryCount - 1)
    }
}
