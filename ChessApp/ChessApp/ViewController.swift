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

    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var lblDisplayStatus: UILabel!
    
    @IBOutlet weak var lblDisplayTurn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chessEngine.initializeGame()
        boardView.pieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        
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
    }

}

