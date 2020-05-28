//
//  ChessEngine.swift
//  ChessApp
//
//  Created by Mihir Salunke on 5/26/20.
//  Copyright © 2020 Mihir Salunke. All rights reserved.
//

import Foundation

struct ChessEngine {
    var pieces = Set<ChessPiece>()
    
    func pieceAt(col: Int, row: Int) -> ChessPiece? {
        for piece in pieces {
            if piece.col == col && piece.row == row {
                return piece
            }
        }
        return nil
    }
    
    mutating func movePiece(piece movingPiece: ChessPiece, toCol: Int, toRow: Int) {
        pieces.remove(movingPiece)
        pieces.insert(ChessPiece(col: toCol, row: toRow, imageName: movingPiece.imageName))
    }
    
    mutating func initializeGame() {
        pieces.removeAll()
        
        pieces.insert(ChessPiece(col: 0, row: 0, imageName: "Rook-black"))
        pieces.insert(ChessPiece(col: 7, row: 0, imageName: "Rook-black"))
        pieces.insert(ChessPiece(col: 0, row: 7, imageName: "Rook-white"))
        pieces.insert(ChessPiece(col: 7, row: 7, imageName: "Rook-white"))
        
        pieces.insert(ChessPiece(col: 1, row: 0, imageName: "Knight-black"))
        pieces.insert(ChessPiece(col: 6, row: 0, imageName: "Knight-black"))
        pieces.insert(ChessPiece(col: 1, row: 7, imageName: "Knight-white"))
        pieces.insert(ChessPiece(col: 6, row: 7, imageName: "Knight-white"))
        
        pieces.insert(ChessPiece(col: 2, row: 0, imageName: "Bishop-black"))
        pieces.insert(ChessPiece(col: 5, row: 0, imageName: "Bishop-black"))
        pieces.insert(ChessPiece(col: 2, row: 7, imageName: "Bishop-white"))
        pieces.insert(ChessPiece(col: 5, row: 7, imageName: "Bishop-white"))
        
        pieces.insert(ChessPiece(col: 3, row: 0, imageName: "Queen-black"))
        pieces.insert(ChessPiece(col: 3, row: 7, imageName: "Queen-white"))
        
        pieces.insert(ChessPiece(col: 4, row: 0, imageName: "King-black"))
        pieces.insert(ChessPiece(col: 4, row: 7, imageName: "King-white"))
        
        pieces.insert(ChessPiece(col: 0, row: 1, imageName: "Pawn-black"))
        pieces.insert(ChessPiece(col: 1, row: 1, imageName: "Pawn-black"))
        pieces.insert(ChessPiece(col: 2, row: 1, imageName: "Pawn-black"))
        pieces.insert(ChessPiece(col: 3, row: 1, imageName: "Pawn-black"))
        pieces.insert(ChessPiece(col: 4, row: 1, imageName: "Pawn-black"))
        pieces.insert(ChessPiece(col: 5, row: 1, imageName: "Pawn-black"))
        pieces.insert(ChessPiece(col: 6, row: 1, imageName: "Pawn-black"))
        pieces.insert(ChessPiece(col: 7, row: 1, imageName: "Pawn-black"))
        
        pieces.insert(ChessPiece(col: 0, row: 6, imageName: "Pawn-white"))
        pieces.insert(ChessPiece(col: 1, row: 6, imageName: "Pawn-white"))
        pieces.insert(ChessPiece(col: 2, row: 6, imageName: "Pawn-white"))
        pieces.insert(ChessPiece(col: 3, row: 6, imageName: "Pawn-white"))
        pieces.insert(ChessPiece(col: 4, row: 6, imageName: "Pawn-white"))
        pieces.insert(ChessPiece(col: 5, row: 6, imageName: "Pawn-white"))
        pieces.insert(ChessPiece(col: 6, row: 6, imageName: "Pawn-white"))
        pieces.insert(ChessPiece(col: 7, row: 6, imageName: "Pawn-white"))
    }
    
