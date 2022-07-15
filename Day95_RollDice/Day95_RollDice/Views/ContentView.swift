//
//  ContentView.swift
//  Day95_RollDice
//
//  Created by Lee McCormick on 7/13/22.
//

/* Challenge
 Your challenge this time can be easy or hard depending on how far you want to take it, but at its core the project is simple: you need to build an app that helps users roll dice then store the results they had.
 
 At the very least you should lets users roll dice, and also let them see results from previous rolls. However, if you want to push yourself further you can try one or more of the following:
 
 1) Let the user customize the dice that are rolled: how many of them, and what type: 4-sided, 6-sided, 8-sided, 10-sided, 12-sided, 20-sided, and even 100-sided.
 2) Show the total rolled on the dice.
 3) Store the results using JSON or Core Data – anywhere they are persistent.
 4) Add haptic feedback when dice are rolled.
 5) For a real challenge, make the value rolled by the dice flick through various possible values before settling on the final figure.
 */

import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    // MARK: - Properties
    @StateObject var vm = DiceViewModel()
    @State private var feedback = UINotificationFeedbackGenerator()
    
    // MARK: - Init
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Courier-Bold", size: 40)!]
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // Color Background
                Color.init(hex: "357C3C")
                    .ignoresSafeArea()
                
                VStack {
                    // Dice Type Text
                    HStack {
                        Text("Dice Type : ")
                            .font(.title3)
                        Text("\(vm.dice.title)")
                            .font(.title)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(6)
                    
                    // Dice Type Picker
                    Picker("Dice Type", selection: $vm.dice) {
                        ForEach(Dice.allCases) { d in
                            Text(d.rawValue.capitalized)
                                .tag(d)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .font(.title)
                    .background(.green)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding()
                    
                    // Total Point Text
                    VStack {
                        HStack {
                            Text("Total Points : ")
                                .font(.title3)
                            Text("\(vm.totalPoints)")
                                .font(.title)
                        }
                        HStack {
                            Text("Times Of Rolling : ")
                                .font(.title3)
                            Text("\(vm.numberOfRolled)")
                                .font(.title)
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(6)
                    
                    // Dice View
                    ZStack {
                        if vm.rollingDiceState == .shakeDice { // Dice Image
                            Image("diceImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotation3DEffect(.degrees(Double(vm.timeRemaining * 1000000 / 360)), axis: (x:0 ,y:1, z:0))
                        } else {
                            // Dice White Background
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.white)
                                .shadow(radius: 10)
                            
                            if vm.rollingDiceState == .showPointText {  // Point Result Text
                                if vm.currentRandomPoints != 0 {
                                    VStack {
                                        Text("\(vm.currentRandomPoints)")
                                        Text("-------")
                                        Text("\(vm.dice.sides)")
                                    }
                                    .font(.system(size: 80, weight: .bold, design: .default))
                                    .foregroundColor(.black)
                                } else { // Show Dice Results View if currentRandomPoints == 0
                                    RollDiceResultView(random: $vm.currentRandomPoints)
                                }
                            } else if vm.rollingDiceState == .showDiceView { // Dice Results View
                                RollDiceResultView(random: $vm.currentRandomPoints)
                            }
                        }
                    }
                    .frame(width: 300, height: 300)
                    .padding()
                    
                    // Roll Dice Button
                    if vm.rollingDiceState == .showDiceView {
                        Button {
                            vm.rollDice()
                            print("vm current point : \(vm.currentRandomPoints) | \(vm.dice.sides)")
                        } label: {
                            Text("Roll Dice")
                                .font(.largeTitle)
                                .frame(width: 300)
                                .padding()
                                .foregroundColor(.black)
                                .background(.green)
                        }
                        .frame(width: 300)
                        .contentShape(Rectangle())
                        .cornerRadius(10)
                        .padding()
                    }
                }
            }
            .navigationBarTitle(Text("Dice Game"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Reset Game Tapped")
                        vm.resetDiceGame()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .padding()
                            .foregroundColor(.black)
                            .background(.green.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("See Score Tapped")
                        vm.isShowingPointsHistory = true
                    } label: {
                        Image(systemName: "doc.plaintext")
                            .padding()
                            .foregroundColor(.black)
                            .background(.green.opacity(0.7))
                            .clipShape(Circle())
                            .cornerRadius(10)
                    }
                }
            }
            .sheet(isPresented: $vm.isShowingPointsHistory) {
                PointsHistoryView(vm: vm)
            }
            .onReceive(vm.timer) { time in
                if vm.timeRemaining >= 10 {
                    vm.rollingDiceState = .showDiceView
                } else if vm.timeRemaining >= 5  {
                    vm.rollingDiceState = .showPointText
                    feedback.prepare()
                } else if vm.timeRemaining >= 0 {
                    vm.rollingDiceState = .shakeDice
                    feedback.notificationOccurred(.warning)
                }
                vm.timeRemaining += 1
            }
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
