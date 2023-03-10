//
//  ToyViewModel.swift
//  BabySortingToyGame
//
//  Created by Shakhnoza Mirabzalova on 12/21/22.
//

import SwiftUI

class ToyViewModel: ObservableObject {
    // MARK: - Gesture Properties
    @Published var currentToy: Toy?
    @Published var currentPosition = initialPosition
    @Published var highlightedId: Int?
    @Published var draggableToyOpacity: CGFloat = 1.0
    @Published var isGameOver = false
    private(set) var attempts = 0
    
    // MARK: - Coordinates
    private static let initialPosition = CGPoint(
        x: UIScreen.main.bounds.midX,
        y: UIScreen.main.bounds.midY + 300
    )
    private var frames: [Int: CGRect] = [:]
    
    // MARK: Objects in the screen
    private var toys = Array(Toy.all.shuffled().prefix(upTo: 6))
    var toyContainers = Toy.all.shuffled()
    
    // MARK: Game lifecycle
    func setupGame() {
        currentToy = toys.popLast()
    }
    
    func nextRound() {
        currentToy = toys.popLast()
        
        if currentToy == nil {
            gameOver()
        } else {
            prepareObjects()
        }
    }
    
    func gameOver() {
        isGameOver = true
    }
    
    func prepareObjects() {
        withAnimation {
            toyContainers.shuffle()
        }
        
        withAnimation(.none) {
            resetPosition()
            withAnimation {
                draggableToyOpacity = 1.0
            }
        }
    }
    
    func generateNewGame() {
        toys = Array(Toy.all.shuffled().prefix(upTo: 6))
        attempts = 0
        nextRound()
    }
    
    // MARK: - Updates in the screen
    func update(frame: CGRect, for id: Int) {
        frames[id] = frame
    }
    func update(dragPosition: CGPoint) {
        currentPosition = dragPosition
        for(id, frame) in frames where frame.contains(dragPosition) {
            print("you are in \(id) number")
            highlightedId = id
            return
        }
        highlightedId = nil
    }
    
    func confirmDrop() {
        
        defer { highlightedId = nil }
        
        guard let highlightedId = highlightedId else {
            resetPosition()
            return
        }
        if highlightedId == currentToy?.id {
            guard let frame = frames[highlightedId] else {
                return
            }
            currentPosition = CGPoint(x: frame.midX, y: frame.midY)
            draggableToyOpacity = 0
            nextRound()
        } else {
            resetPosition()
        }
        attempts += 1
    }
    
    func resetPosition() {
        currentPosition = ToyViewModel.initialPosition
    }
    func isHighlighted(id: Int) -> Bool {
        highlightedId == id
    }
}
