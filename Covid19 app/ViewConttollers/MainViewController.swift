//
//  ViewController.swift
//  Covid19 app
//
//  Created by David T on 6/1/21.
//

import UIKit

final class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private let dynamicBackgroundColors = UIColor.white | #colorLiteral(red: 0.09410706908, green: 0.09355535358, blue: 0.09453616291, alpha: 1)
    private let dynamicSubColors = UIColor.black | UIColor.white
    private var customRefreshControl = UIRefreshControl()
    
    private lazy var countryList = [CountryViewModel]()
    private var countryService: CountryService?
    
    private lazy var errorMessage: UIButton = {
        let errorMessage = UIButton()
        errorMessage.backgroundColor = #colorLiteral(red: 0.7251328826, green: 0, blue: 0, alpha: 1)
        errorMessage.layer.cornerRadius = 12
        errorMessage.titleLabel?.textAlignment = .center
        errorMessage.setTitleColor(.white, for: .normal)
        errorMessage.titleLabel?.adjustsFontSizeToFitWidth = true
        errorMessage.titleLabel?.font = .boldSystemFont(ofSize: 16)
        errorMessage.addTarget(self, action: #selector(errorMessageDissapear), for: .touchUpInside)
        return errorMessage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customRefresherUI()
        refresh()
        navigationItem.title = "Countries"
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = dynamicBackgroundColors
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        navigationController?.navigationBar.tintColor = dynamicSubColors
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        customRefreshControl.endRefreshing()
        customRefreshControl.removeFromSuperview()
    }
    
    private func customRefresherUI() {
        customRefreshControl.tintColor = dynamicSubColors
        collectionView.addSubview(customRefreshControl)
        customRefreshControl.xyAnchors(x: view.centerXAnchor, y: view.centerYAnchor)
    }
    
    // MARK: - BETTER SOLUTION
    @objc private func refresh() {
        let primary = CountryAPIAdapter(api: NetworkRequest.shared, select: { [weak self] in
            if self?.customRefreshControl.isRefreshing == false {
                self?.select(country: $0)
            }
        })
        let cache = CountryCacheAdapter(cache: CountriesCache.shared, select: { [weak self] in
            if self?.customRefreshControl.isRefreshing == false {
                self?.select(country: $0)
            }
        })
        
        customRefreshControl.beginRefreshing()
        countryService = primary.retry(2).fallback(cache)
        countryService?.loadCountries(completion: handleApiResult(_:))
    }
    
    
    // MARK: - NOT SO GOOD
    @objc private func refreshAlternative() {
        let primary = CountryAPIAdapter(api: NetworkRequest.shared, select: { [weak self] in
            if self?.customRefreshControl.isRefreshing == false {
                self?.select(country: $0)
            }
        })

        let cache = CountryCacheAdapter(cache: CountriesCache.shared, select: { [weak self] in
            if self?.customRefreshControl.isRefreshing == false {
                self?.select(country: $0)
            }
        })
        customRefreshControl.beginRefreshing()
        primary.loadCountries { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.countryList.append(contentsOf: list)
                self.collectionView.reloadData()
                self.customRefreshControl.endRefreshing()
            case .failure:
                cache.loadCountries(completion: self.handleApiResult(_:))
                self.errorMessageAppear("Connection error")
            }
        }
    }
    
    private func handleApiResult(_ result: Result<[CountryViewModel], ErrorHandling>) {
        switch result {
        case let .success(list):
            countryList.append(contentsOf: list)
            collectionView.reloadData()
        case let .failure(error):
            print(error)
        }
        
        customRefreshControl.endRefreshing()
        customRefreshControl.removeFromSuperview()
    }
    
    private func errorMessageAppear(_ message: String) {
        if errorMessage.superview == nil {
            view.addSubview(errorMessage)
            errorMessage.layout(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 10, right: 15), size: .init(width: 0, height: 50))
        }
        errorMessage.setTitle(message, for: .normal)
    }
    
    @objc private func errorMessageDissapear() {
        errorMessage.removeFromSuperview()
    }

}

extension UIViewController {
    func select(country: Country) {
        let detailVC = DetailVC(collectionViewLayout: UICollectionViewFlowLayout())
        detailVC.country = country
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCell
        let country = countryList[indexPath.row]
        cell.configure(country)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 15, height: 145)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = countryList[indexPath.row]
        country.select()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
