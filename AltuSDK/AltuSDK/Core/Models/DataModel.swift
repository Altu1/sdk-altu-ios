//
//  DataModel.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 11/04/22.
//

import Foundation

struct DataModel: Codable {
    var text: String = ""
    var type: String = ""
    var slug: String = ""
    var identifier: String = ""
    var assistantId: String = ""
    var widgetId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case text
        case type
        case slug
        case identifier
        case assistantId = "assistant_id"
        case widgetId = "widget_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let text = try? values.decode(String.self, forKey: .text) {
            self.text = text
        }
        
        if let type = try? values.decode(String.self, forKey: .type) {
            self.type = type
        }
        
        if let slug = try? values.decode(String.self, forKey: .slug) {
            self.slug = slug
        }
        
        if let identifier = try? values.decode(String.self, forKey: .identifier) {
            self.identifier = identifier
        }
        
        if let assistantId = try? values.decode(String.self, forKey: .assistantId) {
            self.assistantId = assistantId
        }
        
        if let widgetId = try? values.decode(String.self, forKey: .widgetId) {
            self.widgetId = widgetId
        }
    }
}
