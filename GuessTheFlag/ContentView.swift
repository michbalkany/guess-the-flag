//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mich balkany on 9/14/23.
//

import SwiftUI


struct ContentView: View {
    
    @State private var questionCounter = 1
    @State private var showingScore = false
    @State private var showingResult = false
    @State private var scoreTitle = ""
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userScore = 0
    @State private var selectedFlag = -1
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red:0.1, green: 0.2, blue: 0.4), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3) { number in
                        Button {
                            
                                flagTapped(number)
                            
                            } label: {
                                FlagImage(name: countries[number])
                            }
                            .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                            .rotation3DEffect(
                            .degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0)
                        )
                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.25)
                        .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                        .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 2)
                        .animation(.default, value: selectedFlag)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    Spacer()
                    Spacer()
                    
                    Text("Score: \(userScore)")
                        .foregroundColor(.white)
                        .font(.title.bold())
                    
                    Spacer()
                }
                .padding()
            }
            .alert(scoreTitle, isPresented:  $showingScore){
                Button("continue", action: askQuestion)
            } message: {
                Text("Your score is \(userScore)")
            }
            .alert("Game Over", isPresented:  $showingResult){
                Button("New Game", action: newGame)
            } message: {
                Text("Your final score was \(userScore)")
                
            }
        }
        func flagTapped(_ number: Int){
            if number == correctAnswer {
                scoreTitle = "correct"
                userScore += 1
            } else {
                let needThe = ["UK", "US"]
                let theirAnswer = countries[number]
                if needThe.contains(theirAnswer){
                    scoreTitle = "Wrong! that is the flag of the \(countries[number])"
                } else{
                    scoreTitle = "Wrong! that is the flag of \(countries[number])"
                }
                if userScore > 0{
                    userScore -= 1
                }
            }
            
            selectedFlag = number
            
            if questionCounter == 8{
                showingResult = true
            }else{
                showingScore = true
            }
        }
        func askQuestion(){
            countries.remove(at: correctAnswer)
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            questionCounter += 1
            selectedFlag = -1
        }
        func newGame(){
            questionCounter = 0
            userScore = 0
            countries = Self.allCountries
            askQuestion()
            
        }
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

