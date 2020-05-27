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
        
        //pieces rules
        if identifyPiece(movingPiece) == "Knight" {
            return isValidKnightMove(for: movingPiece, fromRow: fromRow, fromCol: fromCol, toRow: toRow, toCol: toCol)
        } else if identifyPiece(movingPiece) == "Bishop" {
            return isValidBishopMove(for: movingPiece, fromRow: fromRow, fromCol: fromCol, toRow: toRow, toCol: toCol)
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
}
