//
//  WSTraining.swift
//  Will I am Sport
//
//

import SwiftUI

struct Training: Codable, Hashable, Identifiable {
    var id = UUID()
    var beforeEnergy: Int
    var beforeMood: Int
    var afterEnergy: Int
    var afterMood: Int
    var checklist: [Checklist]
    var state: TrainingState = .started
    var date: Date = .now
}

enum TrainingState: Codable {
    case started
    case finished
}
