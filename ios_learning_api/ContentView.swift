//
//  ContentView.swift
//  ios_learning_api
//
//  Created by jackson mowatt gok on 20/10/2023.
//

import SwiftUI

struct Course: Hashable, Codable {
    let name: String
    let image: String
}

class ViewModel: ObservableObject {
    @Published var courses: [Course] = []
    
    func fetch () {
        guard let url = URL(string: "https://iosacademy.io/api/v1/courses/index.php") else{ return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Convert to JSON
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self?.courses = courses
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView{
            List {
                ForEach(viewModel.courses, id: \.self) { course in
                    HStack {
                        Image("")
                            .frame(width: 130, height: 70)
                            .background(Color.gray)
                        Text(course.name)
                            .bold()
                    }
                    .padding(3)
                }
            }
            .navigationTitle("Courses")
            .onAppear {
                viewModel.fetch()
            }
        }
    }
}

#Preview {
    ContentView()
}
