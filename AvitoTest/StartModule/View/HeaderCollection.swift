//
//  HeaderCollection.swift
//  AvitoTest
//
//  Created by Novgorodcev on 02/02/2025.
//

import Foundation
import UIKit

final class HeaderCollection: UICollectionReusableView {
    static let identifier = "HeaderCollection"
    
    //MARK: - closeButton
    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    //MARK: - titleLabel
    private let titleLabel: UILabel = {
        var lab = UILabel()
        lab.textColor = .black
        lab.font = UIFont.boldSystemFont(ofSize: 30)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.numberOfLines = .zero
        
        return lab
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupConstraints
    private func setupConstraints() {
        //closeButton
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(
                equalTo: topAnchor, constant: -8),
            closeButton.leadingAnchor.constraint(
                equalTo: leadingAnchor),
            closeButton.widthAnchor.constraint(
                equalToConstant: 30),
            closeButton.heightAnchor.constraint(
                equalToConstant: 30)
        ])
        
        //titleLabel
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: closeButton.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(
                equalTo: closeButton.leadingAnchor),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configurate(title: String) {
        self.titleLabel.text = title
    }
}
