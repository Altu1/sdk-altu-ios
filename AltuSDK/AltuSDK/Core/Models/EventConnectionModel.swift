//
//  EventModel.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 11/04/22.
//

import Foundation

struct EventConnectionModel: Codable {
    let event: String
    let connectionId: String
    let data: DataModel
    
    enum CodingKeys: String, CodingKey {
        case event
        case connectionId = "connection_id"
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        event = try values.decode(String.self, forKey: .event)
        connectionId = try values.decode(String.self, forKey: .connectionId)
        data = try values.decode(DataModel.self, forKey: .data)
    }
}

class EventConnectionModelDecoder {
    func eventConnectionModel(decodedFrom data: Data) -> EventConnectionModel? {
        do {
            let eventModel = try JSONDecoder().decode(EventConnectionModel.self, from: data)
            return eventModel
        } catch {
            print(error)
            return nil
        }
    }
}
