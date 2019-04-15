//
//  MinesweeperCollectionViewAdapter.swift
//  Minesweeper
//
//  Created by RiiD on 22/03/2019.
//  Copyright © 2019 RiiD. All rights reserved.
//

import UIKit

class MinesweeperCollectionViewAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, MinesweeperDelegate {
    private var game: Minesweeper
    private let cv: UICollectionView
    
    init(game: Minesweeper, cv: UICollectionView) {
        self.game = game
        self.cv = cv
        super.init()
        game.delegate = self
        cv.delegate = self
        cv.dataSource = self
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
        
        if game.isFlagged(row: row, col: col) {
            cell.set(label: "F")
        } else if game.isRevealed(row: row, col: col) {
            if game.isMine(row: row, col: col) {
                cell.set(label: "*")
            } else {
                cell.set(label: String(game.getMinesCount(row: row, col: col)))
            }
        } else {
            cell.set(label: "-")
        }
        
        cell.onTouchHandler = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.game.reveal(row: row, col: col)
        }
        
        return cell
    }
    
    func onGameStateChange() {
        print("onGameStateChange")
        
        cv.collectionViewLayout.invalidateLayout()
        
    }
}
