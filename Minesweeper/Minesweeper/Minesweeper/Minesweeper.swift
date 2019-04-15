//
//  Minesweeper.swift
//  Minesweeper
//
//  Created by RiiD on 19/03/2019.
//  Copyright © 2019 RiiD. All rights reserved.
//

import Foundation

class Minesweeper {
    public var delegate: MinesweeperDelegate?
    
    private let size: Int
    private let numberOfMines: Int
    private let difficulty: Int
    private let playerName: String
    
    private lazy var mineMap: [[Bool]] = {
        var mineMap = [[Bool]](repeating: [Bool](repeating: false, count: size), count: size)
        var i = 0
        while i < numberOfMines {
            let randomRow = Int.random(in: 0 ..< size)
            let randomCol = Int.random(in: 0 ..< size)
            if !mineMap[randomRow][randomCol] {
                mineMap[randomRow][randomCol] = true
                i = i + 1
            }
        }
        
        return mineMap
    }()
    
    private lazy var revealedMap: [[Bool]] = {
        return [[Bool]](repeating: [Bool](repeating: false, count: size), count: size)
    }()
    private lazy var flagMap: [[Bool]] = {
        return [[Bool]](repeating: [Bool](repeating: false, count: size), count: size)
    }()
    
    private var isStarted = false
    private var isOver = false
    
    private var timeElapsed = 0
    private var timer = Timer()
    
    init(difficulty: Int, playerName: String) {
        self.difficulty = difficulty
        self.playerName = playerName
        switch difficulty {
        case 0:
            size = 5
            numberOfMines = 5
            break
        case 1:
            size = 10
            numberOfMines = 20
            break
        case 2:
            size = 10
            numberOfMines = 30
            break
        default:
            size = 10
            numberOfMines = 30
        }
    }
    
    func getPlayerName() -> String {
        return playerName
    }
    
    func getDiffuculty() -> Int {
        return difficulty
    }
    
    func getElapsedTime() -> Int {
        return timeElapsed
    }
    
    public func isWin() -> Bool {
        return mineMap == flagMap
    }
    
    public func reveal(row: Int, col: Int) {
        print("reveal", col, row)
        
        if !isStarted {
            start()
        }
        if isOver || flagMap[row][col] || revealedMap[row][col] { return }
        
        revealedMap[row][col] = true
        
        delegate?.stateChanged(forRow: row, forCol: col)
        if isMine(row: row, col: col) || isWin() {
            end()
            return
        }
        
        if getMinesCount(row: row, col: col) == 0 {
            revealNeighbors(row, col)
        }
    }
    
    public func toggleFlag(row: Int, col: Int) {
        print("flag", col, row)
        
        if !isStarted {
            start()
        }
        if isOver || revealedMap[row][col] { return }
        
        flagMap[row][col] = !flagMap[row][col]
        
        if isWin() {
            end()
        } else {
            delegate?.stateChanged(forRow: row, forCol: col)
        }
    }
    
    public func isMine(row: Int, col: Int) -> Bool {
        return mineMap[row][col]
    }
    
    public func isFlagged(row: Int, col: Int) -> Bool {
        return flagMap[row][col]
    }
    
    public func isRevealed(row: Int, col: Int) -> Bool {
        return revealedMap[row][col]
    }
    
    // Cache?
    public func getMinesCount(row: Int, col: Int) -> Int {
        let rowStart = max(0, row - 1)
        let rowEnd = min(size - 1, row + 1)
        let colStart = max(0, col - 1)
        let colEnd = min(size - 1, col + 1)
        
        var count = 0
        for neighborRow in rowStart ... rowEnd {
            for neighborCol in colStart ... colEnd {
                if (neighborRow != row || neighborCol != col) && mineMap[neighborRow][neighborCol] {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    public func getSize() -> Int {
        return size
    }
    
    private func start() {
        print("Game start")
        isStarted = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            guard let strongSelf = self else {
                timer.invalidate()
                return
            }
            
            strongSelf.tick()
        }
        delegate?.stateChanged(time: 0)
    }
    
    private func tick() {
        print("Tick")
        timeElapsed += 1
        delegate?.stateChanged(time: timeElapsed)
    }
    
    private func end() {
        print("Game end")
        isOver = true
        timer.invalidate()
        delegate?.stateChanged(withResult: isWin())
    }
    
    private func revealNeighbors(_ row: Int, _ col: Int) {
        let rowStart = max(0, row - 1)
        let rowEnd = min(size - 1, row + 1)
        let colStart = max(0, col - 1)
        let colEnd = min(size - 1, col + 1)
        
        for neighborRow in rowStart ... rowEnd {
            for neighborCol in colStart ... colEnd {
                if (neighborRow != row || neighborCol != col) && !isRevealed(row: neighborRow, col: neighborCol) {
                    reveal(row: neighborRow, col: neighborCol)
                }
            }
        }
    }
}