    func identifyPiece(_ piece: ChessPiece) -> String {
        if piece.imageName == "Knight-white" || piece.imageName == "Knight-black" {
            return "Knight"
        } else if piece.imageName == "Bishop-white" || piece.imageName == "Bishop-black" {
            return "Bishop"
        } else if piece.imageName == "Rook-white" || piece.imageName == "Rook-black" {
            return "Rook"
        } else if piece.imageName == "King-white" || piece.imageName == "King-black" {
            return "King"
        } else if piece.imageName == "Queen-white" || piece.imageName == "Queen-black" {
            return "Queen"
        } else if piece.imageName == "Pawn-white" || piece.imageName == "Pawn-black" {
            return "Pawn"
        }
        return "Invalid Piece"
    }
    
    func identifyPieceColor(_ piece: ChessPiece) -> String {
        if piece.imageName == "Knight-white" || piece.imageName == "Bishop-white" || piece.imageName == "Rook-white" || piece.imageName == "King-white" || piece.imageName == "Queen-white" || piece.imageName == "Pawn-white" {
            return "white"
        } else if piece.imageName == "Knight-black" || piece.imageName == "Bishop-black" || piece.imageName == "Rook-black" || piece.imageName == "King-black" || piece.imageName == "Queen-black" || piece.imageName == "Pawn-black" {
            return "black"
        }
        return "Invalid Piece"
    }
    
    mutating func isMoveValid(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        
        //checking if the source location contains a piece
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        
        //checking if the moving piece is within the board frame
        if toCol < 0 || toCol > 7 || toRow < 0 || toRow > 7 {
            return false
        }
        
        //checking if the move follows pieces rules
        if identifyPiece(movingPiece) == "Knight" {
            return isValidKnightMove(for: movingPiece, fromRow: fromRow, fromCol: fromCol, toRow: toRow, toCol: toCol)
        } else if identifyPiece(movingPiece) == "Bishop" {
            return isValidBishopMove(for: movingPiece, fromRow: fromRow, fromCol: fromCol, toRow: toRow, toCol: toCol)
        } else if identifyPiece(movingPiece) == "Rook" {
            return isValidRookMove(for: movingPiece, fromRow: fromRow, fromCol: fromCol, toRow: toRow, toCol: toCol)
        } else if identifyPiece(movingPiece) == "King" {
            return isValidKingMove(for: movingPiece, fromRow: fromRow, fromCol: fromCol, toRow: toRow, toCol: toCol)
        } else if identifyPiece(movingPiece) == "Queen" {
            return isValidQueenMove(for: movingPiece, fromRow: fromRow, fromCol: fromCol, toRow: toRow, toCol: toCol)
        } else if identifyPiece(movingPiece) == "Pawn" {
            return isValidPawnMove(for: movingPiece, fromRow: fromRow, fromCol: fromCol, toRow: toRow, toCol: toCol)
        }
        return false
    }
    
