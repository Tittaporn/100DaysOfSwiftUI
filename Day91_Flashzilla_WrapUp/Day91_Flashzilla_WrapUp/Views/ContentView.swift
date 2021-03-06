//
//  ContentView.swift
//  Day91_Flashzilla_WrapUp
//
//  Created by Lee McCormick on 7/11/22.
//

/*
 *** Challenge ****
 1) When adding a card, the textfields keep their current text – fix that so that the textfields clear themselves after a card is added.
 2) If you drag a card to the right but not far enough to remove it, then release, you see it turn red as it slides back to the center. Why does this happen and how can you fix it? (Tip: think about the way we set offset back to 0 immediately, even though the card hasn’t animated yet. You might solve this with a ternary within a ternary, but a custom modifier will be cleaner.)
 3) For a harder challenge: when the users gets an answer wrong, add that card goes back into the array so the user can try it again. Doing this successfully means rethinking the ForEach loop, because relying on simple integers isn’t enough – your cards need to be uniquely identifiable.
 
 *** Still thirsty for more? Try upgrading our loading and saving code in two ways:
 
 1) Make it use documents JSON rather than UserDefaults – this is generally a good idea, so you should get practice with this.
 2) Try to find a way to centralize the loading and saving code for the cards. You might need to experiment a little to find something you like!
 */

import SwiftUI

// MARK: - Extension View
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

// MARK: - ContentView
struct ContentView: View {
    // MARK: - Properties
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var vm = CardsDocumentDirectoryController()
    @State private var showingEditView = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            // Time Text and Card View
            VStack {
                Text("Time : \(vm.timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack {
                    ForEach(0..<vm.cards.count, id: \.self) { index in
                        //  Challenge 3
                        CardView(card: vm.cards[index]) { isCorrectAnswer in
                            withAnimation {
                                if isCorrectAnswer {
                                    vm.removeCard(at: index)
                                } else {
                                    vm.restackCard(at: index)
                                }
                            }
                        }
                        .stacked(at: index, in: vm.cards.count)
                        .allowsHitTesting(index == vm.cards.count - 1)
                        .accessibilityHidden(index < vm.cards.count - 1)
                    }
                }
                .allowsHitTesting(vm.timeRemaining > 0)
                if vm.cards.isEmpty {
                    Button("Start Again", action: vm.resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            // Add Card Button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditView = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            // Accessibily
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                vm.removeCard(at: vm.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        Spacer()
                        Button {
                            withAnimation {
                                vm.removeCard(at: vm.cards.count - 1)
                            }                        } label: {
                                Image(systemName: "checkmark.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel("Correct")
                            .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in vm.updateTimeRemaining() }
        .onChange(of: scenePhase) { newPhase in vm.updateIsActiveStatus(with: newPhase) }
        .sheet(isPresented: $showingEditView, onDismiss: vm.resetCards, content: EditCardsView.init)
        .onAppear(perform: vm.resetCards)
        .environmentObject(vm)
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


