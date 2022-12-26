//
//  DraggableToy.swift
//  BabySortingToyGame
//
//  Created by Shakhnoza Mirabzalova on 12/21/22.
//

import SwiftUI

struct DraggableToy<Draggable: Gesture>: View {
    let toy: Toy
    private let size: CGFloat = 100
    let position: CGPoint
    let gesture: Draggable
    
    var body: some View {
       Circle()
            .fill(toy.color)
            .frame(width: size, height: size)
            .position(position)
            .gesture(gesture)
    }
}

struct DraggableToy_Previews: PreviewProvider {
    static var previews: some View {
        DraggableToy(
            toy: Toy.all.first!,
            position: CGPoint(x: 100, y: 100),
            gesture: DragGesture())
    }
}
