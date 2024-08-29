import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var currentOperation: Operation? = nil
    @State private var previousValue: Double? = nil
    @State private var history: [String] = []
    @State private var showHistory = false

    enum Operation {
        case addition, subtraction, multiplication, division
    }

    var body: some View {
        VStack {
            Spacer()
            
            // Display Area
            Text(display)
                .font(.largeTitle)
                .padding()
            
            // Calculator Buttons
            VStack(spacing: 10) {
                buttonRow("7", "8", "9", "/")
                buttonRow("4", "5", "6", "*")
                buttonRow("1", "2", "3", "-")
                buttonRow("0", "C", "=", "+")
            }
            .font(.title)
            .buttonStyle(BorderlessButtonStyle())
            .padding()
            
            // History Button
            Button(action: { self.showHistory.toggle() }) {
                Text("History")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            if showHistory {
                HistoryView(history: $history)
            }
        }
    }

    // Creates a row of calculator buttons
    private func buttonRow(_ button1: String, _ button2: String, _ button3: String, _ button4: String) -> some View {
        HStack {
            calculatorButton(button1)
            calculatorButton(button2)
            calculatorButton(button3)
            calculatorButton(button4)
        }
    }

    // Creates a single calculator button
    private func calculatorButton(_ title: String) -> some View {
        Button(action: {
            self.buttonAction(title)
        }) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }

    // Handles button actions
    private func buttonAction(_ title: String) {
        switch title {
        case "C":
            clear()
        case "=":
            calculateResult()
        case "+", "-", "*", "/":
            operationPressed(title)
        default:
            numberPressed(title)
        }
    }

    // Processes number button presses
    private func numberPressed(_ number: String) {
        if display == "0" || display == "Error" {
            display = number
        } else {
            display += number
        }
    }

    // Clears the calculator
    private func clear() {
        display = "0"
        currentOperation = nil
        previousValue = nil
    }

    // Processes operation button presses
    private func operationPressed(_ operation: String) {
        if let value = Double(display) {
            previousValue = value
            display = "0"
            currentOperation = Operation(from: operation)
        }
    }

    // Calculates the result based on the current operation
    private func calculateResult() {
        // Ensure previousValue and currentValue are not nil
        guard let previousValue = previousValue, let currentValue = Double(display) else {
            display = "Error"
            return
        }
        
        let result: Double?
        
        // Perform the calculation based on the operation
        switch currentOperation {
        case .addition:
            result = previousValue + currentValue
        case .subtraction:
            result = previousValue - currentValue
        case .multiplication:
            result = previousValue * currentValue
        case .division:
            result = currentValue != 0 ? previousValue / currentValue : nil
        default:
            result = nil
        }
        
        // Update the display with the result or an error message
        if let result = result {
            let resultString = String(result)
            display = resultString
            history.append("\(previousValue) \(operationSymbol()) \(currentValue) = \(resultString)")
        } else {
            display = "Error"
        }
        
        // Reset the operation and previous value
        self.previousValue = nil
        self.currentOperation = nil
    }

    // Returns the operation symbol as a string
    private func operationSymbol() -> String {
        switch currentOperation {
        case .addition:
            return "+"
        case .subtraction:
            return "-"
        case .multiplication:
            return "*"
        case .division:
            return "/"
        default:
            return ""
        }
    }
}

// Converts string operation symbols to enum cases
private extension ContentView.Operation {
    init?(from string: String) {
        switch string {
        case "+":
            self = .addition
        case "-":
            self = .subtraction
        case "*":
            self = .multiplication
        case "/":
            self = .division
        default:
            return nil
        }
    }
}

// View to display calculation history
struct HistoryView: View {
    @Binding var history: [String]
    
    var body: some View {
        List(history, id: \.self) { entry in
            Text(entry)
                .padding()
        }
        .frame(maxHeight: 200) // Adjust height as needed
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
