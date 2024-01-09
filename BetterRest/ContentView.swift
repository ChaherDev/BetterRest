//
//  ContentView.swift
//  BetterRest
//
//  Created by Chaher Machhour on 03/01/2024.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var sleepTime: Date = defaultSleepTime
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    static var defaultSleepTime: Date {
        var components = DateComponents()
        components.hour = 21
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                Section("Daily coffee intake") {
                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                }
                Section("Desired amount of sleep") {
                    Picker("\(sleepAmount.formatted()) hours", selection: $sleepAmount) {
                        ForEach(Array(stride(from: 4.0, through: 12.0, by: 0.25)), id: \.self) { value in
                            Text("\(value, specifier: "%.2f") hours").tag(value)
                        }
                    }
                }
                Section("Daily coffee intake") {
                    Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
            }
            Text("Your ideal bedtime is \(sleepTime.formatted(date: .omitted, time: .shortened))")
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculatedBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Ok") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculatedBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(Double(coffeeAmount)))
            
            let sleepTimeCalculated = wakeUp - prediction.actualSleep
            self.sleepTime = sleepTimeCalculated
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTimeCalculated.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, thre was a problem calculating your bedtime"
        }
        
        showingAlert = true
    }
    
}
#Preview {
    ContentView()
}
