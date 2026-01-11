//
//  WSStatsView.swift
//  Will I am Sport
//
//

import SwiftUI

enum StatsState: CaseIterable {
    case energy
    case mood
    
    var text: String {
        switch self {
        case .energy:
            "Energy"
        case .mood:
            "Mood"
        }
    }
}

struct WSStatsView: View {
    @ObservedObject var viewModel: WSCheckListViewModel
    @State private var state: StatsState = .energy
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: .zero) {
                Text("Stats")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            
            HStack(spacing: 0) {
                ForEach(StatsState.allCases, id: \.self) { state in
                    Text(state.text)
                        .foregroundStyle(self.state == state ? .bg : .white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 6)
                        .background(self.state == state ? .accent : .bg)
                        .onTapGesture {
                            self.state = state
                        }
                        .clipShape(state == .energy ? UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0) : UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10))
                }
            }.overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.accent)
            }
            .frame(maxWidth: .infinity)
            
            ScrollView {
                if state == .energy {
                    VStack(spacing: 0) {
                        HStack(spacing: 10) {
                            HStack(spacing: 2) {
                                Circle()
                                    .frame(height: 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                Text("Before")
                                    .font(.system(size: 10, weight: .regular))
                            }.foregroundStyle(.white)
                            
                            HStack(spacing: 2) {
                                Circle()
                                    .frame(height: 5)
                                Text("After")
                                    .font(.system(size: 10, weight: .regular))
                            }.foregroundStyle(.accent)
                        }
                        .padding(.horizontal)
                        
                        MoodThisWeekChart(trainings: viewModel.trainings, metric: .energy)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.accent)
                            .padding(.vertical, 15)
                        
                        let avg = viewModel.weeklyAverages(
                            trainings: viewModel.trainings,
                            before: \.beforeEnergy,
                            after: \.afterEnergy)
                        
                        Text("Average before: \(String(format: "%.1f", avg.before)) | after: \(String(format: "%.1f", avg.after))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.accent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 10)
                        
                        let diff = avg.after - avg.before
                        
                        Text(diff > 0 ? "You gain an average of \(String(format: "%.1f", diff)) energy points per workout." : "You lose an average of \(String(format: "%.1f", diff)) energy points per workout")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                } else {
                    VStack(spacing: 0) {
                        HStack(spacing: 10) {
                            HStack(spacing: 2) {
                                Circle()
                                    .frame(height: 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                Text("Before")
                                    .font(.system(size: 10, weight: .regular))
                            }.foregroundStyle(.white)
                            
                            HStack(spacing: 2) {
                                Circle()
                                    .frame(height: 5)
                                Text("After")
                                    .font(.system(size: 10, weight: .regular))
                            }.foregroundStyle(.accent)
                        }
                        .padding(.horizontal)
                        
                        MoodThisWeekChart(trainings: viewModel.trainings, metric: .mood)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.accent)
                            .padding(.vertical, 15)
                        
                        let avg = viewModel.weeklyAverages(
                            trainings: viewModel.trainings,
                            before: \.beforeMood,
                            after: \.afterMood)
                        
                        Text("Average before: \(String(format: "%.1f", avg.before)) | after: \(String(format: "%.1f", avg.after))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.accent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 10)
                        
                        let diff = avg.after - avg.before
                        
                        Text(diff > 0 ? "Mood after training is usually lower, good job" : "Mood after training is usually higher")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .background(.bg)
    }
}

#Preview {
    WSStatsView(viewModel: WSCheckListViewModel())
}

import SwiftUI
import Charts

struct WeekPoint: Identifiable {
    enum Series: String {
        case before = "Before"
        case after  = "After"
    }

    let id = UUID()
    let weekday: Int      // 1...7 (Пн...Вс)
    let series: Series
    let value: Int
}

enum TrainingMetric: String, CaseIterable, Identifiable {
    case mood = "Mood"
    case energy = "Energy"

    var id: String { rawValue }

    var yDomain: ClosedRange<Int> { 1...10 } // если Energy другой диапазон — поменяй

    var beforeKeyPath: KeyPath<Training, Int> {
        switch self {
        case .mood: return \.beforeMood
        case .energy: return \.beforeEnergy
        }
    }

    var afterKeyPath: KeyPath<Training, Int> {
        switch self {
        case .mood: return \.afterMood
        case .energy: return \.afterEnergy
        }
    }
}

struct MoodThisWeekChart: View {
    let trainings: [Training]
    let metric: TrainingMetric
    
    var body: some View {
        let cal = Calendar.mondayFirst
        let points = makePointsThisWeek(trainings, metric: metric)

        Chart(points) { p in
            LineMark(
                x: .value("Day", p.weekday),
                y: .value(metric.rawValue, p.value),
                series: .value("Series", p.series.rawValue)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(p.series == .before ? .white : .accent)
            
            PointMark(
                x: .value("Day", p.weekday),
                y: .value(metric.rawValue, p.value)
            )
            .foregroundStyle(p.series == .before ? .white : .accent)
        }
        .chartXScale(domain: 1...7)
        .chartYScale(domain: metric.yDomain.lowerBound...metric.yDomain.upperBound)        .chartXAxis {
            AxisMarks(values: Array(1...7)) { v in
                AxisGridLine()
                    .foregroundStyle(.secondaryIcon)
                AxisValueLabel {
                    Text(weekdayLabel(v.as(Int.self) ?? 1))
                        .foregroundStyle(.white)
                }
            }
        }
        .chartYAxis {
            
            AxisMarks(values: Array(1...10)) { _ in
                AxisGridLine()
                    .foregroundStyle(.secondaryIcon)
                AxisValueLabel()
                    .foregroundStyle(Color.white)
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geo in
                let plot = geo[proxy.plotAreaFrame]

                Path { path in
                    // Y axis справа
                    path.move(to: CGPoint(x: plot.maxX, y: plot.minY))
                    path.addLine(to: CGPoint(x: plot.maxX, y: plot.maxY))

                    // X axis снизу
                    path.move(to: CGPoint(x: plot.minX, y: plot.maxY))
                    path.addLine(to: CGPoint(x: plot.maxX, y: plot.maxY))
                }
                .stroke(.accent, lineWidth: 1.5)
            }
        }
        .frame(height: 260)
        .padding(10)
    }

    // MARK: - Data

    private func weekdayLabel(_ w: Int) -> String {
            ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][max(1, min(7, w)) - 1]
        }
    
    private func makePointsThisWeek(_ trainings: [Training], metric: TrainingMetric) -> [WeekPoint] {
            var cal = Calendar.current
            cal.firstWeekday = 2 // Пн

            let now = Date()
            let nowWeek = cal.component(.weekOfYear, from: now)
            let nowYearForWeek = cal.component(.yearForWeekOfYear, from: now)

            // только текущая неделя
            let thisWeek = trainings.filter {
                cal.component(.weekOfYear, from: $0.date) == nowWeek &&
                cal.component(.yearForWeekOfYear, from: $0.date) == nowYearForWeek
            }

            // группировка по дню недели (Пн=1 ... Вс=7)
            let grouped = Dictionary(grouping: thisWeek) { t -> Int in
                let wd = cal.component(.weekday, from: t.date) // Вс=1, Пн=2...Сб=7
                return wd == 1 ? 7 : (wd - 1)
            }

            var result: [WeekPoint] = []
            for w in 1...7 {
                guard let items = grouped[w], !items.isEmpty else { continue }

                // последняя тренировка в этот день
                let last = items.max(by: { $0.date < $1.date })!

                result.append(.init(weekday: w, series: .before, value: last[keyPath: metric.beforeKeyPath]))
                result.append(.init(weekday: w, series: .after,  value: last[keyPath: metric.afterKeyPath]))
            }
            return result
        }
    
}

// MARK: - Calendar helpers

extension Calendar {
    static var mondayFirst: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2 // Monday
        return cal
    }

    func currentWeekInterval(for date: Date) -> (start: Date, end: Date) {
        // dateInterval(of:.weekOfYear) учитывает firstWeekday календаря
        let interval = self.dateInterval(of: .weekOfYear, for: date)!
        return (start: interval.start, end: interval.end)
    }

    func daysInWeek(start: Date) -> [Date] {
        // 7 дней начиная с начала недели
        (0..<7).compactMap { self.date(byAdding: .day, value: $0, to: start).map { self.startOfDay(for: $0) } }
    }
}
