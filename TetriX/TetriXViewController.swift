//
//  TetriXViewController.swift
//  TetriX
//
//  Created by Art Huang on 16/03/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

import UIKit

class TetriXViewController: UIViewController
{
    let game = TetriXGame(withRow: 18, withCol: 10)
    var score = 0 { didSet { scoreTextLabel.text = "Score: \(score)" } }
    var level = 0 { didSet { levelTextLabel.text = "Level: \(level)" } }
    
    @IBOutlet weak var scoreTextLabel: UILabel!
    @IBOutlet weak var levelTextLabel: UILabel!
    @IBOutlet weak var gamePanelView: TetriXView!
    
    private var isGameStarted: Bool = false {
        didSet {
            if isGameStarted {
                startGame()
            }
            else {
                stopGame()
            }
        }
    }
    
    private struct GameSetting {
        static let StartDroppingPeriod = 0.5
    }
    
    private lazy var gameTimer: Timer = {
        return Timer.scheduledTimer(
            withTimeInterval: GameSetting.StartDroppingPeriod,
            repeats: true) { timer in
                if !self.game.drop() {
                    self.removeCompletedRows()
                    
                    var isGameOvered = false
                    
                    for i in 0..<self.game.columnNum {
                        if self.game.panel[i].first! != .black {
                            self.isGameStarted = false
                            isGameOvered = true
                            break
                        }
                    }
                    
                    if !isGameOvered {
                        var numTriedToGenNewBrick = 0
                        
                        while numTriedToGenNewBrick < 3 {
                            if self.game.generateNewBrick() {
                                break
                            }
                            
                            numTriedToGenNewBrick += 1
                        }
                        
                        if numTriedToGenNewBrick >= 3 {
                            self.isGameStarted = false
                        }
                        else {
                            self.score += 10
                            
                            if self.score / 300 > self.level {
                                self.level += 1
                            }
                        }
                    }
                }
                
                self.updateGamePanel()
        }
    }()
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if isGameStarted {
                // Rotate
                if sender.location(in: gamePanelView).y < gamePanelView.bounds.height / 2 {
                    game.rotate()
                }
                // Drop
                else if sender.location(in: gamePanelView).y >= gamePanelView.bounds.height * 3/4 {
                    _ = game.drop()
                }
                else {
                    // Move left
                    if sender.location(in: gamePanelView).x < gamePanelView.bounds.width / 2 {
                        game.move(.left)
                    }
                    // Move right
                    else {
                        game.move(.right)
                    }
                }
                
                updateGamePanel()
            }
            else {
                isGameStarted = true
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateGamePanel()
    }
    
    private func updateGamePanel() {
        gamePanelView?.gamePanel = game.panel
    }
    
    private func startGame() {
        gameTimer.fire()
    }
    
    private func stopGame() {
        gameTimer.invalidate()
    }
    
    private func removeCompletedRows() {
        var rowsToRemove = [Int]()
        
        for j in 0..<game.panel.first!.count {
            var removeThisRow = true
            
            for i in 0..<game.panel.count {
                if game.panel[i][j] == .black {
                    removeThisRow = false
                    break
                }
            }
            
            if removeThisRow {
                rowsToRemove.append(j)
            }
        }
        
        for row in rowsToRemove {
            for col in 0..<game.panel.count {
                game.panel[col].remove(at: row)
                game.panel[col].insert(.black, at: 0)
            }
        }
        
        score += rowsToRemove.count * 100
    }
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
}

enum Color {
    case black
    case red
    case blue
    case orange
    case yellow
    case magneta
    case cyan
    case green
    
    func getUIColor() -> UIColor {
        switch self {
        case .black:
            return UIColor.darkGray
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .orange:
            return UIColor.orange
        case .yellow:
            return UIColor.yellow
        case .magneta:
            return UIColor.magenta
        case .cyan:
            return UIColor.cyan
        case .green:
            return UIColor.green
        }
    }
}
