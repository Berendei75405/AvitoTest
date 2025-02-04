//
//  StartCollectionCell.swift
//  AvitoTest
//
//  Created by Novgorodcev on 30/01/2025.
//

import Foundation
import UIKit

final class StartCollectionCell: UICollectionViewCell {
    static let identifier = "StartCollectionCell"
    
    //MARK: - iconImage
    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage()
        image.image = img
        
        return image
    }()
    
    //MARK: - titleLabel
    private let titleLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = .boldSystemFont(ofSize: 23)
        lab.textColor = .black
        lab.numberOfLines = 0
        
        return lab
    }()
    
    //MARK: - descriptionLabel
    private let descriptionLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = .systemFont(ofSize: 18)
        lab.textColor = .black
        lab.numberOfLines = 0
        
        return lab
    }()
    
    //MARK: - priceLabel
    private let priceLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = .boldSystemFont(ofSize: 23)
        lab.textColor = .black
        lab.numberOfLines = 0
        
        return lab
    }()
    
    //MARK: - selectedButton
    private let selectedImageView: UIImageView = {
        let img = UIImage(named: "success")
        let image = UIImageView(image: img)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    //init
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupUI()
    }
    
    //requared init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupUI
    private func setupUI() {
        backgroundColor = #colorLiteral(red: 0.9719485641, green: 0.9719484448, blue: 0.9719485641, alpha: 1)
        layer.cornerRadius = 10
        
        //iconImage constraints
        contentView.addSubview(iconImage)
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8),
            iconImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8),
            iconImage.widthAnchor.constraint(
                equalToConstant: 52),
            iconImage.heightAnchor.constraint(
                equalToConstant: 52),
        ])
        
        //selectedImageView constraints
        contentView.addSubview(selectedImageView)
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16),
            selectedImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8),
            selectedImageView.widthAnchor.constraint(
                equalToConstant: 30),
            selectedImageView.heightAnchor.constraint(
                equalToConstant: 30)
        ])
        
        //titleLabel constraints
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8),
            titleLabel.leadingAnchor.constraint(
                equalTo: iconImage.trailingAnchor,
                constant: 8),
            titleLabel.trailingAnchor.constraint(
                equalTo: selectedImageView.leadingAnchor,
                constant: -8)
        ])
        
        
        //descriptionLabel constraints
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 8),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor)
        ])
        
        //priceLabel constraints
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 8),
            priceLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            priceLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8)
        ])

        
    }
    
    //MARK: - config
    func config(title: String,
                description: String,
                price: String,
                image: UIImage,
                selected: Bool) {
        titleLabel.text = title
        descriptionLabel.text = description
        priceLabel.text = price
        iconImage.image = image
        selectedImageView.isHidden = selected ? false : true
    }
}
