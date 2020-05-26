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

    override func draw(_ rect: CGRect) {
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
        chessDelegate?.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
    }
    
    func drawPieces() {
        for piece in pieces {
            let pieceImage = UIImage(named: piece.imageName)
            pieceImage?.draw(in: CGRect(x: piece.col * 40, y: piece.row * 40, width: 40, height: 40))
        }
    }
    
    func drawBoard() {
        drawTwoRowsAt(y: 0 * 40)
        drawTwoRowsAt(y: 2 * 40)
        drawTwoRowsAt(y: 4 * 40)
        drawTwoRowsAt(y: 6 * 40)
    }
    
    func drawTwoRowsAt(y: CGFloat) {
        drawSquareAt(x: 1 * 40, y: y)
        drawSquareAt(x: 3 * 40, y: y)
        drawSquareAt(x: 5 * 40, y: y)
        drawSquareAt(x: 7 * 40, y: y)
        
        drawSquareAt(x: 0 * 40, y: y + 40)
        drawSquareAt(x: 2 * 40, y: y + 40)
        drawSquareAt(x: 4 * 40, y: y + 40)
        drawSquareAt(x: 6 * 40, y: y + 40)
    }
    
    func drawSquareAt(x: CGFloat, y: CGFloat) {
        let path = UIBezierPath(rect: CGRect(x: x, y: y, width: 40, height: 40))
        #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 0.7719392123).setFill()
        path.fill()
    }

}
