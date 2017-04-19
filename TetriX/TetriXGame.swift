//
//  TetriXGame.swift
//  TetriX
//
//  Created by Art Huang on 16/03/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

class TetriXGame
{
    var rowNum: Int
    var columnNum: Int
    var panel: [[Color]]
    
    enum Direction {
        case left
        case right
        case down
    }
    
    private var droppingBrick: TetriXBrick? {
        willSet {
            if droppingBrick != nil && newValue == nil {
                for tile in droppingBrick!.tiles {
                    panel[tile.x][tile.y] = .black
                }
            }
        }
        didSet {
            if droppingBrick != nil {
                for tile in droppingBrick!.tiles {
                    switch droppingBrick!.type {
                    case .i:
                        panel[tile.x][tile.y] = .red
                    case .j:
                        panel[tile.x][tile.y] = .blue
                    case .l:
                        panel[tile.x][tile.y] = .orange
                    case .o:
                        panel[tile.x][tile.y] = .yellow
                    case .s:
                        panel[tile.x][tile.y] = .magneta
                    case .t:
                        panel[tile.x][tile.y] = .cyan
                    case .z:
                        panel[tile.x][tile.y] = .green
                    }
                }
            }
        }
    }
    
    init(withRow row: Int, withCol col: Int) {
        rowNum = row
        columnNum = col
        panel = Array(repeating: Array(repeating: .black, count: row), count: col)
    }
    
    func rotate() {
        if let brick = droppingBrick {
            let rotatedBrick = brick.rotated()
            
            droppingBrick = nil
            
            if check(brick: rotatedBrick) {
                droppingBrick = rotatedBrick
            }
            else {
                droppingBrick = brick
            }
        }
    }
    
    func move(_ direction: Direction) {
        if let brick = droppingBrick {
            let movedBrick = TetriXBrick(
                pos: Position((direction == .left) ? brick.pos.x-1 : brick.pos.x+1, brick.pos.y),
                type: brick.type,
                stage: brick.stage
            )
            
            droppingBrick = nil
            
            if check(brick: movedBrick) {
                droppingBrick = movedBrick
            }
            else {
                droppingBrick = brick
            }
        }
    }
    
    func drop() -> Bool {
        if let brick = droppingBrick {
            let droppedBrick = TetriXBrick(pos: Position(brick.pos.x, brick.pos.y+1), type: brick.type, stage: brick.stage)
            
            droppingBrick = nil
            
            if check(brick: droppedBrick) {
                droppingBrick = droppedBrick
                return true
            }
            else {
                droppingBrick = brick
                return false
            }
        }
        else {
            // No block to drop
            return false
        }
    }
    
    func reset() {
        
    }
    
    func generateNewBrick() -> Bool {
        var newBrick = TetriXBrick(pos: Position(columnNum/2-1, 0))
        
        if let currentBrick = droppingBrick {
            while currentBrick.type == newBrick.type {
                newBrick = TetriXBrick(pos: Position(columnNum/2-1, 0))
            }
        }
        
        for tile in newBrick.tiles {
            if panel[tile.x][tile.y] != .black {
                return false
            }
        }
        
        droppingBrick = newBrick
        return true
    }
    
    private func check(brick: TetriXBrick) -> Bool {
        for tile in brick.tiles {
            // Exceed boundary
            if tile.x < 0 || tile.x >= columnNum || tile.y < 0 || tile.y >= rowNum {
                return false
            }
            // Hit another brick
            else if panel[tile.x][tile.y] != .black {
                return false
            }
        }
        
        return true
    }
}

struct Position {
    var x: Int
    var y: Int
    
    var left: Position { return Position(x-1, y) }
    var right: Position { return Position(x+1, y) }
    var up: Position { return Position(x, y-1) }
    var down: Position { return Position(x, y+1) }
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

