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
import Foundation

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
        let deviceHeight = UIDevice.current.detectDeviceSize()
        let boardDimention = boardView.getBoardDimention(height: deviceHeight)
        boardView.setBoardDimention(boardDimention: boardDimention)
        boardView.setSquareSize(boardDimention: boardDimention)
        boardView.resetBoardConstrains(boardDimention: boardDimention)
        
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
        lblDisplayTurn.textColor = isWhiteTurn ? #colorLiteral(red: 0.7445825934, green: 0.5974277854, blue: 0, alpha: 1) : #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
    }
    
    func updateStatus(message: String, color: UIColor) {
        lblDisplayStatus.text = message
        lblDisplayStatus.textColor = color
    }
    
    func isAITurn() -> Bool {
        if AIColor == "white" && isWhiteTurn {
            return true
        }
        if AIColor == "black" && !isWhiteTurn {
            return true
        }
        return false
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
    
    //suggestion is only available in singleplayer mode
    func getSuggestionURL() -> String {
        return "\(getNewGameURL())/help"
    }
    
    func getSuggestion() {
        let suggestionURL = getSuggestionURL()
        print("making api call to get move suggestions at url: \(suggestionURL)")
        print("----------------------------------------------")
        print("with parameters: game_id=\(gameID!)")
        print("----------------------------------------------")
        Alamofire.request(suggestionURL, method: .post, parameters: ["game_id": gameID!], encoding: JSONEncoding.default).responseJSON { response in
            print("response is: \(response)")
            print("----------------------------------------------")
        }
    }
    
    func getCheckGameOverURL() -> String {
        return "\(getNewGameURL())/check"
    }
    
    func gameOver() {
        var winner = ""
        if isWhiteTurn {
            winner = "Black"
        } else {
            winner = "White"
        }
        
        let box = UIAlertController(title: "Game Over", message: "\(winner) wins", preferredStyle: .alert)
        
        box.addAction(UIAlertAction(title: "Back to main menu", style: .default, handler: {
            action in self.performSegue(withIdentifier: "backToMainMenu", sender: self)
        }))
        
        box.addAction(UIAlertAction(title: "Rematch", style: .default, handler: {
            action in
            
            self.chessEngine.initializeGame()
            self.boardView.pieces = self.chessEngine.pieces
            self.boardView.setNeedsDisplay()
            
            self.boardView.chessDelegate = self
            
            if self.isAgainstAI {
                self.promptForColorSelection(viewController: self)
            }
            
            self.getNewGame()
        }))
        
        self.present(box, animated: true, completion: nil)
    }
    
    func gameDraw() {
        let box = UIAlertController(title: "Game Over", message: "It was a draw..!!", preferredStyle: .alert)
        
        box.addAction(UIAlertAction(title: "Back to main menu", style: .default, handler: {
            action in self.performSegue(withIdentifier: "backToMainMenu", sender: self)
        }))
        
        box.addAction(UIAlertAction(title: "Rematch", style: .default, handler: {
            action in
            
            self.chessEngine.initializeGame()
            self.boardView.pieces = self.chessEngine.pieces
            self.boardView.setNeedsDisplay()
            
            self.boardView.chessDelegate = self
            
            if self.isAgainstAI {
                self.promptForColorSelection(viewController: self)
            }
            
            self.getNewGame()
        }))
        
        self.present(box, animated: true, completion: nil)
    }
    
    func getAIMoveURL() -> String {
        return "\(getNewGameURL())/move/ai"
    }
    
    func makeAIMove() {
        getAIMove()
        .done { (fromCol, fromRow, toCol, toRow) in
            self.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
            self.nextTurn()
            self.updateStatus(message: "AI has played", color: #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
            self.checkGameStatus()
            .done { (gameStatus) in
                if gameStatus == "check mate" {
                    self.updateStatus(message: "check mate...!!", color: #colorLiteral(red: 0.866481483, green: 0, blue: 0, alpha: 1))
                    self.gameOver()
                } else {
                    self.updateStatus(message: gameStatus, color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                }
            }
            .catch { error in
                print(error)
            }
        }
        .catch { error in
            print(error)
        }
    }
    
    func getSimulatePlayerMoveURL() -> String {
        if gameMode == "singleplayer" {
            return "\(getNewGameURL())/move/player"
        } else {
            return "\(getNewGameURL())/move"
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
        let fromMove = mapMoves(row: fromRow, col: fromCol)
        let toMove = mapMoves(row: toRow, col: toCol)
        
        //call api to make move
        simulatePlayerMove(from: fromMove, to: toMove)
        .done { (fromCol, fromRow, toCol, toRow) in
            self.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
            self.nextTurn()
            self.checkGameStatus()
            .done { (gameStatus) in
                if gameStatus == "check mate" {
                    self.updateStatus(message: "check mate...!!", color: #colorLiteral(red: 0.866481483, green: 0, blue: 0, alpha: 1))
                    self.gameOver()
                } else if gameStatus == "game draw" {
                    self.updateStatus(message: "Game is draw..!!", color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                    self.gameDraw()
                } else {
                    self.updateStatus(message: gameStatus, color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                }
                if self.isAgainstAI && self.isAITurn() {
                    self.makeAIMove()
                }
            }
            .catch { error in
                print(error)
            }
        }
        .catch { error in
            print(error)
        }
    }
    
    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        
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

extension ViewController {
    
    func simulatePlayerMove(from source: String, to destination: String) -> Promise<(Int, Int, Int, Int)> {
        let simulatePlayerMove = getSimulatePlayerMoveURL()
        
        return Promise<(Int, Int, Int, Int)> { seal -> Void in
            print("making api call to simulate player move at url: \(simulatePlayerMove)")
            print("----------------------------------------------")
            print("with parameters: game_id=\(gameID!), from=\(source), to=\(destination)")
            print("----------------------------------------------")
            Alamofire.request(simulatePlayerMove, method: .post, parameters: ["game_id": gameID!, "from": source, "to": destination], encoding: JSONEncoding.default).responseJSON { response in
                print("response is: \(response)")
                print("----------------------------------------------")
                if response.result.isSuccess {
                    
                    let resJSON: JSON = JSON(response.result.value!)
                    let status = resJSON["status"].stringValue
                    
                    if status == "error: invalid move!" {
                        let genericError = NSError(
                            domain: "Simulating Move",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Invalid move"])
                        self.updateStatus(message: status, color: #colorLiteral(red: 0.866481483, green: 0, blue: 0, alpha: 1))
                        seal.reject(genericError)
                    }
                    
                    if status == "error: The game has expired OR you didn't put the game_id as the parameter!" {
                        let genericError = NSError(
                            domain: "Simulating Move",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Game expired"])
                        
                        seal.reject(genericError)
                        
                        self.updateStatus(message: "Game Expired...", color: #colorLiteral(red: 0.866481483, green: 0, blue: 0, alpha: 1))
                        let box = UIAlertController(title: "Sorry, the Game Expired", message: "Want to restart the game?", preferredStyle: .alert)

                        box.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                            action in
                                    
                            self.chessEngine.initializeGame()
                            self.boardView.pieces = self.chessEngine.pieces
                            self.boardView.setNeedsDisplay()
                                
                            self.boardView.chessDelegate = self
                                
                            if self.isAgainstAI {
                                self.promptForColorSelection(viewController: self)
                            }
                            self.getNewGame()
                        }))

                        box.addAction(UIAlertAction(title: "Go back to main menu", style: .default, handler: {
                            action in
                            self.performSegue(withIdentifier: "backToMainMenu", sender: self)
                        }))
                                    
                        self.present(box, animated: true, completion: nil)
                    }
                    
                    if status == "figure moved" {
                        print("status is: \(status)")
                        self.updateStatus(message: status, color: #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
                        let reverseMappedFromMove = self.reverseMapMoves(move: source)
                        let reverseMappedToMove = self.reverseMapMoves(move: destination)

                        let fromCol = reverseMappedFromMove[0]
                        let fromRow = reverseMappedFromMove[1]

                        let toCol = reverseMappedToMove[0]
                        let toRow = reverseMappedToMove[1]
                        
                        seal.fulfill((fromCol, fromRow, toCol, toRow))
                    }
                }
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                
            }//end of Alamofire
        }//end of Promise
    }//end of function simulatePlayerMove()
    
    func getAIMove() -> Promise<(Int, Int, Int, Int)> {
        let AIMoveURL = getAIMoveURL()
        self.updateStatus(message: "AI is thinking...", color: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        return Promise<(Int, Int, Int, Int)> { seal -> Void in
            print("making api call to get AI move at url: \(AIMoveURL)")
            print("----------------------------------------------")
            print("with parameters: game_id=\(gameID!)")
            print("----------------------------------------------")
            
            Alamofire.request(AIMoveURL, method: .post, parameters: ["game_id": gameID!], encoding: JSONEncoding.default).responseJSON { response in
                print("response is: \(response)")
                print("----------------------------------------------")
                
                if response.result.isSuccess {
                    let aiResponseJSON: JSON = JSON(response.result.value!)
                    if aiResponseJSON["from"].exists() && aiResponseJSON["to"].exists() {
                        
                        let fromMove = aiResponseJSON["from"].stringValue
                        let toMove = aiResponseJSON["to"].stringValue
                        
                        let reverseMappedFromMove = self.reverseMapMoves(move: fromMove)
                        let reverseMappedToMove = self.reverseMapMoves(move: toMove)

                        let fromCol = reverseMappedFromMove[0]
                        let fromRow = reverseMappedFromMove[1]

                        let toCol = reverseMappedToMove[0]
                        let toRow = reverseMappedToMove[1]
                        
                        //print("fromCol= \(fromCol) fromRow= \(fromRow) toCol \(toCol) toRow= \(toRow)")
                                            
                        seal.fulfill((fromCol, fromRow, toCol, toRow))
                    }
                }
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
                if response.result.isFailure {
                    seal.reject(response.error!)
                }
                
            }//end of Alamofire
        }//end of Promise
    }//end of function getAIMove()
    
    func checkGameStatus() -> Promise<String> {
        let checkGameOverURL = getCheckGameOverURL()
        
        return Promise<String> { seal -> Void in
            print("making api call to check if game is over at url: \(checkGameOverURL)")
            print("----------------------------------------------")
            print("with parameters: game_id=\(gameID!)")
            print("----------------------------------------------")
            Alamofire.request(checkGameOverURL, method: .post, parameters: ["game_id": gameID!], encoding: JSONEncoding.default).responseJSON { response in
                print("response is: \(response)")
                print("----------------------------------------------")
                
                if response.result.isSuccess {
                    let statusJSON: JSON = JSON(response.result.value!)
                    let status = statusJSON["status"].stringValue
                    print("check mate status is: \(status)")
                    
                    seal.fulfill(status)
                }
                
                if response.error != nil {
                    seal.reject(response.error!)
                }
            }//end of alamofire
        }//end of promise
    }//end of function checkGameStatus()
}

extension UIDevice {
    
    func detectDeviceSize() -> Int{
        let height = UIScreen.main.bounds.size.height
        return Int(height)
    }
}
