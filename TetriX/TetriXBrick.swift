//
//  TetriXBrick.swift
//  TetriX
//
//  Created by Art Huang on 16/03/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

import Foundation

class TetriXBrick
{
    /*
        Brick information: (◼︎ means the position indacates)
            type I stage 0, 2: ◼︎◻︎◻︎◻︎
            type I stage 1, 3: ◼︎
                               ◻︎
                               ◻︎
                               ◻︎
            type J stage 0: ◼︎
                            ◻︎
                           ◻︎◻︎
            type J stage 1: ◼︎◻︎◻︎
                               ◻︎
            type J stage 2: ◼︎◻︎
                            ◻︎
                            ◻︎
            type J stage 3: ◼︎
                            ◻︎◻︎◻︎
            type L stage 0: ◼︎
                            ◻︎
                            ◻︎◻︎
            type L stage 1: ◼︎
                         ◻︎◻︎◻︎
            type L stage 2: ◼︎◻︎
                             ◻︎
                             ◻︎
            type L stage 3: ◼︎◻︎◻︎
                            ◻︎
            type O stage 0, 1, 2, 3: ◼︎◻︎
                                     ◻︎◻︎
            type S stage 0, 2: ◼︎◻︎
                              ◻︎◻︎
            type S stage 1, 3: ◼︎
                               ◻︎◻︎
                                ◻︎
            type T stage 0: ◼︎
                           ◻︎◻︎◻︎
            type T stage 1: ◼︎
                           ◻︎◻︎
                            ◻︎
            type T stage 2: ◼︎◻︎◻︎
                             ◻︎
            type T stage 3: ◼︎
                            ◻︎◻︎
                            ◻︎
            type Z stage 0, 2: ◼︎◻︎
                                ◻︎◻︎
            type Z stage 1, 3: ◼︎
                              ◻︎◻︎
                              ◻︎
    */
    
    var pos: Position
    var type: BrickType
    var stage: Int
    var nextStage: Int {
        return (stage + 1) % Constants.StageMax
    }
    
    var tiles: [Position] {
        switch type {
        case .i where stage == 0 || stage == 2:
            return [pos, pos.right, pos.right.right, pos.right.right.right]
        case .i where stage == 1 || stage == 3:
            return [pos, pos.down, pos.down.down, pos.down.down.down]
        case .j where stage == 0:
            return [pos, pos.down, pos.down.down, pos.down.down.left]
        case .j where stage == 1:
            return [pos, pos.right, pos.right.right, pos.right.right.down]
        case .j where stage == 2:
            return [pos, pos.right, pos.down, pos.down.down]
        case .j where stage == 3:
            return [pos, pos.down, pos.down.right, pos.down.right.right]
        case .l where stage == 0:
            return [pos, pos.down, pos.down.down, pos.down.down.right]
        case .l where stage == 1:
            return [pos, pos.down, pos.down.left, pos.down.left.left]
        case .l where stage == 2:
            return [pos, pos.right, pos.right.down, pos.right.down.down]
        case .l where stage == 3:
            return [pos, pos.down, pos.right, pos.right.right]
        case .o:
            return [pos, pos.right, pos.down, pos.down.right]
        case .s where stage == 0 || stage == 2:
            return [pos, pos.right, pos.down, pos.down.left]
        case .s where stage == 1 || stage == 3:
            return [pos, pos.down, pos.down.right, pos.down.right.down]
        case .t where stage == 0:
            return [pos, pos.down, pos.down.left, pos.down.right]
        case .t where stage == 1:
            return [pos, pos.down, pos.down.left, pos.down.down]
        case .t where stage == 2:
            return [pos, pos.right, pos.right.right, pos.right.down]
        case .t where stage == 3:
            return [pos, pos.down, pos.down.right, pos.down.down]
        case .z where stage == 0 || stage == 2:
            return [pos, pos.right, pos.right.down, pos.right.down.right]
        case .z where stage == 1 || stage == 3:
            return [pos, pos.down, pos.down.left, pos.down.left.down]
        default:
            // Should never happen
            return []
        }
    }
    
    enum BrickType {
        case i
        case j
        case l
        case o
        case s
        case t
        case z
    }
    
    private struct Constants {
        static let BrickTypeLookup = [BrickType.i, .j, .l, .o, .s, .t, .z]
        static let StageMax = 4
    }
    
    init(pos: Position, type: BrickType, stage: Int) {
        self.pos = pos
        self.type = type
        self.stage = stage
    }
    
    // Generate a random brick with initial position
    convenience init(pos: Position) {
        let type = Constants.BrickTypeLookup[numericCast(arc4random_uniform(numericCast(Constants.BrickTypeLookup.count)))]
        //let type = BrickType.s
        let stage: Int = numericCast(arc4random_uniform(numericCast(Constants.StageMax)))
        self.init(pos: pos, type: type, stage: stage)
    }
    
    func rotated() -> TetriXBrick {
        switch type {
        case .i:
            if stage == 0 || stage == 2 {
                return TetriXBrick(pos: pos.right.up, type: type, stage: nextStage)
            }
            else {
                return TetriXBrick(pos: pos.down.left, type: type, stage: nextStage)
            }
        case .j:
            switch stage {
            case 0:
                return TetriXBrick(pos: pos.left.left, type: type, stage: nextStage)
            case 1:
                return TetriXBrick(pos: pos, type: type, stage: nextStage)
            case 2:
                return TetriXBrick(pos: pos.down, type: type, stage: nextStage)
            case 3:
                return TetriXBrick(pos: pos.right.right.up, type: type, stage: nextStage)
            default:
                // Should never happen
                return TetriXBrick(pos: pos, type: type, stage: stage)
            }
        case .l:
            switch stage {
            case 0:
                return TetriXBrick(pos: pos.down.right.right, type: type, stage: nextStage)
            case 1:
                return TetriXBrick(pos: pos.left.up, type: type, stage: nextStage)
            case 2:
                return TetriXBrick(pos: pos.left, type: type, stage: nextStage)
            case 3:
                return TetriXBrick(pos: pos, type: type, stage: nextStage)
            default:
                // Should never happen
                return TetriXBrick(pos: pos, type: type, stage: stage)
            }
        case .o:
            return TetriXBrick(pos: pos, type: type, stage: nextStage)
        case .s:
            if stage == 0 || stage == 2 {
                return TetriXBrick(pos: pos.up, type: type, stage: nextStage)
            }
            else {
                return TetriXBrick(pos: pos.down, type: type, stage: nextStage)
            }
        case .t:
            switch stage {
            case 0:
                return TetriXBrick(pos: pos.right.up, type: type, stage: nextStage)
            case 1:
                return TetriXBrick(pos: pos.left.left, type: type, stage: nextStage)
            case 2:
                return TetriXBrick(pos: pos, type: type, stage: nextStage)
            case 3:
                return TetriXBrick(pos: pos.down.right, type: type, stage: nextStage)
            default:
                // Should never happen
                return TetriXBrick(pos: pos, type: type, stage: stage)
            }
        case .z:
            if stage == 0 || stage == 2 {
                return TetriXBrick(pos: pos.right.up, type: type, stage: nextStage)
            }
            else {
                return TetriXBrick(pos: pos.down.left, type: type, stage: nextStage)
            }
        }
    }
}
