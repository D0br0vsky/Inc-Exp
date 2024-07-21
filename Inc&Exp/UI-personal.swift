//
//  UI-personal.swift
//  Inc&Exp
//
//  Created by Dobrovsky on 16.07.2024.
//

import SwiftUI

struct BaseForWeather: View {
    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 90, height: 90)
            .cornerRadius(20)
    }
}

struct BaseForGraphic: View {
    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 350, height: 250)
            .cornerRadius(20)
    }
}



//
//struct JSONTest: View {
//    @EnvironmentObject var personData: PersonData
//    
//    var body: some View {
//        
//        NavigationView {
//            List(personData) { persone in
//                VStack(alignment: .leading) {
//                    
//                    Rectangle()
//                        .frame(width: 350, height: 250)
//                    Text(persone.name)
//                        .font(.title)
//                        .fontWeight(.bold)
//                    Text(persone.username)
//                        .font(.title)
//                    Text(persone.email)
//                        .font(.title)
//                }
//            }
//            .navigationTitle("Albums")
//        }
//    }
//}
