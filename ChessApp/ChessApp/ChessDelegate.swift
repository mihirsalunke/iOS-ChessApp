//
//  ChessDelegate.swift
//  ChessApp
//
//  Created by Mihir Salunke on 5/26/20.
//  Copyright © 2020 Mihir Salunke. All rights reserved.
//

import Foundation

protocol ChessDelegate {
  func makePlayerMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int)
}
