//
//  ContentView.swift
//  BetterRest
//
//  Created by Chaher Machhour on 03/01/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUP = Date.now
    
    var body: some View {
        DatePicker("Please enter a date", selection: $wakeUP, in: Date.now...)
            .labelsHidden()
    }
    
    func exemplesDates() {
//        var components = DateComponents()
//        components.hour = 8
//        components.minute = 0
//        let date = Calendar.current.date(from: components) ?? .now
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
    }
}

#Preview {
    ContentView()
}
