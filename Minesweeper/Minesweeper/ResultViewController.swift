//
//  ResultViewController.swift
//  Minesweeper
//
//  Created by RiiD on 13/04/2019.
//  Copyright © 2019 RiiD. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var game: Minesweeper!
    
    override func viewWillAppear(_ animated: Bool) {
        playerNameLabel.text = game.getPlayerName()
        timeLabel.text = String(game.getElapsedTime()) + " seconds"
        switch game.getDiffuculty() {
        case 0:
            difficultyLabel.text = "Easy"
            break
        case 1:
            difficultyLabel.text = "Medium"
            break
        case 2:
            difficultyLabel.text = "Hard"
            break
        default:
            difficultyLabel.text = "Hard"
            break
        }
        
        if game.isWin() {
            titleLabel.text = "You win"
        } else {
            titleLabel.text = "You lose"
        }
    }
}
