//
//  StartScreen.swift
//  ChessApp
//
//  Created by Mihir Salunke on 5/27/20.
//  Copyright © 2020 Mihir Salunke. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ViewController
        
        if segue.identifier == "singleplayer" {
            destinationVC.gameMode = "singleplayer"
            destinationVC.isAgainstAI = true
        }
        
        if segue.identifier == "multiplayer" {
            destinationVC.gameMode = "multiplayer"
            //destinationVC.setGameMode(mode: segue.identifier!)
            destinationVC.isAgainstAI = false
        }
    }

}
