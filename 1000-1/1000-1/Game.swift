//
//  Game.swift
//  1000-1
//
//  Created by Sodik Petrov on 19.09.2021.
//

import Foundation

enum StatusGame{
    case start
    case win
    case lose
}

class Game{
    
    
    struct Item {
        var title:String
        var isFound = false
        var isError = false
    }
    private let data = Array(1...99)
    
    var items:[Item] = []
    
    private var countItems:Int
    
    var nextItem:Item?
    
    
    var isNewRecord = false
    var status:StatusGame = .start{
        didSet{
            if status != .start{
                if status == .win{
                    let newRecord = timeForGame - secondsGame
                    
                    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
                    
                    if record == 0 || newRecord < record{
                        UserDefaults.standard.setValue(newRecord, forKey: KeysUserDefaults.recordGame)
                        isNewRecord = true
                    }
                }
                stopGame()
            }
        }
    }
    private var timeForGame:Int
    private var secondsGame:Int{
        didSet{
            if secondsGame <= 0{
                status = .lose
                
            }
            if secondsGame < 0{
                secondsGame = 0
            }
            updateTimer(status,secondsGame)
        }
    }
    
    private var timer:Timer?
    private var updateTimer:((StatusGame,Int)->Void)
    
    init(countItems:Int, updateTimer:@escaping (_ status:StatusGame,_ seconds:Int)->Void){
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.countItems = countItems
        self.secondsGame = self.timeForGame
        self.updateTimer = updateTimer
        setupGame()
    }
    func setupGame(){
        isNewRecord = false
        var digits = data.shuffled()
        items.removeAll()
        while items.count < countItems{
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
            
        }
        updateTimer(status,secondsGame)
        
        nextItem = items.shuffled().first
        
        if Settings.shared.currentSettings.timerState{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](_) in
                self?.secondsGame -= 1
                print("LOL")
                            })
        }
        
    }
    
    func newGame(){
        status = .start
        self.secondsGame = self.timeForGame
        setupGame()
    }
    func check(index:Int){
        guard status == .start else{return}
        
        if items[index].title == nextItem?.title{
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { (item) -> Bool in
                item.isFound == false
            })

        }else{
            items[index].isError = true
            
        }
        if items[index].isError == true{
            self.secondsGame -= 2
        }
        
    
        
        if nextItem == nil{
            status = .win
        }
        
    }
    func stopGame(){
        timer?.invalidate()
    }
}


extension Int{
    func secondsToString()->String{
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%d:%02d", minutes,seconds)
    }
}
