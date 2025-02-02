//
//  StartInteractor.swift
//  AvitoTest
//
//  Created by Novgorodcev on 28/01/2025.
//

import Foundation

//MARK: - StartInteractorProtocol
protocol StartInteractorProtocol: AnyObject {
    func fetchAvitoModel()
}

final class StartInteractor: StartInteractorProtocol {
    weak var presenter: StartPresenterProtocol!
    var netwrokManager: NetworkManagerProtocol!
    var avitoModel: AvitoModel?
    
    //MARK: - fetchAvitoModel
    func fetchAvitoModel() {
        netwrokManager.fetchAvito { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter.didFetchError(error: error.localizedDescription)
            case .success(let model):
                self?.presenter.didFetchAvitoModel(avito: model)
            }
        }
    }
}
