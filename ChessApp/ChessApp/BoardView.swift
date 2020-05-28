//
//  BoardView.swift
//  ChessApp
//
//  Created by Mihir Salunke on 5/26/20.
//  Copyright © 2020 Mihir Salunke. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    var pieces = Set<ChessPiece>()
    var chessDelegate: ChessDelegate?
    var fromCol = -1
    var fromRow = -1
    
    var boardDimention: Int!
    var squareSize: Int!

    override func draw(_ rect: CGRect) {
        //print("drawing...with board size: \(boardDimention) and square size: \(squareSize)")
        drawBoard()
        drawPieces()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let fingerLocation = touch.location(in: self)
        fromCol = Int(fingerLocation.x / 40)
        fromRow = Int(fingerLocation.y / 40)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let fingerLocation = touch.location(in: self)
        let toCol = Int(fingerLocation.x / 40)
        let toRow = Int(fingerLocation.y / 40)
        chessDelegate?.makePlayerMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
    }
    
    func drawPieces() {
        for piece in pieces {
            let pieceImage = UIImage(named: piece.imageName)
            pieceImage?.draw(in: CGRect(x: piece.col * squareSize, y: piece.row * squareSize, width: squareSize, height: squareSize))
        }
    }
    
    func drawBoard() {
        drawTwoRowsAt(y: CGFloat(0 * squareSize))
        drawTwoRowsAt(y: CGFloat(2 * squareSize))
        drawTwoRowsAt(y: CGFloat(4 * squareSize))
        drawTwoRowsAt(y: CGFloat(6 * squareSize))
    }
    
    func drawTwoRowsAt(y: CGFloat) {
        drawSquareAt(x: CGFloat(1 * squareSize), y: y)
        drawSquareAt(x: CGFloat(3 * squareSize), y: y)
        drawSquareAt(x: CGFloat(5 * squareSize), y: y)
        drawSquareAt(x: CGFloat(7 * squareSize), y: y)
        
        drawSquareAt(x: CGFloat(0 * squareSize), y: y + CGFloat(squareSize))
        drawSquareAt(x: CGFloat(2 * squareSize), y: y + CGFloat(squareSize))
        drawSquareAt(x: CGFloat(4 * squareSize), y: y + CGFloat(squareSize))
        drawSquareAt(x: CGFloat(6 * squareSize), y: y + CGFloat(squareSize))
    }
    
    func drawSquareAt(x: CGFloat, y: CGFloat) {
        let path = UIBezierPath(rect: CGRect(x: x, y: y, width: CGFloat(squareSize), height: CGFloat(squareSize)))
        #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 0.7719392123).setFill()
        path.fill()
    }
    
    func setSquareSize(boardDimention: Int) {
        self.squareSize = boardDimention / 8
    }
    
    func setBoardDimention(boardDimention: Int) {
        self.boardDimention = boardDimention
    }
    
    func resetBoardConstrains(boardDimention: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.superview, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.superview, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        print("board size is: \(boardDimention)")
        NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(boardDimention)).isActive = true
        NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(boardDimention)).isActive = true
    }
    
    func getBoardDimention(height: Int) -> Int {
        switch height {
        case 480:
            print("iPhone 4s")
            return 280
        case 568:
            print("iPhone SE")
            return 280
        case 667:
            print("iPhone 8")
            return 320
        case 736:
            print("iPhone 8+")
            return 320
        case 812:
            print("iPhone 11 Pro")
            return 320
        case 896:
            print("iPhone 11 Pro Max")
            return 320
        case 1024:
            print("iPad Pro (9.7-inch)")
            return 640
        case 1080:
            print("iPad 10.2-inch")
            return 720
        case 1112:
            print("iPad Pro 10.5 inch")
            return 720
        case 1194:
            print("iPad Pro 11 inch")
            return 720
        case 1366:
            print("iPad Pro 12.9-inch")
            return 960
        default:
            print("unknown device")
            return 280
        }
    }

}
