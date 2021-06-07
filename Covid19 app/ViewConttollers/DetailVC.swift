//
//  DetailVC.swift
//  Covid19 app
//
//  Created by David T on 6/2/21.
//

import UIKit

final class DetailVC: UICollectionViewController {
    
    private let dynamicBackgroundColors = UIColor.white | #colorLiteral(red: 0.09410706908, green: 0.09355535358, blue: 0.09453616291, alpha: 1)
    private let dynamicSubColors = UIColor.black | UIColor.white
    private let cellId = "cellId"
    private var timer: Timer?
    
    private lazy var list = ["Total confirmed - \(country?.totalConfirmed ?? 0)",
                              "Total recovered - \(country?.totalRecovered ?? 0)",
                              "Total deaths - \(country?.totalDeaths ?? 0)",
                              "New confirmed - \(country?.newConfirmed ?? 0)",
                              "New recovered - \(country?.newRecovered ?? 0)",
                              "New deaths - \(country?.newDeaths ?? 0)"]
    
    var country: Country? {
        didSet {
            navigationItem.title = country?.country
            
        }
    }
    
    private lazy var notificationMessage: UIButton = {
        let notificationMessage = UIButton()
        notificationMessage.backgroundColor = #colorLiteral(red: 0, green: 0.7448981404, blue: 0, alpha: 1)
        notificationMessage.layer.cornerRadius = 12
        notificationMessage.titleLabel?.textAlignment = .center
        notificationMessage.setTitleColor(.white, for: .normal)
        notificationMessage.titleLabel?.adjustsFontSizeToFitWidth = true
        notificationMessage.titleLabel?.font = .boldSystemFont(ofSize: 16)
        notificationMessage.addTarget(self, action: #selector(notificationMessageDissappear), for: .touchUpInside)
        return notificationMessage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(saveCountryNotification(_:)))
        rightBarButton.tintColor = dynamicSubColors
        navigationItem.rightBarButtonItem = rightBarButton
        checkNotificationAvailability(rightBarButton)
        navigationController?.navigationBar.tintColor = dynamicSubColors
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = dynamicBackgroundColors
        collectionView.alwaysBounceVertical = true
    }
    
    private func checkNotificationAvailability(_ barButton: UIBarButtonItem) {
        if let country = country?.country {
            if UserDefaults.standard.notificationIsEnabledForCountry(country) == true {
                barButton.tintColor = dynamicSubColors
            } else {
                barButton.tintColor = dynamicSubColors.withAlphaComponent(0.4)
            }
        } else {
            // do smh
        }
    }
    
    @objc func saveCountryNotification(_ sender: UIBarButtonItem) {
        
        if let country = country?.country {
            if UserDefaults.standard.notificationIsEnabledForCountry(country) == true {
                UserDefaults.standard.removeObject(forKey: country)
                notificationMessageAppear("Notifications disabled for \(country)")
                sender.tintColor = dynamicSubColors.withAlphaComponent(0.4)
            } else {
                UserDefaults.standard.setNotificationIsEnabledForCountry(country, bool: true)
                sender.tintColor = dynamicSubColors
                notificationMessageAppear("Notifications enabled for \(country)")
            }
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(notificationMessageDissappear), userInfo: nil, repeats: false)
        } else {
            notificationMessageAppear("Could not enable notifications")
        }
    }
    
    private func notificationMessageAppear(_ message: String) {
        if notificationMessage.superview == nil {
            view.addSubview(notificationMessage)
            notificationMessage.layout(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 10, right: 15), size: .init(width: 0, height: 50))
        }
        notificationMessage.setTitle(message, for: .normal)
    }
    
    @objc private func notificationMessageDissappear() {
        notificationMessage.removeFromSuperview()
    }
}

extension DetailVC: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailCell
        cell.titleLabel.text = list[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 50)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
