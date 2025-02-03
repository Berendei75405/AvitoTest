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
    var imagesArray = [String]()
    
    //MARK: - fetchAvitoModel
    func fetchAvitoModel() {
        netwrokManager.fetchInfo { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter.didFetchError(error: error.localizedDescription)
            case .success(let model):
                for item in model.result.list {
                    self?.imagesArray.append(item.icon.the52X52)
                }
                self?.fetchImages(model: model)
            }
        }
    }
    
    //MARK: - fetchImages
    private func fetchImages(model: AvitoModel) {
        netwrokManager.fetchImage(urlString: imagesArray) { [weak self] result in
            switch result {
            case .success(let images):
                self?.presenter.didFetchAvitoModel(avito: model, imageArray: images)
            case .failure(let error):
                self?.presenter.didFetchError(error: error.localizedDescription)
            }
        }
    }
}
