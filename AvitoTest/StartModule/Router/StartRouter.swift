//
//  StartRouter.swift
//  AvitoTest
//
//  Created by Novgorodcev on 27/01/2025.
//

import Foundation
import UIKit

//MARK: - StartRouterProtocol
protocol StartRouterProtocol: AnyObject {
    
}

final class StartRouter: StartRouterProtocol {
    
    private var navigationController: UINavigationController?
    
    //MARK: - init
    init(navCon: UINavigationController) {
        self.navigationController = navCon
    }
    
    //MARK: - createStartVC
    private func createStartVC() -> UIViewController {
        let view = StartViewController()
        let presenter = StartPresenter()
        let interactor = StartInteractor()
        let networkManager = NetworkManager()
        let networkService = NetworkService()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = self
        presenter.view = view
        
        interactor.presenter = presenter
        interactor.netwrokManager = networkManager
        
        networkManager.networkService = networkService
        
        return view
    }
    
    //MARK: - initialStartVC
    func initialStartVC() {
        if let navigationController = navigationController {
            let view = createStartVC()
            
            navigationController.viewControllers = [view]
        }
    }
    
}
