//
//  WSBeforeView.swift
//  Will I am Sport
//
//

import SwiftUI

struct WSBeforeView: View {
    @ObservedObject var viewModel: WSCheckListViewModel
    @State private var energy: Int = 1
    @State private var mood: Int = 1
    @State var trainingChecks: [Checklist] = []
    var body: some View {
        VStack(spacing: 20) {
            Text("Before Training")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 20) {
                HStack {
                    Text("Energy")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(energy)/10")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.accent)
                }
                
                MoodSlider(value: $energy)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 20) {
                HStack {
                    Text("Mood")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(mood)/10")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.accent)
                }
                
                MoodSlider(value: $mood)
                    .padding(.horizontal)
            }
                        
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.checks.filter({ $0.type != .after }), id: \.id) { check in
                        HStack(spacing: 10) {
                            Circle()
                                .stroke(lineWidth: 1.5)
                                .foregroundStyle(isChecked(check: check) ? .accent : .secondaryIcon)
                                .frame(height: 17)
                                .overlay {
                                    if isChecked(check: check) {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 8)
                                            .bold()
                                            .foregroundStyle(.green)
                                    }
                                }
                            
                            Text(check.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(check.type.text)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(.accent)
                            
                        }
                        .padding(.horizontal, 10).padding(.vertical, 15)
                        .background(.cellBg)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            tapCheck(check: check)
                        }
                    }
                }
            }
            
        }
        .padding(.horizontal, 20)
        .background(.bg)
        .overlay(alignment: .bottom) {
            Button {
                if isValid() {
                    let training = Training(beforeEnergy: energy, beforeMood: mood, afterEnergy: energy, afterMood: mood, checklist: trainingChecks)
                    viewModel.startTarinig(training)
                    trainingChecks = []
                    energy = 1
                    mood = 1
                }
            } label: {
                Text("Start Training")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.bg)
                    .padding(.vertical, 25).padding(.horizontal, 28)
                    .background(isValid() ? .accent: .secondaryIcon)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
            }
            .buttonStyle(.plain)
            .padding(.bottom, 100)
        }

    }
    private func isChecked(check: Checklist) -> Bool {
        if let _ = trainingChecks.firstIndex(where: { $0.id == check.id }) {
            return true
        }
        return false
    }
    
    private func isValid() -> Bool {
        !trainingChecks.isEmpty && viewModel.startedTraining == nil
    }
    
    private func tapCheck(check: Checklist) {
        if let index = trainingChecks.firstIndex(where: { $0.id == check.id }) {
            trainingChecks.remove(at: index)
            viewModel.falseCheck(check: check)
        } else {
            trainingChecks.append(check)
            viewModel.trueCheck(check: check)
        }
    }
}

#Preview {
    WSBeforeView(viewModel: WSCheckListViewModel())
}
