//
//  StartPresenter.swift
//  AvitoTest
//
//  Created by Novgorodcev on 28/01/2025.
//

import Foundation

//MARK: - StartPresenterProtocol
protocol StartPresenterProtocol: AnyObject {
    func loadAvito()
    func didFetchError(error: String)
    func didFetchAvitoModel(avito: AvitoModel,
                            imageArray: [Data])
}

final class StartPresenter: StartPresenterProtocol {
    weak var view: StartViewProtocol!
    var interactor: StartInteractorProtocol!
    var router: StartRouter!
    
    func loadAvito() {
        view.showLoadingIndicator()
        interactor.fetchAvitoModel()
    }
    
    //MARK: - didFetchError
    func didFetchError(error: String) {
        view.hideLoadingIndicator()
        view.displayError(error: error)
    }
    
    //MARK: - didFetchAvitoModel
    func didFetchAvitoModel(avito: AvitoModel,
                            imageArray: [Data]) {
        self.view.hideLoadingIndicator()
        self.view.hideError()
        self.view.displayAvito(avito: avito, imageArray: imageArray)
    }
    
}

