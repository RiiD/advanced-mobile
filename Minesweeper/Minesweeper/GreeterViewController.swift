//
//  ViewController.swift
//  Minesweeper
//
//  Created by RiiD on 19/03/2019.
//  Copyright © 2019 RiiD. All rights reserved.
//

import UIKit

class GreeterViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var difficultyPicker: UISegmentedControl!
    
    // https://stackoverflow.com/a/8993394
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "StartGameSegue" {
            guard let name = nameField?.text else { return false }
            if name == "" {
                shakeNameInput()
                return false
            } else {
                return true
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGameSegue" {
            guard
                let name = nameField?.text,
                let difficulty = difficultyPicker?.selectedSegmentIndex,
                let gameVC = segue.destination as? GameViewController
                else { return }
            gameVC.game = Minesweeper(difficulty: difficulty, playerName: name)
            gameVC.game.delegate = gameVC
        }
    }
    
    // https://stackoverflow.com/a/27988876
    private func shakeNameInput() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation .autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: nameField.center.x - 10, y: nameField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: nameField.center.x + 10, y: nameField.center.y))
        
        nameField.layer.add(animation, forKey: "position")
    }
    
    @IBAction func unwindAction(segue: UIStoryboardSegue) {
    }
}

