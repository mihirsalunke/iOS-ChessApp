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
    
    func mapMoves(row: Int, col: Int) -> String {
        var move: String = ""
        switch col {
        case 0:
            move.append("a")
        case 1:
            move.append("b")
        case 2:
            move.append("c")
        case 3:
            move.append("d")
        case 4:
            move.append("e")
        case 5:
            move.append("f")
        case 6:
            move.append("g")
        case 7:
            move.append("h")
        default:
            move.append("NA")
        }
        
        switch row {
        case 0:
            move.append("8")
        case 1:
            move.append("7")
        case 2:
            move.append("6")
        case 3:
            move.append("5")
        case 4:
            move.append("4")
        case 5:
            move.append("3")
        case 6:
            move.append("2")
        case 7:
            move.append("1")
        default:
            move.append("NA")
        }
        
        return move
    }
    
    func reverseMapMoves(move: String) -> Array<Int> {
        var colRowMove = Array<Int>()
        let moveArray = Array(move)
        switch moveArray[0] {
        case "a":
            colRowMove.append(0)
        case "b":
            colRowMove.append(1)
        case "c":
            colRowMove.append(2)
        case "d":
            colRowMove.append(3)
        case "e":
            colRowMove.append(4)
        case "f":
            colRowMove.append(5)
        case "g":
            colRowMove.append(6)
        case "h":
            colRowMove.append(7)
        default:
            colRowMove.append(-1)
        }
        
        switch moveArray[1] {
        case "8":
            colRowMove.append(0)
        case "7":
            colRowMove.append(1)
        case "6":
            colRowMove.append(2)
        case "5":
            colRowMove.append(3)
        case "4":
            colRowMove.append(4)
        case "3":
            colRowMove.append(5)
        case "2":
            colRowMove.append(6)
        case "1":
            colRowMove.append(7)
        default:
            colRowMove.append(-1)
        }
        
        return colRowMove
    }

}

