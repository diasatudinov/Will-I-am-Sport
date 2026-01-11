//
//  WSChecklistView.swift
//  Will I am Sport
//
//

import SwiftUI

enum CheckListState: CaseIterable {
    case items
    case stats
    
    var text: String {
        switch self {
        case .items:
            "Items"
        case .stats:
            "Stats"
        }
    }
}

struct WSChecklistView: View {
    @ObservedObject var viewModel: WSCheckListViewModel
    @State private var state: CheckListState = .items
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: .zero) {
                Text("Checklists")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationLink {
                    WSAddChecklistView(viewModel: viewModel)
                        .navigationBarBackButtonHidden()
                } label: {
                    Circle()
                        .fill(.accent)
                        .frame(height: 34)
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundStyle(.bg)
                                .bold()
                        }
                }
                
            }
            
            HStack(spacing: 0) {
                ForEach(CheckListState.allCases, id: \.self) { state in
                    Text(state.text)
                        .foregroundStyle(self.state == state ? .bg : .white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 6)
                        .background(self.state == state ? .accent : .bg)
                        .onTapGesture {
                            self.state = state
                        }
                        .clipShape(state == .items ? UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0) : UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10))
                }
            }.overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.accent)
            }
            .frame(maxWidth: .infinity)
            
            
            
                if viewModel.checks.isEmpty {
                    ScrollView(showsIndicators: false) {
                        
                        Text("Add the first item to the checklist")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.top, UIScreen.main.bounds.height / 3.3)
                    }
                } else {
                    List {
                        ForEach(viewModel.checks, id: \.id) { check in
                            HStack {
                                Text(check.name)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if state == .stats {
                                    Text("\(Int(viewModel.percent(for: check, trainings: viewModel.trainings)))%")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundStyle(.accent)
                                    
                                } else {
                                    Text(check.type.text)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundStyle(.accent)
                                }
                            }
                            .padding(.horizontal, 10).padding(.vertical, 15)
                            .background(.cellBg)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(
                                .init(top: 4,                         leading: 0,                     bottom: 4,                        trailing: 0)
                            )
                            .swipeActions() {
                                
                                Button(role: .destructive) {
                                    viewModel.delete(check: check)
                                } label: {
                                    Text("Delete")
                                }
                                
                                NavigationLink {
                                    WSEditCheckView(viewModel: viewModel, check: check)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    Text("Edit")
                                }.tint(.orange)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(.bg)
                }
           
            
        }
        .padding(.horizontal, 20)
        .background(.bg)
    }
}

#Preview {
    NavigationStack {
        WSChecklistView(viewModel: WSCheckListViewModel())
    }
}
