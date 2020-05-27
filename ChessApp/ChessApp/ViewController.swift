//
//  ViewController.swift
//  ChessApp
//
//  Created by Mihir Salunke on 5/25/20.
//  Copyright © 2020 Mihir Salunke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit

class ViewController: UIViewController {
    
    var chessEngine = ChessEngine()
    
    var gameMode: String!
    var gameID: String! = "1"
    var isAgainstAI: Bool!
    var isWhiteTurn = true
    var userColor: String!
    var AIColor: String!
    
    let gameURL = "https://chess-api-chess.herokuapp.com/api/v1"

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
        
        if self.isAgainstAI {
            promptForColorSelection(viewController: self)
        }
        
        //set new game by calling "https://chess-api-chess.herokuapp.com/api/v1/chess/one" or "https://chess-api-chess.herokuapp.com/api/v1/chess/two" depending on the game mode
        getNewGame()
        boardView.pieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        self.updateTurnOnScreen()
    }
    
    func setGameMode(gameMode: String) {
        self.gameMode = gameMode
    }
    
    func getGameMode() -> String {
        return self.gameMode
    }
    
    func setGameID(gameID: String) {
        self.gameID = gameID
    }
    
    func getGameID() -> String {
        return self.gameID
    }
    
    func promptForColorSelection(viewController: ViewController) {
        let box = UIAlertController(title: "Start Game", message: "Choose color", preferredStyle: .alert)

        box.addAction(UIAlertAction(title: "White", style: .default, handler: {
            action in
            //set color
            self.userColor = "white"
            self.AIColor = "black"
            self.isWhiteTurn = true
            print("Player is: \(action.title!)")
            print("----------------------------------------------")
            self.updateTurnOnScreen()
        }))

        box.addAction(UIAlertAction(title: "Black", style: .default, handler: {
            action in
            //set color
            self.userColor = "black"
            self.AIColor = "white"
            self.isWhiteTurn = true
            print("Player is: \(action.title!)")
            print("----------------------------------------------")
            self.updateTurnOnScreen()
        }))
            
        viewController.present(box, animated: true, completion: nil)
    }
    
    func nextTurn() {
        isWhiteTurn = !isWhiteTurn
        updateTurnOnScreen()
    }
    
    func updateTurnOnScreen() {
        lblDisplayTurn.text = isWhiteTurn ? "White's turn" : "Black's turn"
        lblDisplayTurn.textColor = isWhiteTurn ? #colorLiteral(red: 0.979090035, green: 0.963788569, blue: 1, alpha: 1) : #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
    }
    
    func updateStatus(message: String, color: UIColor) {
        lblDisplayStatus.text = message
        lblDisplayStatus.textColor = color
    }
    
    func getNewGameURL() -> String {
        if gameMode == "singleplayer" {
            return "\(gameURL)/chess/one"
        } else if gameMode == "multiplayer" {
            return "\(gameURL)/chess/two"
        } else {
            return gameURL
        }
    }
    
    func getNewGame() {
        let newGameURL = getNewGameURL()
        print("making api call to get new game at url: \(newGameURL)")
        print("----------------------------------------------")
        self.updateStatus(message: "Creating New Game...", color: #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
        
        Alamofire.request(newGameURL).responseJSON { response in
            print(response)
            if response.result.isSuccess {
                let gameJSON: JSON = JSON(response.result.value!)
                if gameJSON["game_id"].exists() {
                    let gameID = gameJSON["game_id"].stringValue
                    self.setGameID(gameID: gameID)
                    
                    print("response is: \(gameJSON)")
                    print("----------------------------------------------")
                    print("gameID is: \(self.getGameID())")
                    print("----------------------------------------------")
                    
                    let status = gameJSON["status"].stringValue
                    self.updateStatus(message: status, color: #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
                } else {
                    self.updateStatus(message: "Error Occured...", color: #colorLiteral(red: 0.866481483, green: 0, blue: 0, alpha: 1))
                    
                    let box = UIAlertController(title: "Start New Game", message: "Error occured in creating new game", preferredStyle: .alert)

                    box.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                        action in
                        
                        self.getNewGame()
                    }))

                    box.addAction(UIAlertAction(title: "No", style: .default, handler: {
                        action in
                        
                        self.performSegue(withIdentifier: "backToMainMenu", sender: self)
                    }))
                        
                    self.present(box, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getPossibleMovesURL() -> String {
        return "\(getNewGameURL())/moves"
    }
    
    func getPossibleMoves(for position: String) {
        let possibleMovesURL = getPossibleMovesURL()
        print("making api call to get possible moves at url: \(possibleMovesURL)")
        print("----------------------------------------------")
        print("with parameters: game_id=\(gameID!), from=\(position)")
        print("----------------------------------------------")
        
        Alamofire.request(possibleMovesURL, method: .post, parameters: ["game_id": gameID!, "from": position], encoding: JSONEncoding.default).responseJSON { response in
            print("response is: \(response)")
            print("----------------------------------------------")
        }
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

extension ViewController: ChessDelegate {
    
    func makePlayerMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        
        //get move in chess notation
        let fromMove = mapMoves(row: fromRow, col: fromCol)
        let toMove = mapMoves(row: toRow, col: toCol)
        print("Piece moved from: \(fromMove), to: \(toMove)")
        print("----------------------------------------------")
        if chessEngine.isMoveValid(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) {
            //then actually move piece
            chessEngine.movePiece(piece: chessEngine.pieceAt(col: fromCol, row: fromRow)!, toCol: toCol, toRow: toRow)
        }
        boardView.pieces = chessEngine.pieces
        boardView.setNeedsDisplay()
    }
}
