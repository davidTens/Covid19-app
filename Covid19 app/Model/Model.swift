//
//  Model.swift
//  Covid19 app
//
//  Created by David T on 6/1/21.
//

import Foundation

struct Global: Decodable {
    let countries: [Country]
    
    enum CodingKeys: String, CodingKey {
        case countries = "Countries"
    }
}

struct Country: Decodable {
    
    let country: String
    let newConfirmed: Int
    let newRecovered: Int
    let newDeaths: Int
    let totalConfirmed: Int
    let totalDeaths: Int
    let totalRecovered: Int
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case newConfirmed = "NewConfirmed"
        case newRecovered = "NewRecovered"
        case newDeaths = "NewDeaths"
        case totalConfirmed = "TotalConfirmed"
        case totalDeaths = "TotalDeaths"
        case totalRecovered = "TotalRecovered"
    }
    
}
