//
//  NetworkManager.swift
//  AvitoTest
//
//  Created by Novgorodcev on 28/01/2025.
//
import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func fetchAvito(completion: @escaping (Result<AvitoModel, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    var networkService: NetworkServiceProtocol!
    
    func fetchAvito(completion: @escaping (Result<AvitoModel, NetworkError>) -> Void) {
        let url = URL(string: "https://run.mocky.io/v3/c614908f-7b10-4de1-9174-57fb922fd873")!
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        request.httpMethod = "GET"
        
        networkService.makeRequest(request: request, completion: completion)
    }
    
}
