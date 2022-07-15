//
//  RollDiceResultSides4.swift
//  Day95_RollDice
//
//  Created by Lee McCormick on 7/13/22.
//

import SwiftUI

// MARK: - StartRollingView
struct StartRollingView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.black.opacity(0.7))
                .padding()
                .shadow(radius: 10)
            VStack {
                Text("START")
                Text("ROLLING")
                Text("DICE")
            }
            .font(.largeTitle.bold())
            .foregroundColor(.white)
            .padding()
            .multilineTextAlignment(.center)
        }
    }
}

// MARK: - HStatcksWithCirclesView
struct HStatcksWithCirclesView: View {
    let numberOfHStacks: Int
    let withCircles: Int
    var body: some View {
        ForEach(0..<numberOfHStacks, id: \.self) { _ in
            HStack(spacing: 20) {
                ForEach(0..<withCircles, id: \.self) { _ in
                    Circle().fill(.black)
                }
            }
        }
    }
}

// MARK: - VStatckWithCircleView
struct VStatckWithCircleView: View {
    var body: some View {
        VStack(spacing: 20) {
            Circle().fill(.black)
        }
    }
}

// MARK: - RollDiceResultView
struct RollDiceResultView: View {
    @Binding var random: Int
    
    // MARK: - Body
    var body: some View {
        VStack {
            switch random {
            case 1:
                VStack {
                    Circle().fill(.black)
                }
                .padding(80)
            case 2:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                }
                .padding()
            case 3:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    VStatckWithCircleView()
                }
                .padding()
            case 4:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 2, withCircles: 2)
                }
                .padding()
            case 5:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    VStatckWithCircleView()
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                }
                .padding()
            case 6:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 2)
                }
                .padding()
            case 7:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 2)
                    VStatckWithCircleView()
                }
                .padding()
            case 8:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 4, withCircles: 2)
                }
                .padding()
            case 9:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 3)
                }
                .padding()
            case 10:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 2, withCircles: 5)
                }
                .padding()
            case 11:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 2, withCircles: 5)
                    VStatckWithCircleView()
                }
                .padding()
            case 12:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 4)
                }
                .padding()
            case 13:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 4)
                    VStatckWithCircleView()
                }
                .padding()
            case 14:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 4)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                }
                .padding()
            case 15:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 5)
                }
                .padding()
            case 16:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 4, withCircles: 4)
                }
                .padding()
            case 17:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 4, withCircles: 4)
                    VStatckWithCircleView()
                }
                .padding()
            case 18:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 5)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                }
                .padding()
            case 19:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 5)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                }
                .padding()
            case 20:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 4)
                }
                .padding()
            case 21:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 4)
                    VStatckWithCircleView()
                }
                .padding()
            case 22:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 4)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                }
                .padding()
            case 23:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 4)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                }
                .padding()
            case 24:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 4)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                }
                .padding()
            case 25:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 5)
                }
                .padding()
            case 26:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 5)
                    VStatckWithCircleView()
                }
                .padding()
            case 27:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 5)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                }
                .padding()
            case 28:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 5)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                }
                .padding()
            case 29:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 5)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                }
                .padding()
            case 30:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 6)
                }
                .padding()
            case 31:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 10)
                    VStatckWithCircleView()
                }
                .padding()
            case 32, 33, 34, 35:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 10)
                    if random == 32 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    } else if random == 33 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    }else if random == 34 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    }else if random == 35 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    }
                }
                .padding()
            case 36, 37, 38, 39:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 3, withCircles: 10)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    if random == 36 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 1)
                    } else if random == 37 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    }else if random == 38 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    }else if random == 39 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    }
                }
                .padding()
            case 40:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 4, withCircles: 10)
                }
                .padding()
            case 41:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 4, withCircles: 10)
                    VStatckWithCircleView()
                }
                .padding()
            case 42, 43, 44, 45:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 4, withCircles: 10)
                    if random == 42 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    } else if random == 43 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    }else if random == 44 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    }else if random == 45 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    }
                }
                .padding()
            case 46, 47, 48, 49:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 4, withCircles: 10)
                    HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    if random == 46 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 1)
                    } else if random == 47 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    }else if random == 48 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    }else if random == 49 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    }
                }
                .padding()
            case 50:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 10)
                }
                .padding()
            case 51, 52, 53, 54, 55, 56, 57, 58, 59:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 5, withCircles: 10)
                    if random == 51 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 1)
                    } else if random == 52 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    } else if random == 53 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    } else if random == 54 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    } else if random == 55 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    } else if random == 56 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 6)
                    } else if random == 57 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 7)
                    } else if random == 58 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 8)
                    } else if random == 59 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 9)
                    }
                }
                .padding()
            case 60:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 6, withCircles: 10)
                }
                .padding()
            case 61, 62, 63, 64, 65, 66, 67, 68, 69:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 6, withCircles: 10)
                    if random == 61 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 1)
                    } else if random == 62 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    } else if random == 63 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    } else if random == 64 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    } else if random == 65 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    } else if random == 66 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 6)
                    } else if random == 67 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 7)
                    } else if random == 68 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 8)
                    } else if random == 69 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 9)
                    }
                }
                .padding()
            case 70:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 7, withCircles: 10)
                }
                .padding()
            case 71, 72, 73, 74, 75, 76, 77, 78, 79:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 7, withCircles: 10)
                    if random == 71 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 1)
                    } else if random == 72 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    } else if random == 73 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    } else if random == 74 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    } else if random == 75 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    } else if random == 76 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 6)
                    } else if random == 77 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 7)
                    } else if random == 78 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 8)
                    } else if random == 79 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 9)
                    }
                }
                .padding()
            case 80:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 8, withCircles: 10)
                }
                .padding()
            case 81, 82, 83, 84, 85, 86, 87, 88, 89:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 8, withCircles: 10)
                    if random == 81 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 1)
                    } else if random == 82 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    } else if random == 83 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    } else if random == 84 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    } else if random == 85 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    } else if random == 86 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 6)
                    } else if random == 87 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 7)
                    } else if random == 88 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 8)
                    } else if random == 89 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 9)
                    }
                }
                .padding()
            case 90:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 9, withCircles: 10)
                }
                .padding()
            case 91, 92, 93, 94, 95, 96, 97, 98, 99:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 9, withCircles: 10)
                    if random == 91 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 1)
                    } else if random == 92 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 2)
                    } else if random == 93 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 3)
                    } else if random == 94 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 4)
                    } else if random == 95 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 5)
                    } else if random == 96 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 6)
                    } else if random == 97 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 7)
                    } else if random == 98 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 8)
                    } else if random == 99 {
                        HStatcksWithCirclesView(numberOfHStacks: 1, withCircles: 9)
                    }
                }
                .padding()
            case 100:
                VStack {
                    HStatcksWithCirclesView(numberOfHStacks: 10, withCircles: 10)
                }
                .padding()
            default:
                StartRollingView()
            }
        }
        .frame(width: 300, height: 300)
    }
}

// MARK: - PreviewProvider
struct RollDiceResultSides4_Previews: PreviewProvider {
    @State static var testRandom = 10
    static var previews: some View {
        RollDiceResultView(random: $testRandom)
            .previewInterfaceOrientation(.portrait)
    }
}
