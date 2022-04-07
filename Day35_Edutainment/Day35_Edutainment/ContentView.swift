//
//  ContentView.swift
//  Day35_Edutainment
//
//  Created by Lee McCormick on 4/4/22.
//

import SwiftUI

struct MutiplyQuestion : Hashable {
   // var numberOfQuestions = 5
 //   var levelSelection = 2
    let correctAnswer: Int
   // var userAnser = 0
    let firstNum : Int//= Int.random(in: 1...12)
    let secondNum : Int//= Int.random(in: 2...)

}

struct ContentView: View {
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundView = nil
        UITableViewCell.appearance().backgroundView = nil
    }
    
    @State private var numberOfDifficulty = 2
    @State private var numberOfQuestion = 5
    @State private var numberOfQuestions = [5, 10, 15, 20]
    @State private var score = 0
    @State private var answer = "0"
    @State private var questions = [MutiplyQuestion(correctAnswer: 0, firstNum: 0, secondNum: 0)]
    @State private var correctAnswers : [Int] = []
    @State private var currentQuestion = 0

    
    let letters = Array("EDUTAINMENT")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .orange]), center: .center)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Start Game") {
                        createQuestions(levelSelection: numberOfDifficulty, numberOfQuestion: numberOfQuestion)
                    }
                    .frame(width: 80, height: 80)
                    .background(enabled ? .orange : .pink)
                    .foregroundColor(.white)
                    .font(.headline)
                    .shadow(color: .brown, radius: 1, x: 1, y: 1)
                    .clipShape(RoundedRectangle(cornerRadius: 360))
                    
                    HStack(spacing: 0) {                    ForEach(0..<letters.count) { num in
                        Text(String(letters[num]))
                            .padding(3)
                            .font(.title)
                            .background(enabled ? .yellow : .red)
                            .offset(dragAmount)
                            .animation(.default.delay(Double(num) / 20), value: dragAmount)
                    }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { dragAmount = $0.translation }
                            .onEnded { _ in
                                dragAmount = .zero
                                enabled.toggle()
                            }
                    )
                }
                .padding(10)
                VStack {
                    VStack(alignment: .center, spacing: 20)
                    {
                        
                        HStack {
                            Image(systemName: "\(numberOfDifficulty).circle")
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50, alignment: .center)
                                .font(.largeTitle)
                            //.shadow(color: .brown, radius: 1, x: 1, y: 1)
                                .background(.white)
                                .cornerRadius(360)
                            
                            Text("Levels Of Mutiplication :")
                                .foregroundColor(.white)
                                .font(.headline)
                                .bold()
                                .shadow(color: .brown, radius: 1, x: 1, y: 1)
                            Stepper("Multiple up to \(numberOfDifficulty)", value: $numberOfDifficulty, in: 2...12, step: 1)
                                .labelsHidden()
                                .foregroundColor(.white)
                                .tint(.white)
                                .background(.white)
                                .cornerRadius(10)
                        }
                        HStack {
                            Image(systemName: "\(numberOfQuestion).circle")
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50, alignment: .center)
                                .font(.largeTitle)
                                .background(.white)
                                .cornerRadius(360)
                            Text("Questions : ")
                                .foregroundColor(.white)
                                .font(.headline)
                                .bold()
                                .shadow(color: .brown, radius: 1, x: 1, y: 1)
                            Picker("Number Of Questions : ", selection: $numberOfQuestion) {
                                ForEach (numberOfQuestions, id: \.self) {
                                    Text($0, format: .number)
                                }
                            }
                            .pickerStyle(.segmented)
                            .foregroundColor(.brown)
                            .tint(.red)
                            .background(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(20)
                    
                }
                
                HStack {
                    Text("\(questions[currentQuestion].firstNum)")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                        .bold()
                        .shadow(color: .brown, radius: 1, x: 1, y: 1)
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(.white)
                        .cornerRadius(10)
                    
                    Image(systemName: "multiply")
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50, alignment: .center)
                        .font(.largeTitle)
                    //.shadow(color: .brown, radius: 1, x: 1, y: 1)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(40)
                    
                    Text("\(questions[currentQuestion].secondNum)")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                        .bold()
                        .shadow(color: .brown, radius: 1, x: 1, y: 1)
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(.white)
                        .cornerRadius(10)
                    
                    
                }
                
                
                
                
                TextField("ANSWER", text: $answer)
                    .frame(width: 200, height: 50, alignment: .center)
                    .foregroundColor(.brown)
                    .keyboardType(.numberPad)
                    .background(.white)
                    .cornerRadius(10)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                
                List {
                    
                    Text("Score : \(score) of \(numberOfQuestion)")
                        .font(.subheadline)
                        .bold()
                        .frame(width: 300, height: 40, alignment: .center)
                    
                    
                    // .background(.yellow)
                    //  .cornerRadius(10)
                    
                    ForEach (questions, id: \.self) { q in
                        HStack {
                            Image(systemName: "questionmark.square")
                                .foregroundColor(.gray)
                            Image(systemName: "20.square")
                                .foregroundColor(.gray)
                            
                            
                            
                            Image(systemName: "x.circle")
                                .foregroundColor(.red)
                            
                            Text("7 x 8 = ")
                                .foregroundColor(.red)
                            Text(answer)
                            //Image(systemName: "1.circle")
                            //  Image(systemName: "checkmark.circle")
                                .foregroundColor(.red)
                            
                            Text("|")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                                .bold()
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                            Text("7 x 8 = ")
                                .foregroundColor(.green)
                            Text("56")
                                .foregroundColor(.green)
                            //Image(systemName: "1.circle")
                            
                            // Image(systemName: "x.circle")
                            //   .foregroundColor(.red)
                            
                        }
                    }
                    
                }
                .cornerRadius(10)
                
            }
        }
    }
    
    func createQuestions(levelSelection: Int, numberOfQuestion: Int) {
        questions = []
        currentQuestion = 0
        score = 0
        for _ in 1...numberOfQuestion {
            let firstNum = Int.random(in: 1...12)
            let secondNum = Int.random(in: 2...levelSelection)
            let newQuestion = MutiplyQuestion(correctAnswer: firstNum*secondNum, firstNum: firstNum, secondNum: secondNum)
            questions.append(newQuestion)
        }
        print("question count : \(questions.count)")
        print("question  : \(questions)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/* Challenge
 Before we proceed onto more complex projects, it’s important you have lots of time to stop and use what you already have. So, today you have a new project to make entirely by yourself, with no help from me other than some hints below. Are you ready?
 
 Your goal is to build an “edutainment” app for kids to help them practice multiplication tables – “what is 7 x 8?” and so on. Edutainment apps are educational at their code, but ideally have enough playfulness about them to make kids want to play.
 
 Breaking it down:
 
 The player needs to select which multiplication tables they want to practice. This could be pressing buttons, or it could be an “Up to…” stepper, going from 2 to 12.
 The player should be able to select how many questions they want to be asked: 5, 10, or 20.
 You should randomly generate as many questions as they asked for, within the difficulty range they asked for.
 If you want to go fully down the “education” route then this is going to be some steppers, a text field and a couple of buttons. I would suggest that’s a good place to start, just to make sure you have the basics covered.
 
 Once you have that, it’s down to you how far you want to take the app down the “entertainment” route – you could throw away fixed controls like Stepper entirely if you wanted, and instead rely on colorful buttons to get the same result.
 
 This is one of those challenges that is best approached step by step: get something working first, then improve it as far as you want. Maybe you’re happy with a simple app, or maybe you really want to spend some time crafting a fun design. It’s down to you!
 
 Important: It’s really easy to get sucked into these challenges and spend hours fighting with a particular bug that only exists because you wanted to get an exact effect. Don’t overload yourself with work, because you’ll just burn out! Instead, start with the simplest possible code that works, then build up slowly.
 
 If you have lots of time on your hands, you could use something like Kenney’s Animal Pack (which is public domain, by the way!) to add a fun theme to make it into a real game. Don’t be afraid to add some animations, too – it needs to appeal to kids 9 and under, so bright and colorful is a good idea!
 
 To solve this challenge you’ll need to draw on skills you learned in all the projects so far, but if you start small and work your way forward you stand the best chance of success. At its core this isn’t a complicated app, so get the basics right and expand only if you have the time.
 
 At the very least, you should:
 
 Start with an App template, then add some state to determine whether the game is active or whether you’re asking for settings.
 Generate a range of questions based on the user’s settings.
 Show the player how many questions they got correct at the end of the game, then offer to let them play again.
 Once you have your code working, try and see if you can break up your layouts into new SwiftUI views rather than putting everything in ContentView. This requires passing data between views, which isn’t something we’ve covered in detail yet, so in the meantime send data using closures – the button action from your settings view would call a function passed in by the parent view that starts the game with the user’s settings, for example.
 
 I’m going to provide some hints below, but I suggest you try to complete as much of the challenge as you can before reading them.
 
 Hints:
 
 You should generate all your questions as soon as your game starts, storing them as an array of questions.
 Those questions should probably be their own Swift struct, Question, storing the text and the answer.
 When it comes to asking questions, use another state property called questionNumber or similar, which is an integer pointing at some position in your question array.
 You can get user input either using buttons on the screen, like a calculator, or using a number pad text field – whichever you prefer.
 If you intend to pass a closure into a view’s initializer for later use, Xcode will force you to mark it as @escaping. This means “will be used outside of the current method.”
 At its simplest, this is not a hard app to build. Get that core right – get the fundamental logic of what you’re trying to do – then think about how to bring it to life. Yes, I know that part is the fun part, but ultimately this app needs to be useful, and it’s better to get the core working than try for everything at once and find you get bored part-way through.
 */
