//
//  WSAddChecklistView.swift
//  Will I am Sport
//
//

import SwiftUI

struct WSAddChecklistView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WSCheckListViewModel
    
    @State private var name = ""
    @State private var type: ChecklistType = .before
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: .zero) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: .zero) {
                        Image(systemName: "chevron.left")
                            .frame(height: 12)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.trailing, 4)
                        
                        Text("New Item")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.buttonStyle(.plain)
            }.padding(.bottom, 10)
            
            dataCollectCell(icon: "Name") {
                HStack(alignment: .bottom) {
                    TextField("", text: $name)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.white)
                        .padding(.vertical, 9)
                        .background(.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .overlay(alignment: .leading) {
                            if name.isEmpty {
                                Text("Enter item name")
                                    .font(.system(size: 16, weight: .light))
                                    .foregroundStyle(.secondaryIcon)
                                    .allowsHitTesting(false)
                            }
                        }
                }
            }
            
            dataCollectCell(icon: "Type", needLine: false) {
                ScrollView(.horizontal) {
                    HStack() {
                        ForEach(ChecklistType.allCases, id: \.self) { type in
                            Text(type.text)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(self.type == type ? .bg : .white)
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(self.type == type ? .accent : .bg)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(self.type == type ? .accent : .white)
                                })
                                .onTapGesture {
                                    self.type = type
                                }
                                
                        }
                    }.padding(2)
                }
                
            }.frame(maxHeight: .infinity, alignment: .top)
            
            Button {
                if isValid() {
                    let check = Checklist(name: name, type: type)
                    viewModel.addCheck(check)
                    dismiss()
                }
            } label: {
                Text("Save")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.bg)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(isValid() ? .accent: .secondaryIcon)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 72)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 50)
            
        }
        .padding(.horizontal, 20)
        .background(.bg)
    }
    
    private func isValid() -> Bool {
        !name.isEmpty
    }
    
    private func dataCollectCell<Content: View>(
        icon: String,
        needLine: Bool = true,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
            
            HStack(spacing: 4) {
                content()
                    .overlay(alignment: .bottom) {
                        if needLine {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.white)
                        }
                    }
                
            }
        }
    }
}

#Preview {
    WSAddChecklistView(viewModel: WSCheckListViewModel())
}
