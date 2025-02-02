//
//  AvitoModel.swift
//  AvitoTest
//
//  Created by Novgorodcev on 28/01/2025.
//

import Foundation

// MARK: - AvitoModel
struct AvitoModel: Decodable {
    let status: String
    let result: Result
    
    // MARK: - Result
    struct Result: Decodable {
        let title, actionTitle, selectedActionTitle: String
        let list: [List]
    }
    
    // MARK: - List
    struct List: Decodable {
        let id, title: String
        let description: String?
        let icon: Icon
        let price: String
        let isSelected: Bool
    }
    
    // MARK: - Icon
    struct Icon: Decodable {
        let the52X52: String
        
        enum CodingKeys: String, CodingKey {
            case the52X52 = "52x52"
        }
    }
}

