//
//  TetriXView.swift
//  TetriX
//
//  Created by Art Huang on 16/03/2017.
//  Copyright © 2017 Art Huang. All rights reserved.
//

import UIKit

class TetriXView: UIView
{
    var gamePanel: [[Color]]? {
        didSet {
            if gamePanel != nil {
                updateTiles()
                setNeedsDisplay()
            }
        }
    }
    
    private var rowNum: Int {
        return gamePanel?.first?.count ?? 0
    }
    
    private var colNum: Int {
        return gamePanel?.count ?? 0
    }
    
    private lazy var tileViews: [[UIView]] = {
        var newTileViews = [[UIView]]()
        
        for i in 0..<self.colNum {
            var newCol = [UIView]()
            
            for j in 0..<self.rowNum {
                newCol.append(UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero)))
                newCol.last!.backgroundColor = Color.black.getUIColor()
                self.addSubview(newCol.last!)
            }
            
            newTileViews.append(newCol)
        }
        
        return newTileViews
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tileWidth = bounds.size.width / CGFloat(colNum)
        let tileHeight = bounds.size.height / CGFloat(rowNum)

        for i in 0..<colNum {
            for j in 0..<rowNum {
                tileViews[i][j].frame = CGRect(x: CGFloat(i)*tileWidth, y: CGFloat(j)*tileHeight, width: tileWidth, height: tileHeight)
            }
        }
    }
    
    private func updateTiles() {
        for i in 0..<colNum {
            for j in 0..<rowNum {
                tileViews[i][j].backgroundColor = gamePanel?[i][j].getUIColor() ?? Color.black.getUIColor()
            }
        }
    }
}
