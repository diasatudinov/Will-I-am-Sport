//
//  MoodSlider.swift
//  Will I am Sport
//
//


import SwiftUI
import UIKit

struct MoodSlider: View {
    @Binding var value: Int
    var range: ClosedRange<Int> = 1...10

    var height: CGFloat = 14
    var thumbSize: CGFloat = 30

    private let feedback = UISelectionFeedbackGenerator()

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let minV = range.lowerBound
            let maxV = range.upperBound
            let steps = maxV - minV

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.cellBg)
                    .frame(height: height)

                Capsule()
                    .fill(Color.accent)
                    .frame(width: filledWidth(totalWidth: width), height: height)


                Image(.slideHeadWS)
                    .resizable()
                    .scaledToFit()
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: thumbX(totalWidth: width) - thumbSize / 2)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        feedback.prepare()
                        let newValue = valueFromLocation(x: g.location.x, totalWidth: width)
                        if newValue != value {
                            value = newValue
                            feedback.selectionChanged()
                        }
                    }
            )
            .accessibilityElement()
            .accessibilityLabel("Mood")
            .accessibilityValue("\(value) of \(maxV)")
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment: value = min(value + 1, maxV)
                case .decrement: value = max(value - 1, minV)
                default: break
                }
            }
        }
        .frame(height: max(thumbSize, height))
    }

    private func filledWidth(totalWidth: CGFloat) -> CGFloat {
        let minV = range.lowerBound
        let maxV = range.upperBound
        let t = CGFloat(value - minV) / CGFloat(maxV - minV)
        return max(0, min(totalWidth, totalWidth * t))
    }

    private func thumbX(totalWidth: CGFloat) -> CGFloat {
        let minV = range.lowerBound
        let maxV = range.upperBound
        let t = CGFloat(value - minV) / CGFloat(maxV - minV)
        return totalWidth * t
    }

    private func valueFromLocation(x: CGFloat, totalWidth: CGFloat) -> Int {
        let minV = range.lowerBound
        let maxV = range.upperBound
        let clamped = max(0, min(x, totalWidth))
        let t = clamped / max(1, totalWidth)
        let raw = CGFloat(minV) + t * CGFloat(maxV - minV)
        return Int(raw.rounded())
    }
}

#Preview {
    WSBeforeView(viewModel: WSCheckListViewModel())
}
