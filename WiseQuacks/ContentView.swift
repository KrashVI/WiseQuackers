//
//  ContentView.swift
//  WiseQuacks
//
//  Created by SPRING, SEAN on 4/15/24.
//

import SwiftUI
import Foundation

struct Duck: Decodable{
    public var url: String
    public var message: String
}

//struct Result: Decodable {
//    var ducks: [Duck]
//}

struct Insult: Decodable{
    public var insult: String
    public var number: String
}

//struct ResultTwo: Decodable{
//    var insults: [Insult]
//}

struct ContentView: View {
    @State var ducksFinal: [Duck] = []
    @State var insultsFinal: [Insult] = []
    @State var yes = true
    var body: some View {
        NavigationStack{
            Text("Wise Quacks")
            if ducksFinal.count == 0{
                VStack{
                    ProgressView().padding()
                        .foregroundStyle(Color.yellow)
                        .onAppear{
                            callTheDucks()
                            insultMe()
                        }
                }
            }else{
                ForEach(ducksFinal, id:\.message){ duck in
                    Image(duck.url)
                        VStack {
                            AsyncImage(url:URL(string: duck.url)){ response in
                                switch response {
                                case .success(let image):
                                    image.resizable()
                                        .frame(width:150, height:150)
                                default:
                                    Image(systemName: "nosign")
                                }
                            }
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        }
                    }
                ForEach(insultsFinal, id:\.number){insult in
                    Text(insult.insult)
                }
            }
            Button(action: {callTheDucks()}){
                Text("Duck It!")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            }.border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(5.0)
                .background(Color.gray)
                .padding()
            Button(action: {insultMe()}){
                Text("Insult Me!")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            }.border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(5.0)
                .background(Color.gray)
                .padding()
        }
    }
    func callTheDucks(){
        if let apiURL = URL(string:"https://random-d.uk/api/v2/quack")
        {
            var request = URLRequest(url:apiURL)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request)
            {
                data, response, error in
                if let duckData = data
                {
                    do{
                        if let ducksFromAPI = try?
                            JSONDecoder().decode(Duck.self, from: duckData)
                        {
                            ducksFinal = [ducksFromAPI]
                            print(ducksFinal)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func insultMe(){
        if let apiURL = URL(string:"https://evilinsult.com/generate_insult.php?lang=en&type=json")
        {
            var request = URLRequest(url:apiURL)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request)
            {
                data, response, error in
                if let insultData = data
                {
                    do{
                        if let insultsFromAPI = try?
                            JSONDecoder().decode(Insult.self, from: insultData)
                        {
                            insultsFinal = [insultsFromAPI]
                            print(insultsFinal)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
#Preview {
    ContentView()
}
