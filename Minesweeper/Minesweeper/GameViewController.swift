//
//  GameViewController.swift
//  Minesweeper
//
//  Created by RiiD on 20/03/2019.
//  Copyright © 2019 RiiD. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, MinesweeperDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var actionSwitch: UISegmentedControl!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    var game: Minesweeper!
    
    override func viewWillAppear(_ animated: Bool) {
        game.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.getSize()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return game.getSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MinesweeperCell", for: indexPath) as! MinesweeperCell
        let col = indexPath.item, row = indexPath.section
        
        populateCell(cell: cell, row, col)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gameSize = CGFloat(game.getSize())
        
        let width = collectionView.bounds.width / gameSize
        let height = collectionView.bounds.height / gameSize
        return CGSize(width: width, height: height)
    }
    
    func stateChanged(time: Int) {
        timeElapsedLabel.text = "Time elapsed: " + String(time) + " seconds"
    }
    
    func stateChanged(forRow row: Int, forCol col: Int) {
        guard let cell = collectionView.cellForItem(at: IndexPath.init(item: col, section: row)) as? MinesweeperCell else { return }
        populateCell(cell: cell, row, col)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if actionSwitch.selectedSegmentIndex == 0 {
            game.reveal(row: indexPath.section, col: indexPath.item)
        } else {
            game.toggleFlag(row: indexPath.section, col: indexPath.item)
        }
        
    }
    
    func stateChanged(withResult isWin: Bool) {
        performSegue(withIdentifier: "ShowResultSegue", sender: nil)
    }
    
    private func populateCell(cell: MinesweeperCell, _ row: Int, _ col: Int) {
        if game.isFlagged(row: row, col: col) {
            cell.set(label: "🏁")
        } else if game.isRevealed(row: row, col: col) {
            if game.isMine(row: row, col: col) {
                cell.set(label: "💥")
            } else {
                cell.set(label: String(game.getMinesCount(row: row, col: col)))
            }
        } else {
             cell.set(label: "🔲")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResultSegue" {
            guard let resutlVC = segue.destination as? ResultViewController else { return }
            resutlVC.game = game
        }
    }
}
