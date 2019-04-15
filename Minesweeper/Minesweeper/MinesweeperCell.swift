//
//  MinesweeperCell.swift
//  Minesweeper
//
//  Created by RiiD on 23/03/2019.
//  Copyright © 2019 RiiD. All rights reserved.
//

import UIKit

class MinesweeperCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var onTouchHandler: (() -> Void)?
    var onLongTouchHandler: (() -> Void)?
    
    public func set(label: String) {
        self.label.text = label
    }
    
    @IBAction func onTouch(sender: UITapGestureRecognizer) {
        print("touch")
    }
    
    @IBAction func onLongTouch(sender: UILongPressGestureRecognizer) {
        print("Long touch")
    }
}
