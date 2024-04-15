//
//  ContentView.swift
//  WiseQuacks
//
//  Created by SPRING, SEAN on 4/15/24.
//

import SwiftUI

@State var ducks
@State var insults

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: callTheDucks){
                Text("Hit Me!")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            }.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(5.0)
                .background(Color.gray)
                .padding()
        }
        .padding()
    }
    func callTheDucks(){
        if let apiURL =
            URL(string:"https://random-d.uk/api/v2/randomimg"){
            var request = URLRequest(url:apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request){
                data, response, error in
                if let duckData = data{
                    if let ducksFromAPI = try?
                        JSONDecoder().decode(Result.self, from: duckData){
                        ducks = ducksFromAPI.items
                        print(ducks)
                    }
                }
            }.resume()
        }
        insultMe()
    }
    func insultMe(){
        if let apiURL =
            URL(string:"https://evilinsult.com/generate_insult.php?lang=en&type=json"){
            var request = URLRequest(url:apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request){
                data, response, error in
                if let insultData = data{
                    if let insultsFromAPI = try?
                        JSONDecoder().decode(Result.self, from: insultData){
                        insults = insultsFromAPI.items
                        print(insults)
    }
}

#Preview {
    ContentView()
}
