//
//  WSMenuView.swift
//  Will I am Sport
//
//

import SwiftUI

struct PCMenuContainer: View {
    @AppStorage("firstOpenPC") var firstOpen: Bool = true
    var body: some View {
        NavigationStack {
            ZStack {
                if firstOpen {
                    WSOnboardingView(getStartBtnTapped: {
                        firstOpen = false
                    })
                } else {
                    WSMenuView()
                }
            }
        }
    }
}

struct WSMenuView: View {
    @State var selectedTab = 0
    @StateObject var viewModel = WSCheckListViewModel()
    private let tabs = ["My dives", "Calendar", "Stats",""]
    
    var body: some View {
        ZStack {
            
            switch selectedTab {
            case 0:
                WSChecklistView(viewModel: viewModel)
            case 1:
                WSBeforeView(viewModel: viewModel)
            case 2:
                WSAfterView(viewModel: viewModel)
            case 3:
                WSStatsView(viewModel: viewModel)
            default:
                Text("default")
            }
            
            VStack {
                Spacer()
                
                HStack {
                    ForEach(0..<tabs.count) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            VStack(spacing: 2) {
                                Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                
                                Text(text(for: index))
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(selectedTab == index ? .accent : .secondaryIcon)
                            }
                            .frame(maxWidth: .infinity)
                            
                        }
                    }
                }
                .padding(.horizontal, 16).padding(.vertical, 10)
                .background(.bg)
            }
            .padding(.bottom, 24)
            .ignoresSafeArea()
            
            
        }
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconWS"
        case 1: return "tab2IconWS"
        case 2: return "tab3IconWS"
        case 3: return "tab4IconWS"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelectedWS"
        case 1: return "tab2IconSelectedWS"
        case 2: return "tab3IconSelectedWS"
        case 3: return "tab4IconSelectedWS"
        default: return ""
        }
    }
    
    private func text(for index: Int) -> String {
        switch index {
        case 0: return "Checklist"
        case 1: return "Before"
        case 2: return "After"
        case 3: return "Stats"
        default: return ""
        }
    }
}


#Preview {
    NavigationStack {
        WSMenuView()
    }
}
