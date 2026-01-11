//
//  CheckList.swift
//  Will I am Sport
//
//  Created by Dias Atudinov on 05.01.2026.
//

import SwiftUI

struct Checklist: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var type: ChecklistType
    var isChecked: Bool = false
}

enum ChecklistType: Codable, CaseIterable {
    case before
    case after
    case both
    
    var text: String {
        switch self {
        case .before:
            "Before"
        case .after:
            "After"
        case .both:
            "Before & After"
        }
    }
}
