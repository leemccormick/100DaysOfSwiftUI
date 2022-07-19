//
//  CardView.swift
//  Day100_FinalExam
//
//  Created by Lee McCormick on 7/17/22.
//

import SwiftUI

// MARK: - Card View
struct CardView: View {
    // MARK: - Properties
    var question: Question
    var removal: ((_ isSelectingAnswer: Bool) -> Void)? = nil
    @EnvironmentObject var vm : SwiftUIQuestionViewModel
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @State private var offset = CGSize.zero
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var isCorect = false
    @State private var isSelectingAnswer = false
    @State private var selectedIndex = -1
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Round Rectangle Card View
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : !isSelectingAnswer ? .white : isCorect ? .green : .red)
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(!isSelectingAnswer ? .white : isCorect ? .green : .red))
                .shadow(radius: 10)
        
            VStack {
                // Prompt of Question
                if !isSelectingAnswer {
                    Text(question.propmt)
                        .font(.title3.bold())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // HStack For Choices
                ForEach(0..<question.chioces.count, id: \.self) { index in
                    if isSelectingAnswer { // Selected Answer
                        HStack() {
                            // Image of Correct and Incorrect
                            Image(systemName: question.correctChoice == index  ? "checkmark" : "xmark")
                                .font(.largeTitle.bold())
                                .foregroundColor(question.correctChoice == index  ? .green : .red)
                                .frame(width: 40, height: 40)
                            
                            // Text Explaination
                            ScrollView {
                                Text(question.chioces[index].choice)
                                    .font(.headline.bold())
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(question.chioces[index].explianationChoice)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(alignment: .leading)
                        .padding()
                        .background(.white)
                        .multilineTextAlignment(.leading)
                    } else { // Not Selected Answer
                        HStack {
                            // Selected Button
                            Button {
                                checkTheAnswer(with: index)
                            } label: {
                                Image(systemName: selectedIndex == index ? "checkmark.square" : "square")
                                    .font(.largeTitle)
                                    .foregroundColor(.black)
                                    .frame(width: 40, height: 40)
                            }
                            
                            // Choice Text
                            VStack(alignment: .leading, spacing: 2) {
                                Text(question.chioces[index].choice)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(alignment: .leading)
                        .padding()
                        .background(.blue.opacity(0.3))
                        .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 600, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(dragGesture())
    }
    
    // MARK: - Functions
    func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                feedback.prepare()
            }
            .onEnded { _ in
                if abs(offset.width) > 100 {
                    if !isSelectingAnswer {
                        offset = .zero
                    }
                    removal?(isSelectingAnswer)
                } else {
                    offset = .zero
                }
            }
    }
    
    func checkTheAnswer(with index: Int) {
        if isSelectingAnswer == false {
            isSelectingAnswer = true
            selectedIndex = index
            if index == question.correctChoice {
                isCorect = true
                vm.correctScore += 1
            } else {
                isCorect = false
            }
            if let i = vm.day100Questions.firstIndex(of: question) {
                vm.day100Questions[i].didAnswer = true
            }
            vm.isShowingNextButton = false
        }
    }
}

// MARK: - PreviewProvider
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(question: Question.example)
            .previewInterfaceOrientation(.portrait)
    }
}
