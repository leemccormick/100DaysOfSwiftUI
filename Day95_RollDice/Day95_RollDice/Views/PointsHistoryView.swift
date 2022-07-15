//
//  PointsHistoryView.swift
//  Day95_RollDice
//
//  Created by Lee McCormick on 7/14/22.
//

import SwiftUI

// MARK: - PointsHistoryView
struct PointsHistoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: DiceViewModel
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Color Background
            Color.init(hex: "357C3C")
                .ignoresSafeArea()
            
            // Dismiss Button
            HStack {
                Spacer()
                VStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle")
                            .padding()
                            .foregroundColor(.black)
                            .background(.green.opacity(0.7))
                            .clipShape(Circle())
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            .padding()
            
            // Point History View
            VStack {
                Spacer()
                // Point History Titel Text
                Text("Points History")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(.black)
                    .cornerRadius(6)
                    .shadow(radius: 10)
                    .padding([.bottom], 30)
                
                // List of Dices Data View
                ScrollView {
                    if vm.dicesData.isEmpty {
                        VStack {
                            Text("No Dice Game History Found !")
                                .font(.largeTitle.bold())
                                .frame(height: 300)
                                .padding()
                        }
                    } else {
                        // Titles
                        HStack(spacing: 20) {
                            Text("Points")
                                .font(.title3)
                                .frame(width: 60)
                            Text("Sides")
                                .font(.title3)
                                .frame(width: 50)
                            Text("Date Time")
                                .font(.title3)
                                .frame(width: 150)
                        }
                        .padding()
                        .background(.black.opacity(0.2))
                        
                        // List
                        ForEach(vm.dicesData) { data in
                            HStack(spacing: 20) {
                                Text("\(data.points)")
                                    .font(.title3)
                                    .frame(width: 50)
                                Text("|")
                                    .font(.title3)
                                Text("\(data.sides)")
                                    .font(.title3)
                                    .frame(width: 50)
                                Text(data.dateTime.formatted(date: .numeric, time: .shortened))
                                    .font(.subheadline)
                                    .frame(width: 150)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
                    }
                }
                .frame(height: 350)
                .padding([.top], 20)
                .background(.green)
                .cornerRadius(10)
                .shadow(radius: 10)
                
                // Total Point Detail View
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
                .padding([.top], 30)
                Spacer()
            }
        }
    }
}

// MARK: - PreviewProvider
struct PointsHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PointsHistoryView(vm: DiceViewModel())
    }
}
