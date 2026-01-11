//
//  WSCheckListViewModel.swift
//  Will I am Sport
//
//

import SwiftUI

final class WSCheckListViewModel: ObservableObject {
    
    @Published var checks: [Checklist] = [] {
        didSet {
            saveIncomes()
        }
    }

    @Published var trainings: [Training] = [] {
        didSet {
            saveTraining()
        }
    }
    
    @Published var startedTraining: Training? {
        didSet {
            saveStartedTraining()
        }
    }
    
    init() {
        loadIncomes()
        loadTraining()
        loadStartedTraining()
    }
    
    private let userDefaultsIncomesKey = "incomesKey"
    private let userDefaultsTrainigsKey = "trainigsKey"
    private let userDefaultsStartedTrainigsKey = "startedTrainigsKey"

    // MARK: INCOMES
    
    func saveIncomes() {
        if let encodedData = try? JSONEncoder().encode(checks) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsIncomesKey)
        }
        
    }
    
    func loadIncomes() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsIncomesKey),
           let loadedItem = try? JSONDecoder().decode([Checklist].self, from: savedData) {
            checks = loadedItem
        } else {
            print("No saved data found: incomes")
        }
    }
    
    
    func addCheck(_ check: Checklist) {
        checks.append(check)
    }
    
    func editCheck(check: Checklist, name: String, type: ChecklistType) {
        if let index = checks.firstIndex(where: { $0.id == check.id }) {
            checks[index].name = name
            checks[index].type = type
        }
    }
    
    func delete(check: Checklist) {
        guard let index = checks.firstIndex(where: { $0.id == check.id }) else { return }
        checks.remove(at: index)
    }
    
    func trueCheck(check: Checklist) {
        guard let index = checks.firstIndex(where: { $0.id == check.id }) else { return }
        checks[index].isChecked = true
    }
    
    func falseCheck(check: Checklist) {
        guard let index = checks.firstIndex(where: { $0.id == check.id }) else { return }
        checks[index].isChecked = false
    }
    
    // MARK: Training
        
    func saveTraining() {
        if let encodedData = try? JSONEncoder().encode(trainings) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsTrainigsKey)
        }
        
    }
    
    func loadTraining() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsTrainigsKey),
           let loadedItem = try? JSONDecoder().decode([Training].self, from: savedData) {
            trainings = loadedItem
        } else {
            print("No saved data found: trainigs")
        }
    }
    
    
    func addTraining(_ trainig: Training) {
        trainings.append(trainig)
    }
    
    
    func finishTrainig(trainig: Training, mood: Int, energy: Int, checklist: [Checklist]) {
        guard let index = trainings.firstIndex(where: { $0.id == trainig.id }) else { return }
        trainings[index].afterMood = mood
        trainings[index].afterEnergy = energy
        trainings[index].checklist = checklist
        trainings[index].state = .finished
        startedTraining = nil
    }
    
    // MARK: Started Training
        
    func saveStartedTraining() {
        if let encodedData = try? JSONEncoder().encode(startedTraining) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsStartedTrainigsKey)
        }
        
    }
    
    func loadStartedTraining() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsStartedTrainigsKey),
           let loadedItem = try? JSONDecoder().decode(Training.self, from: savedData) {
            startedTraining = loadedItem
        } else {
            print("No saved data found: trainigs")
        }
    }
    
    func startTarinig(_ trainig: Training) {
        trainings.append(trainig)
        startedTraining = trainig
    }
    
    func percent(for check: Checklist, trainings: [Training]) -> Double {
        guard !trainings.isEmpty else { return 0 }

        let hits = trainings.reduce(0) { acc, t in
            let has = t.checklist.contains { $0.id == check.id }
            return acc + (has ? 1 : 0)
        }

        return Double(hits) / Double(trainings.count) * 100
    }
    
    func daysAgo(_ n: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -n, to: Date())!
    }
    
    func changeDate(trainig: Training) {
        let today = Date()
        let cal = Calendar.current
        let monday = daysAgo(Int.random(in: -4..<2))
        
        guard let index = trainings.firstIndex(where: { $0.id == trainig.id }) else { return }
        trainings[index].date = monday

    }
    
    func weeklyAverages(
        trainings: [Training],
        before: KeyPath<Training, Int>,
        after: KeyPath<Training, Int>,
        referenceDate: Date = .now
    ) -> (before: Double, after: Double) {

        var cal = Calendar.current
        cal.firstWeekday = 2 // Monday

        let nowWeek = cal.component(.weekOfYear, from: referenceDate)
        let nowYear = cal.component(.yearForWeekOfYear, from: referenceDate)

        let thisWeek = trainings.filter {
            cal.component(.weekOfYear, from: $0.date) == nowWeek &&
            cal.component(.yearForWeekOfYear, from: $0.date) == nowYear
        }

        guard !thisWeek.isEmpty else { return (0, 0) }

        let beforeSum = thisWeek.reduce(0) { $0 + $1[keyPath: before] }
        let afterSum  = thisWeek.reduce(0) { $0 + $1[keyPath: after] }

        return (
            before: Double(beforeSum) / Double(thisWeek.count),
            after:  Double(afterSum)  / Double(thisWeek.count)
        )
    }
}
