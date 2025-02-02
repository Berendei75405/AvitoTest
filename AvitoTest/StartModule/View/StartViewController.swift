//
//  ViewController.swift
//  AvitoTest
//
//  Created by Novgorodcev on 27/01/2025.
//

import UIKit

//MARK: - StartViewProtocol
protocol StartViewProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func displayError(error: String)
    func displayAvito(avito: AvitoModel)
}

final class StartViewController: UIViewController,
                                 StartViewProtocol {
    var presenter: StartPresenterProtocol!
    var avitoModel: AvitoModel? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - collectionView
    private lazy var collectionView: UICollectionView = {
        var collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        
        //register cells
        collection.register(StartCollectionCell.self, forCellWithReuseIdentifier: StartCollectionCell.identifier)
        
        //header
        collection.register(HeaderCollection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollection.identifier)
        
        //protocols
        collection.delegate = self
        collection.dataSource = self
        
        return collection
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadAvito()
    }

    //MARK: - showLoadingIndicator
    func showLoadingIndicator() {
            
    }
    
    //MARK: - hideLoadingIndicator
    func hideLoadingIndicator() {
        
    }
    
    //MARK: - displayError
    func displayError(error: String) {
        
    }
    
    //MARK: - displayAvito
    func displayAvito(avito: AvitoModel) {
        DispatchQueue.main.async {
            self.avitoModel = avito
        }
    }
    
    //MARK: - setupUI
    private func setupUI() {
        view.backgroundColor = .white
        
        //collectionView
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        
    }
    
    //MARK: - createLayout
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, env in
            switch sectionIndex {
            case .zero:
                let columns = 1
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    //начальная высота от 200 и настраивается автоматически
                    heightDimension: .estimated(100))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: columns)
                        
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: .zero, trailing: 16)
                
                //header
                let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width - 32), heightDimension: .estimated(100))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]

                return section
            default:
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0), heightDimension: .absolute(0))))
            }
        }
        
    }
    
}

extension StartViewController: UICollectionViewDelegate,
                               UICollectionViewDataSource {
    //MARK: - numberOfRows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avitoModel?.result.list.count ?? 0
    }
    
    //MARK: - configurateCells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StartCollectionCell.identifier, for: indexPath) as? StartCollectionCell else { return UICollectionViewCell() }
        
        let title = avitoModel?.result.list[indexPath.row].title ?? ""
        let description = avitoModel?.result.list[indexPath.row].description ?? ""
        let price = avitoModel?.result.list[indexPath.row].price ?? ""
        
        cell.config(title: title,
                    description: description,
                    price: price)
        
        return cell
    }
    
    // Метод для создания заголовка секции
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.row {
        case .zero:
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollection.identifier, for: indexPath) as? HeaderCollection else { return UICollectionReusableView() }
            
            let title = avitoModel?.result.title ?? ""
            
            cell.configurate(title: title)
            
            return cell
        default:
            return UICollectionReusableView()
        }
    }
    
}

