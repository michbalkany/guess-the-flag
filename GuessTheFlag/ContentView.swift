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
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
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
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                            
                        }
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
