//
//  ContentView.swift
//  Inc&Exp
//
//  Created by Dobrovsky on 14.07.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var currentDate = Date()
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }
    
    private func daysInMonth() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        
        return range.compactMap {day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }
    
    var body: some View {
        VStack{
            Text(monthFormatter.string(from: currentDate))
                .font(.title)
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth(), id: \.self) { date in
                    Text("\(Calendar.current.component(.day, from: date))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            Spacer()
        }
        .padding()
    }
}


/// Добавление событий
import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
}

struct EventView: View {
    @State private var currentDate = Date()
    @State private var events: [Event] = []
    @State private var selectedDate: Date?
    @State private var newEventTitle: String = ""
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter;
    }
    
    private func daysInMonth() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }
    
    private func changeMonth(by offset: Int) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: offset, to: currentDate) else { return }
        currentDate = newDate
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Text("Пред.")
                }
                
                Text(monthFormatter.string(from: currentDate))
                    .font(.title)
                    .padding()
                
                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Text("След.")
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth(), id: \.self) { date in
                    VStack {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .onTapGesture {
                                selectedDate = date
                            }
                        
                        if let event = events.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                            Text(event.title)
                                .font(.caption)
                                .padding(2)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .padding()
            
            if let selectedDate = selectedDate {
                VStack {
                    Text("Добавить событие для \(selectedDate, formatter: monthFormatter)")
                        .font(.headline)
                    
                    TextField("Название события", text: $newEventTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Добавить событие") {
                        let newEvent = Event(date: selectedDate, title: newEventTitle)
                        events.append(newEvent)
                        self.newEventTitle = ""
                    }
                    .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            }
        }
    }
}

@main
struct CustomCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}





#Preview {
    ContentView()
}
