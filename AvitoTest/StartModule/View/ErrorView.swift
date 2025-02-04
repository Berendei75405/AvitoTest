//
//  ErrorView.swift
//  AvitoTest
//
//  Created by Novgorodcev on 04/02/2025.
//

import UIKit
import Foundation

//ErrorViewDelegate
protocol ErrorViewDelegate: AnyObject {
    func update()
}

final class ErrorView: UIView {
    
    weak var delegate: ErrorViewDelegate?
    
    //MARK: - errorLabel
    private let errorLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .center
        lab.font = .systemFont(ofSize: 21)
        lab.numberOfLines = 0
        
        return lab
    }()
    
    //MARK: - closeButton
    private let closeButton: UIButton = {
        var but = UIButton()
        but.translatesAutoresizingMaskIntoConstraints = false
        but.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        but.setImage(UIImage(systemName: "xmark"), for: .normal)
        but.tintColor = .black
        but.layer.cornerRadius = 5
        
        return but
    }()
    
    //MARK: - init(frame)
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupUI()
    }
    
    //MARK: - required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configurate
    func configurate(textError: String) {
        DispatchQueue.main.async { [self] in
            errorLabel.text = textError
        }
    }
    
    //MARK: - setupUI
    private func setupUI() {
        backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.cornerRadius = 10
        
        //errorLabel constraints
        self.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(
                equalTo: centerYAnchor),
            errorLabel.widthAnchor.constraint(
                equalToConstant: self.frame.width - 16),
            errorLabel.heightAnchor.constraint(
                equalToConstant: self.frame.height - 10)
        ])
        
        //closeButton constraints
        self.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 8),
            closeButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -8),
            closeButton.heightAnchor.constraint(
                equalToConstant: 35),
            closeButton.widthAnchor.constraint(
                equalToConstant: 35)
        ])
    }
    
    //MARK: - closeButtonAction
    @objc private func closeButtonAction() {
        delegate?.update()
    }
    
}
