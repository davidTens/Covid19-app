//
//  DetailViewCell.swift
//  Covid19 app
//
//  Created by David T on 6/2/21.
//

import UIKit

final class DetailCell: UICollectionViewCell {
    
    private let dynamicSubColors = UIColor.black | UIColor.white
    private let dynamicBackgroundColors = UIColor(hexFromString: "#EFEFEF") | #colorLiteral(red: 0.1735155284, green: 0.1724909842, blue: 0.1743076146, alpha: 1)
    
    private lazy var customBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = dynamicBackgroundColors
        backgroundView.layer.cornerRadius = 10
        return backgroundView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = dynamicSubColors
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(customBackgroundView)
        customBackgroundView.addSubview(titleLabel)
        customBackgroundView.layout(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        titleLabel.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
