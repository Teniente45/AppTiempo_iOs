//
//  Item.swift
//  ejercicioJSON
//
//  Created by Juan López Marín on 19/7/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
