//
//  CollectionViewCell.swift
//  Covid19 app
//
//  Created by David T on 6/1/21.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    private let dynamicSubColors = UIColor.black | UIColor.white
    private let dynamicBackgroundColors = UIColor(hexFromString: "#EFEFEF") | #colorLiteral(red: 0.1735155284, green: 0.1724909842, blue: 0.1743076146, alpha: 1)
    
    private lazy var countryLabel: UILabel = {
        let countryLabel = UILabel()
        countryLabel.font = .boldSystemFont(ofSize: 16)
        countryLabel.textAlignment = .center
        countryLabel.textColor = dynamicSubColors
        countryLabel.adjustsFontSizeToFitWidth = true
        return countryLabel
    }()
    
    private lazy var totalConfirmedLabel: UILabel = {
        let totalConfirmedLabel = UILabel()
        totalConfirmedLabel.font = .systemFont(ofSize: 14)
        totalConfirmedLabel.textAlignment = .center
        totalConfirmedLabel.textColor = dynamicSubColors
        totalConfirmedLabel.adjustsFontSizeToFitWidth = true
        return totalConfirmedLabel
    }()
    
    private lazy var totalRecoveredLabel: UILabel = {
        let totalRecoveredLabel = UILabel()
        totalRecoveredLabel.font = .systemFont(ofSize: 14)
        totalRecoveredLabel.textAlignment = .center
        totalRecoveredLabel.textColor = dynamicSubColors
        totalRecoveredLabel.adjustsFontSizeToFitWidth = true
        return totalRecoveredLabel
    }()
    
    private lazy var totalDeathsLabel: UILabel = {
        let totalDeathsLabel = UILabel()
        totalDeathsLabel.font = .systemFont(ofSize: 14)
        totalDeathsLabel.textAlignment = .center
        totalDeathsLabel.textColor = dynamicSubColors
        totalDeathsLabel.adjustsFontSizeToFitWidth = true
        return totalDeathsLabel
    }()
    
    func configure(_ country: CountryViewModel) {
        countryLabel.text = country.country
        totalConfirmedLabel.text = "Total confirmed - \(String(country.totalConfirmed))"
        totalRecoveredLabel.text = "Total recovered - \(String(country.totalRecovered))"
        totalDeathsLabel.text = "Total deaths - \(String(country.totalDeaths))"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        backgroundColor = dynamicBackgroundColors
        
        let stackView = UIStackView(arrangedSubviews: [countryLabel, totalConfirmedLabel, totalRecoveredLabel, totalDeathsLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
