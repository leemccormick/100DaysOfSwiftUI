//
//  ContentView.swift
//  Day100_FinalExam
//
//  Created by Lee McCormick on 7/17/22.
//

import SwiftUI

// MARK: - Extension View
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

// MARK: - ContentView
struct ContentView: View {
    @StateObject var vm = SwiftUIQuestionViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: -  Background
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            // MARK: -  Top View with Restart Button, Next Button and Score Text
            if !vm.day100Questions.isEmpty  {
                VStack() {
                    HStack {
                        
                        VStack {
                            Spacer()
                                .frame(height: 10)
                            HStack {
                                // Restart Button
                                Button {
                                    vm.restartExam()
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                
                                // Next Button
                                if vm.isShowingNextButton {
                                    Button {
                                        let lastIndex = vm.day100Questions.count - 1
                                        vm.reStackQuestion(at: lastIndex)
                                    } label: {
                                        Image(systemName: "playpause")
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(.black.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                        Spacer()
                        
                        // Score Text
                        VStack {
                            Spacer()
                                .frame(height: 10)
                            Text("Score : \(vm.correctScore) | \(vm.totalScore)")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .padding()
                            
                                .background(.black.opacity(0.75))
                                .clipShape(Capsule())
                        }
                    }
                    Spacer()
                }
            }
            
            // MARK: -  VStack of Title and Questions
            VStack {
                // Title
                Text(!vm.day100Questions.isEmpty ? "100 Days Of SwiftUI : Exam" : "100 Days Of SwiftUI : Final Exam")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()
                if vm.day100Questions.isEmpty {
                    VStack {
                        // Score Text
                        Text("Congratulation ! Your score is \(vm.correctScore) of \(vm.totalScore).")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .padding()
                            .background(.black.opacity(0.75))
                            .clipShape(Capsule())
                        
                        // Restart Button
                        Button {
                            print("Restart button was tapped")
                            vm.restartExam()
                        } label: {
                            Label("Restart Exam", systemImage: "arrow.clockwise")
                                .foregroundColor(.white)
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Capsule())
                        }
                    }
                }
                
                // Card View Of Question
                ZStack {
                    ForEach(0..<vm.day100Questions.count, id: \.self) { index in
                        CardView(question: vm.day100Questions[index]) { isSelectingAnswer in
                            withAnimation {
                                vm.isShowingNextButton = true
                                if isSelectingAnswer {
                                    vm.removeQuestion(at: index)
                                } else {
                                    vm.reStackQuestion(at: index)
                                }
                            }
                        }
                        .stacked(at: index, in: vm.day100Questions.count)
                        .environmentObject(vm)
                    }
                }
            }
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