    mutating func isValidKnightMove(for movingPiece: ChessPiece, fromRow: Int, fromCol: Int, toRow: Int, toCol: Int) -> Bool {
        if (abs(toCol - fromCol) == 1 && abs(toRow - fromRow) == 2) || (abs(toCol - fromCol) == 2 && abs(toRow - fromRow) == 1) {
            if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                pieces.remove(pieceAt(col: toCol, row: toRow)!)
            } else if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) == identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                return false
            }
            return true
        }
        return false
    }
    
    mutating func isValidBishopMove(for movingPiece: ChessPiece, fromRow: Int, fromCol: Int, toRow: Int, toCol: Int) -> Bool {
        if abs(toCol - fromCol) == abs(toRow - fromRow) {
            
            if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                pieces.remove(pieceAt(col: toCol, row: toRow)!)
            } else if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) == identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                return false
            }
            return true
        }
        return false
    }
    
    mutating func isValidRookMove(for movingPiece: ChessPiece, fromRow: Int, fromCol: Int, toRow: Int, toCol: Int) -> Bool {
        if abs(toCol - fromCol) == 0 || abs(toRow - fromRow) == 0 {
            
            if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                pieces.remove(pieceAt(col: toCol, row: toRow)!)
            } else if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) == identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                return false
            }
            return true
        }
        return false
    }
    
    mutating func isValidQueenMove(for movingPiece: ChessPiece, fromRow: Int, fromCol: Int, toRow: Int, toCol: Int) -> Bool {
        if abs(toCol - fromCol) == abs(toRow - fromRow) || abs(toCol - fromCol) == 0 || abs(toRow - fromRow) == 0 {

            if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                pieces.remove(pieceAt(col: toCol, row: toRow)!)
            } else if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) == identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                return false
            }
            return true
        }
        return false
    }
    
    mutating func isValidKingMove(for movingPiece: ChessPiece, fromRow: Int, fromCol: Int, toRow: Int, toCol: Int) -> Bool {
        
        //check castle move
        if fromRow == toRow && (fromRow == 0 && identifyPieceColor(movingPiece) == "black") {
            if (fromCol == 4 && toCol == 6) {
                if pieceAt(col: toCol, row: toRow) != nil {
                    return false
                }
                movePiece(piece: pieceAt(col: 7, row: 0)!, toCol: 5, toRow: 0)
                return true
            }
            if (fromCol == 4 && toCol == 2) {
                if pieceAt(col: toCol, row: toRow) != nil {
                    return false
                }
                movePiece(piece: pieceAt(col: 7, row: 0)!, toCol: 5, toRow: 0)
                return true
            }
        }
        if fromRow == toRow && (fromRow == 7 && identifyPieceColor(movingPiece) == "white") {
            if (fromCol == 4 && toCol == 6) {
                if pieceAt(col: toCol, row: toRow) != nil {
                    return false
                }
                movePiece(piece: pieceAt(col: 7, row: 7)!, toCol: 5, toRow: 7)
                return true
            }
            if (fromCol == 4 && toCol == 2) {
                if pieceAt(col: toCol, row: toRow) != nil {
                    return false
                }
                movePiece(piece: pieceAt(col: 7, row: 7)!, toCol: 5, toRow: 7)
                return true
            }
        }
        
        //check normal king move
        let differenceInRows = abs(toRow - fromRow)
        let differenceInCols = abs(toCol - fromCol)
        
        if case 0...1 = differenceInRows {
            if case 0...1 = differenceInCols {
                if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                    pieces.remove(pieceAt(col: toCol, row: toRow)!)
                } else if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) == identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                    return false
                }
                return true
            }
        }
        return false
    }
    
    mutating func isValidPawnMove(for movingPiece: ChessPiece, fromRow: Int, fromCol: Int, toRow: Int, toCol: Int) -> Bool {
        
        //tries to advance by 2
        if fromCol == toCol {
            if (fromRow == 1 && toRow == 3 && identifyPieceColor(movingPiece) == "black") || (fromRow == 6 && toRow == 4 && identifyPieceColor(movingPiece) == "white") {
                if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                    pieces.remove(pieceAt(col: toCol, row: toRow)!)
                } else if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) == identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                    return false
                }
                return true
            }
        }
        
        //tries to advance by 1
        var moveForward = 0
            
        if identifyPieceColor(movingPiece) == "black" {
            moveForward = 1
        } else {
            moveForward = -1
        }
        
        //tries enpassant
        if toRow == fromRow + moveForward {
            if (toCol == fromCol - 1) || (toCol == fromCol + 1) {
                if fromRow == 4 && toRow == 5 && identifyPieceColor(movingPiece) == "black" {
                    if pieceAt(col: toCol, row: toRow) == nil {
                        if pieceAt(col: toCol, row: toRow + moveForward) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow + moveForward)!) {
                            pieces.remove(pieceAt(col: toCol, row: toRow + moveForward)!)
                            return true
                        }
                    }
                }
            }
            if (toCol == fromCol - 1) || (toCol == fromCol + 1) {
                if fromRow == 3 && toRow == 2 && identifyPieceColor(movingPiece) == "white" {
                    if pieceAt(col: toCol, row: toRow) == nil {
                        if pieceAt(col: toCol, row: toRow + moveForward) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow + moveForward)!) {
                            pieces.remove(pieceAt(col: toCol, row: toRow + moveForward)!)
                            return true
                        }
                    }
                }
            }
        }
            
        //tries to move by 1
        if toRow == fromRow + moveForward {
            if (toCol == fromCol - 1) || (toCol == fromCol) || (toCol == fromCol + 1) {
                if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) != identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                    pieces.remove(pieceAt(col: toCol, row: toRow)!)
                } else if pieceAt(col: toCol, row: toRow) != nil && identifyPieceColor(movingPiece) == identifyPieceColor(pieceAt(col: toCol, row: toRow)!) {
                    return false
                }
                return true
            }
        }
        return false
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
}
