//
//  MinesweeperDelegate.swift
//  Minesweeper
//
//  Created by RiiD on 19/03/2019.
//  Copyright © 2019 RiiD. All rights reserved.
//

import Foundation

protocol MinesweeperDelegate {
    func stateChanged(forRow row: Int, forCol col: Int)
    func stateChanged(withResult isWin: Bool)
    func stateChanged(time: Int)
}
