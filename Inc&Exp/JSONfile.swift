//
//  JSONfile.swift
//  Inc&Exp
//
//  Created by Dobrovsky on 16.07.2024.
//

import SwiftUI
import Foundation

// Структура для представления данных JSON для пользователей
struct Person: Codable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
}

// Класс для выполнения API вызова и хранения данных об пользователях
class PersonData: ObservableObject {
    @Published var persons: [Person] = []
    
    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let persons = try JSONDecoder().decode([Person].self, from: data)
                print(persons)
                
                DispatchQueue.main.async {
                    self.persons = persons
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }
        .resume()
    }
}



// Структура для представления данных JSON для фото
struct Photo: Codable, Identifiable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}


// Класс для выполнения API вызова и хранения данных о фото пользователей
class PhotoData: ObservableObject {
    @Published var photos: [Photo] = []
    
    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                print(photos)
                
                DispatchQueue.main.async {
                    self.photos = photos
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }
        .resume()
    }
}













///This view for my cards with people
// Объединенная структура данных
struct UserWithPhoto: Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var photoURL: String
}

// View для отображения списка пользователей с фотографиями
struct JSONView: View {
    @StateObject private var personData = PersonData()
    @StateObject private var photoData = PhotoData()
    @State private var usersWithPhotos: [UserWithPhoto] = []
    
    var body: some View {
        NavigationView {
            List(usersWithPhotos) { user in
                HStack {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(user.username)
                            .font(.title)
                        Text(user.email)
                            .font(.title)
                    }
                    Spacer()
                    AsyncImage(url: URL(string: user.photoURL)) { image in
                        image.resizable()
                            .frame(width: 90, height: 90)
                            .cornerRadius(45)
                    } placeholder: {
                        ProgressView()
                    }
                }
                .padding()
            }
            .onAppear {
                fetchData()
            }
            //.navigationTitle("Users")
        }
    }
    private func fetchData() {
        personData.fetchUsers()
        photoData.fetchUsers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Добавлена задержка для ожидания загрузки данных
            let filteredPhotos = photoData.photos.filter { photo in
                personData.persons.contains(where: { $0.id == photo.id })
            }
            
            usersWithPhotos = personData.persons.compactMap { person in
                if let photo = filteredPhotos.first(where: { $0.id == person.id }) {
                    return UserWithPhoto(id: person.id, name: person.name, username: person.username, email: person.email, photoURL: photo.thumbnailUrl)
                }
                return nil
            }
            .sorted(by: { $0.id < $1.id })
        }
    }
}
















/*
struct JSONView: View {
    @StateObject private var personData = PersonData()
    @StateObject private var photoData = PhotoData()
    
    var body: some View {
        NavigationView {
            List(personData.persons.filter { $0.id == 3 }) { person in
                HStack{
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(person.username)
                            .font(.title)
                        Text(person.email)
                            .font(.title)
                    }
                    
                    Rectangle()
                        .frame(width: 90, height: 170)
                        .cornerRadius(20)
                }
            }
        }
        .onAppear {
            personData.fetchUsers()
        }
        // .navigationTitle("Users")
    }
}
*/






/*
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
 PersonData().getUserComments { (person) in
 self.person = person
 }
 }
 .navigationTitle("Albums")
 }
 }
 }
 */






#Preview {
    JSONView()
}

