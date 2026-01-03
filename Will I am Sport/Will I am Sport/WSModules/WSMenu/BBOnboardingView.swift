//
//  BBOnboardingView.swift
//  Will I am Sport
//
//


import SwiftUI

struct WSOnboardingView: View {
    
    var getStartBtnTapped: () -> ()
    @State var count = 0
    
    var onbImage: Image {
        switch count {
        case 0:
            Image(.onboardingImg1WS)
        case 1:
            Image(.onboardingImg2WS)
        case 2:
            Image(.onboardingImg3WS)
        default:
            Image(.onboardingImg1WS)
        }
    }
    
    var onbTitle: String {
        switch count {
        case 0:
            "Prepare for Your\nTraining"
        case 1:
            "Reflect After Training"
        case 2:
            "See Your Progress"
        default:
            "Record Every Dive"
        }
    }
    
    var onbDescription: String {
        switch count {
        case 0:
            "Focus on your energy and mood before\nstarting."
        case 1:
            "Notice how your body and mood feel after training."
        case 2:
            "Understand how training shapes your\nenergy and mood over time."
        default:
            "Focus on your energy and mood before starting."
        }
    }
    
    var body: some View {
        VStack {
            onbImage
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges: .top)
            
            VStack {
                Text(onbTitle)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.accent)
                
                Text(onbDescription)
                    .font(.system(size: 20, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                
            }.padding(.horizontal, 20)
            
            Spacer()
            
            VStack(spacing: 10) {
                
                HStack(spacing: 2) {
                    if count == 0 {
                        Rectangle()
                            .fill(.accent)
                            .frame(width: 20, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.secondaryIcon)
                            .frame(width: 10, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    
                    if count == 1 {
                        Rectangle()
                            .fill(.accent)
                            .frame(width: 20, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.secondaryIcon)
                            .frame(width: 10, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    if count == 2 {
                        Rectangle()
                            .fill(.accent)
                            .frame(width: 20, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.secondaryIcon)
                            .frame(width: 10, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }                }
                
                Button {
                    if count < 2 {
                        withAnimation {
                            count += 1
                        }
                    } else {
                        getStartBtnTapped()
                    }
                } label: {
                    Text(count < 2 ? "Next" : "Get Started")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.bg)
                        .padding(.vertical, 13)
                        .frame(width: 220)
                        .background(.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }.padding(.bottom, 30)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.bg)
            .ignoresSafeArea()
    }
}

#Preview {
    WSOnboardingView(getStartBtnTapped: {})
}
