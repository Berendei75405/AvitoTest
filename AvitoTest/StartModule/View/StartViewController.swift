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
    func displayAvito(avito: AvitoModel,
                      imageArray: [Data])
    func hideError()
}

final class StartViewController: UIViewController,
                                 StartViewProtocol {
    var presenter: StartPresenterProtocol!
    private var avitoModel: AvitoModel? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private var imageArray = [UIImage]()
    private var selectedCell = 0
    private var centerYConstraint: NSLayoutConstraint!
    
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
    
    //MARK: - selectButton
    private var selectButton: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 10
        but.translatesAutoresizingMaskIntoConstraints = false
        but.backgroundColor = #colorLiteral(red: 0.02045440488, green: 0.6633412242, blue: 1, alpha: 1)
        but.setTitle("Выбрать", for: .normal)
        
        return but
    }()
    
    //MARK: - activityView
    private var activityView: UIActivityIndicatorView = {
        var progres = UIActivityIndicatorView(style: .large)
        progres.translatesAutoresizingMaskIntoConstraints = false
        progres.startAnimating()
        progres.color = .black
        
        return progres
    }()
    
    //MARK: - errorView
    private lazy var errorView: ErrorView = {
        let error = ErrorView(frame: .init(x: .zero, y: .zero,
                                           width: view.frame.width - 64,
                                           height: view.frame.height / 2))
        error.translatesAutoresizingMaskIntoConstraints = false
        error.delegate = self
        
        return error
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadAvito()
    }

    //MARK: - showLoadingIndicator
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityView.startAnimating()
        }
    }
    
    //MARK: - hideLoadingIndicator
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
        }
    }
    
    //MARK: - displayError
    func displayError(error: String) {
        errorView.configurate(textError: error)
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.centerYConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - hideError
    func hideError() {
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.centerYConstraint.constant = self.view.frame.height * 2
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - displayAvito
    func displayAvito(avito: AvitoModel, imageArray: [Data]) {
        for item in imageArray {
            if let image = UIImage(data: item) {
                self.imageArray.append(image)
            } else {
                self.imageArray.append(UIImage(systemName: "xmark")!)
            }
        }
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
        
        //selectedButton
        view.addSubview(selectButton)
        NSLayoutConstraint.activate([
            selectButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            selectButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectButton.heightAnchor.constraint(
                equalToConstant: 50)
        ])
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        
        //activityView
        view.addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            activityView.heightAnchor.constraint(
                equalToConstant: 100),
            activityView.widthAnchor.constraint(
                equalToConstant: 100)
        ])
        
        //errorView
        view.addSubview(errorView)
        centerYConstraint = errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height * 2)
        NSLayoutConstraint.activate([
            centerYConstraint,
            errorView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32),
            errorView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -32),
            errorView.heightAnchor.constraint(
                equalToConstant: view.frame.height / 2)
        ])
    }
    
    //MARK: - selectButtonTapped
    @objc private func selectButtonTapped() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        if selectedCell != -1 {
            alert.title = "Выбрано"
            alert.message = "Вы выбрали \(avitoModel?.result.list[selectedCell].title ?? "")"
            
           
        } else {
            alert.title = "Ошибка"
            alert.message = "Выберите товар"
        }
        present(alert, animated: true, completion: nil)
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
                section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 80, trailing: 16)
                
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
                               UICollectionViewDataSource, ErrorViewDelegate {
    
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
        let image = imageArray[indexPath.row]
        let selected = selectedCell == indexPath.row ? true : false
 
        cell.config(title: title,
                    description: description,
                    price: price,
                    image: image,
                    selected: selected)
        
        return cell
    }
    
    //MARK: - создания заголовка секции
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
    
    //MARK: - selectCell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCell == indexPath.row {
            selectedCell = -1
        } else {
            selectedCell = indexPath.row
        }
        collectionView.reloadData()
    }
    
    //ErrorViewDelegate
    func update() {
        presenter.loadAvito()
    }
    
}

