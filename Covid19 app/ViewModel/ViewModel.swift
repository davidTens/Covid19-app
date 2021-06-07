//
//  ViewModel.swift
//  Covid19 app
//
//  Created by David T on 6/2/21.
//

import Foundation

struct CountryViewModel {
    
    let country: String
    let newConfirmed: Int
    let newRecovered: Int
    let newDeaths: Int
    let totalConfirmed: Int
    let totalDeaths: Int
    let totalRecovered: Int
    let select: () -> Void
    
    init(_ item: Country, selection: @escaping () -> Void) {
        country = item.country
        newConfirmed = item.newConfirmed
        newRecovered = item.newRecovered
        newDeaths = item.newDeaths
        totalConfirmed = item.totalConfirmed
        totalRecovered = item.totalRecovered
        totalDeaths = item.totalDeaths
        select = selection
    }
}
