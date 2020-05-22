//
//  ContentView.swift
//  calculator
//
//  Created by Brian Sakhuja on 5/1/20.
//  Copyright © 2020 Brian Sakhuja. All rights reserved.
//

import SwiftUI

// MARK: - Calculator Button Enum


/// Calculator Button
enum CalculatorButton {
    case zero, one, two, three, four, five, six, seven, eight, nine, decimal
    case equals, plus, minus, multiply, divide
    case ac, plusMinus, percent
    
    var title: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .decimal: return "."
        case .equals: return "="
        case .plus: return "+"
        case .minus: return "-"
        case .multiply: return "×"
        case .divide: return "÷"
        case .ac: return "AC"
        case .plusMinus: return "±"
        case .percent: return "%"
        }
    }
    
    var value: Double {
        switch self {
        case .zero: return 0
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        default: return -1
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal:
            return Color(.darkGray)
        case .equals, .plus, .minus, .multiply, .divide:
            return  Color(.orange)
        case .ac, .plusMinus, .percent:
            return Color(.lightGray)
        }
    }
    
    var buttonWidth: CGFloat {
        switch self {
        case .zero: return 160.0
        default: return 80.0
        }
    }
    
    var buttonHeight: CGFloat {
        return 80.0
    }
}

// MARK: - Environment Object

/// Environment object
class GlobalEnvironment: ObservableObject {
    
    @Published var display = "0"
    let calculatorLogic = CalculatorLogic()
    private var userIsTyping = false
    private var hasDecimalPoint = false
    
    var displayValue: Double {
        get {
            guard let double = Double(display) else { return 0.0 }
            return double
        } set {
            display = String(newValue)
        }
    }
    
    func buttonTapped(button: CalculatorButton) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            if userIsTyping {
                display += button.title
            } else {
                display = button.title
                userIsTyping = true
            }
        case .decimal:
            if !hasDecimalPoint {
                if userIsTyping {
                    display += button.title
                } else {
                    display = "0."
                    userIsTyping  = true
                    hasDecimalPoint = true
                }
            }
        case .plus, .minus, .multiply, .divide, .plusMinus, .percent, .equals:
            if userIsTyping {
                calculatorLogic.setOperand(operand: displayValue)
                userIsTyping = false
                hasDecimalPoint = false
            }
            
            calculatorLogic.performOperation(buttonType: button)
            displayValue = calculatorLogic.result
        case .ac:
            display = "0"
            userIsTyping = false
            hasDecimalPoint = false
            calculatorLogic.clear()
        }
    }
}

// MARK: - Content View

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment
    
    let buttons: [[CalculatorButton]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals],
    ]
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12.0) {
                HStack {
                    Spacer()
                    Text(env.display)
                        .foregroundColor(.white)
                        .font(.system(size: 64.0))
                }.padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12.0) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button)
                        }
                    }
                    
                }
                
            }.padding(.bottom)
        }
    }
}

// MARK: - Calculator Button View

struct CalculatorButtonView: View {
    
    var button: CalculatorButton
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        Button(action: {
            self.env.buttonTapped(button: self.button)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: button.buttonHeight)
                    .foregroundColor(button.backgroundColor)
                    .frame(width: button.buttonWidth, height: button.buttonHeight)
                Text(button.title)
                    .font(.system(size: 32.0))
                    .foregroundColor(.white)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}
