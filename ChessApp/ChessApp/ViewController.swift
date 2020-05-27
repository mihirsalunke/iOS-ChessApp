//
//  ViewController.swift
//  ChessApp
//
//  Created by Mihir Salunke on 5/25/20.
//  Copyright © 2020 Mihir Salunke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChessDelegate {
    
    var chessEngine = ChessEngine()
    
    var isWhiteTurn = true

    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var lblDisplayStatus: UILabel!
    
    @IBOutlet weak var lblDisplayTurn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chessEngine.initializeGame()
        boardView.pieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        self.updateTurnOnScreen()
        
        boardView.chessDelegate = self
    }

    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        //check if the move is valid
        if chessEngine.isMoveValid(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) {
            //then actually move piece
            chessEngine.movePiece(piece: chessEngine.pieceAt(col: fromCol, row: fromRow)!, toCol: toCol, toRow: toRow)
        }
        boardView.pieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        self.updateTurnOnScreen()
    }
    
    func nextTurn() {
        isWhiteTurn = !isWhiteTurn
        updateTurnOnScreen()
    }
    
    func updateTurnOnScreen() {
        lblDisplayTurn.text = isWhiteTurn ? "White's turn" : "Black's turn"
        lblDisplayTurn.textColor = isWhiteTurn ? #colorLiteral(red: 0.979090035, green: 0.963788569, blue: 1, alpha: 1) : #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
    }

}

