//
//  NetworkService.swift
//  AvitoTest
//
//  Created by Novgorodcev on 28/01/2025.
//

import Foundation

//MARK: - NetworkError
enum NetworkError: Error {
    case errorWithDescription(String)
    case error(Error)
}

protocol NetworkServiceProtocol: AnyObject {
    func makeRequest<T: Decodable>(request: URLRequest,
                                   completion: @escaping (Result<T, NetworkError>) -> Void)
    func makeRequestArrayData(request: [URLRequest], completion: @escaping (Result<[Data], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    //MARK: - makeRequest
    func makeRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        //проверка есть ли кеш
        let cache = checkCache(request: request)
        if cache != nil {
            let decoder = JSONDecoder()
            guard let decodedData = try? decoder.decode(T.self, from: cache!) else { return }
            return completion(.success(decodedData))
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //обработанная ошибка
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 300..<400:
                    return completion(.failure(.errorWithDescription("Запрошенный ресурс перемещен в другое место.")))
                case 400..<500:
                    return completion(.failure(.errorWithDescription("Запрос содержит неверный синтаксис или не может быть выполнен.")))
                case 500..<600:
                    return completion(.failure(.errorWithDescription("Сервер не смог выполнить запрос.")))
                default:
                    break
                }
            }
            
            //необработанная ошибка
            if let error = error {
                completion(.failure(.errorWithDescription("Возникла непредвиденная ошибка или отсутствует соединение с интернетом")))
                print(error)
            }
            
            //обработка успешного ответа
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    //decoder.dateDecodingStrategy = .iso8601
                    let decodedData = try decoder.decode(T.self, from: data)
                    
                    //кеширование ответа
                    self.saveCache(request: request,
                              response: response,
                              data: data)
                    
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.errorWithDescription("\(error)")))
                }
            }
        }
        
        //отправляем запрос
        task.resume()
        
    }
    
    //MARK: - makeRequestArrayData
    func makeRequestArrayData(request: [URLRequest],
                              completion: @escaping (Result<[Data], Error>) -> Void) {
        let group = DispatchGroup()
        var dataArray = [Data?](repeating: nil, count: request.count)
        var errors = [Error]()
        
        // Перебираем массив URL-адресов и выполняем запросы асинхронно
        for (index, urlRequest) in request.enumerated() {
            // Вступаем в группу операций перед каждым запросом
            group.enter()
            
            URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                // Выходим из группы операций после обработки ответа
                defer { group.leave() }
                
                if let error = error {
                    errors.append(error)
                } else if let data = data {
                    dataArray[index] = data
                }
            }.resume()
        }
        
        // Ожидаем завершения всех запросов
        group.notify(queue: .main) {
            if !errors.isEmpty {
                completion(.failure(errors.first!))
            } else {
                let result = dataArray.compactMap({ $0 })
                completion(.success(result))
            }
        }
    }
    
    //MARK: - checkCache
    private func checkCache(request: URLRequest) -> Data?  {
        guard let data = URLCache.shared.cachedResponse(for: request)?.data else { return nil }
        
        return data
    }
    
    //MARK: - saveCache
    private func saveCache(request: URLRequest,
                           response: URLResponse?,
                           data: Data?) {
        guard let response = response,
              let data = data else { return }
  
        let cashedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cashedResponse, for: request)
    }
}
