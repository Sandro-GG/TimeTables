//
//  ContentView.swift
//  TimesTables
//
//  Created by Sandro Gakharia on 21.07.25.
//

import SwiftUI

struct Question {
    var left: Int
    var right: Int
    var answer: Int {
        left * right
    }
}

struct ContentView: View {
    @State private var gameActive = false
    @State private var maxNumber = 1
    @State private var questionCount = 5
    let questionAmounts = [5, 10, 20]
    @State private var questions = [Question(left: 1, right: 1)]
    @State private var answer: Int? = nil
    @FocusState private var answerFocused: Bool
    @State private var currentQuestion = 0
    @State private var userScore = 0
    @State private var showingScore = false
    @State private var animationAmount = 1.0
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.8, blue: 0.4),   // Soft Orange
                        Color(red: 1.0, green: 0.6, blue: 0.6),   // Coral Pink
                        Color(red: 0.9, green: 0.7, blue: 1.0)    // Lavender
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if !gameActive {
                    VStack {
                        Spacer()
                        
                        Section {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Max Multiplication Table")
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.8))

                                Stepper("Up to \(maxNumber)", value: $maxNumber, in: 1...10)
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(colors: [
                                    Color(red: 0.4, green: 0.5, blue: 0.9),
                                    Color(red: 0.3, green: 0.4, blue: 0.8)
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal)

                        Spacer()
                        Section("Number of questions") {
                            Picker("Number of questions", selection: $questionCount) {
                                ForEach(questionAmounts, id: \.self) { amount in
                                    Text("\(amount)")
                                        .font(.headline)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(.white)
                            .padding(20)
                            .frame(width: 300, height: 50)
                            .background(Color(red: 0.4, green: 0.5, blue: 0.9))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(.white.opacity(0.8), lineWidth: 2))

                        }
                        .foregroundStyle(.white)
                        .font(.title2.bold())
                        
                        
                        Spacer()
                        
                        Button("Start Game") {
                            startGame()
                        }
                        .frame(width: 200, height: 100)
                        .background(Color(red: 0.4, green: 0.5, blue: 0.9))
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(red: 0.4, green: 0.5, blue: 0.9), lineWidth: 2)
                                .scaleEffect(animationAmount)
                                .opacity(2 - animationAmount)
                        )
                        .onAppear {
                            withAnimation(
                                .easeOut(duration: 1).repeatForever(autoreverses: false)
                            ) {
                                animationAmount = 2
                            }
                        }
                        .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 4)
                        
                        Spacer()
                        Spacer()
                    }
                    .navigationTitle("Time Tables Exercise")
                } else {
                    VStack {
                        Section {
                            Spacer()
                            
                            Text("Question \(currentQuestion + 1)/\(questionCount):")
                                .frame(width: 200, height: 70)
                                .background(
                                    LinearGradient(colors: [
                                        Color(red: 0.4, green: 0.5, blue: 0.9),
                                        Color(red: 0.3, green: 0.4, blue: 0.8)
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(.rect(cornerRadius: 20))
                                .font(.title.bold())
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            HStack {
                                Text("\(questions[currentQuestion].left) x \(questions[currentQuestion].right)  =")
                                Spacer()
                                TextField("", value: $answer, format: .number)
                                    .keyboardType(.decimalPad)
                                    .focused($answerFocused)
                                    .frame(width: 100, height: 50)
                                    .background(.white)
                                    .clipShape(.rect(cornerRadius: 10))
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(20)
                            .font(.title.bold())
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 70)
                            .background(
                                LinearGradient(colors: [
                                    Color(red: 0.4, green: 0.5, blue: 0.9),
                                    Color(red: 0.3, green: 0.4, blue: 0.8)
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(.rect(cornerRadius: 20))
                            
                            Spacer()
                            
                            Text("Score: \(userScore)")
                                .frame(width: 150, height: 70)
                                .background(
                                    LinearGradient(colors: [
                                        Color(red: 0.4, green: 0.5, blue: 0.9),
                                        Color(red: 0.3, green: 0.4, blue: 0.8)
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(.capsule)
                                .font(.title.bold())
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Button("Next") {
                                answerFocused = true
                                if answer == questions[currentQuestion].answer {
                                    userScore += 1
                                }
                                
                                if currentQuestion + 1 < questions.count {
                                    currentQuestion += 1
                                    answerFocused = true
                                } else {
                                    showingScore = true
                                }
                                answer = nil
                            }
                            .frame(width: 120, height: 70)
                            .background(
                                LinearGradient(colors: [
                                    Color(red: 0.4, green: 0.5, blue: 0.9),
                                    Color(red: 0.3, green: 0.4, blue: 0.8)
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(.capsule)
                            .font(.title.bold())
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 4)
                            
                            Spacer()
                        }
                        
                    }
                    .alert("Game Over!", isPresented: $showingScore) {
                        Button("Restart") {
                            gameActive = false
                        }
                    } message: {
                        Text("You scored \(userScore)/\(questionCount)")
                    }
                    .navigationTitle("Times Table Exercise")
                }
            }
            .animation(.easeInOut, value: gameActive)
        }
    }
    
    func startGame() {
        userScore = 0
        currentQuestion = 0
        questions = []
        
        for _ in 0..<questionCount {
            questions.append(Question(left: Int.random(in: 1...maxNumber), right: Int.random(in: 1...maxNumber)))
        }
        
        withAnimation {
            gameActive = true
        }
        
        answerFocused = true
    }
}

#Preview {
    ContentView()
}
