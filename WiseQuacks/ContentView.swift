//
//  ContentView.swift
//  WiseQuacks
//
//  Created by SPRING, SEAN on 4/15/24.
//

import SwiftUI

struct Duck: Codable{
    public var url: String
    public var message: String
}

struct Result: Codable {
    var ducks: [Duck]
}

struct Insult: Codable{
    public var insult: String
}

struct ResultTwo: Codable{
    var insults: [Insult]
}

struct ContentView: View {
    @State var ducksFinal: [Duck] = []
    @State var insultsFinal: [Insult] = []
    @State var yes = true
    var body: some View {
        NavigationStack{
            if ducksFinal.count == 0{
                VStack{
                    ProgressView().padding()
                    Text("Wise Quacks")
                        .foregroundStyle(Color.yellow)
                        .onAppear{
                            callTheDucks()
//                            insultMe()
                        }
                }
            }else{
                List(ducksFinal, id:\.message){ duck in
                    Link(destination:URL(string:duck.url)!){
                        VStack {
                            AsyncImage(url:URL(string: duck.url)){ response in
                                switch response {
                                case .success(let image):
                                    image.resizable()
                                        .frame(width:50, height:50)
                                default:
                                    Image(systemName: "nosign")
                                }
                            }
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                            Text("Hello, world!")
                        }
                    }
                }
                .padding()
            }
            Button(action: {[callTheDucks()/*, insultMe()*/]}){
                Text("Hit Me!")
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
        if let apiURL =
            URL(string:"https://random-d.uk/api/v2/randomimg"){
            var request = URLRequest(url:apiURL)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request){
                data, response, error in
                if let duckData = data{
                    if let ducksFromAPI = try? JSONDecoder().decode(Result.self, from: duckData){
                        ducksFinal = ducksFromAPI.ducks
                        print(ducksFinal)
                        print(ducksFinal.count)
                    }
                }
            }.resume()
        }
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
                        JSONDecoder().decode(ResultTwo.self, from: insultData){
                        insultsFinal = insultsFromAPI.insults
                        print(insultsFinal)
                    }
                }
            }.resume()
        }
    }
}
#Preview {
    ContentView()
}
