//
//  JSONfile.swift
//  Inc&Exp
//
//  Created by Dobrovsky on 16.07.2024.
//

import SwiftUI
import Foundation

// Структура для представления данных JSON
struct Person: Codable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
}

class apiCall {
    func getUserComments(completion:@escaping ([Person]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let person = try JSONDecoder().decode([Person].self, from: data)
                print(person)
                
                DispatchQueue.main.async {
                    completion(person)
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }
        .resume()
    }
}

struct JSONView: View {
    
    @State var person = [Person]()
    
    var body: some View {
        NavigationView {
            List(person) { persone in
                VStack(alignment: .leading) {
                    Text(persone.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(persone.username)
                        .font(.title)
                    Text(persone.email)
                        .font(.title)
                }
            }
            .onAppear {
                apiCall().getUserComments { (person) in
                    self.person = person
                }
            }
            .navigationTitle("Albums")
        }
    }
}





#Preview {
    JSONView()
}

