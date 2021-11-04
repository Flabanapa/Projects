//
//  GameViewController.swift
//  1000-1
//
//  Created by Sodik Petrov on 19.09.2021.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    lazy var  game = Game(countItems: buttons.count) { [weak self](status, time) in
        guard let self = self else {return}
        
        
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()

    }

    @IBAction func pressButton(_ sender: UIButton) {
        
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return}
        game.check(index:buttonIndex)
        
        updateUI()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    private func setupScreen(){
        
        for index in game.items.indices{
            
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
        }
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI(){
        for index in game.items.indices{
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            if game.items[index].isError{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self](_) in
                    self?.buttons[index].backgroundColor = .lightGray
                    self?.game.items[index].isError = false
                }

            }
        }
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)

    }
    
    private func updateInfoGame(with status:StatusGame){
        switch status {
        case .start:
            statusLable.text = "Start"
            statusLable.textColor = .black
            newGameButton.isHidden = true
            
        case .win:
            statusLable.text = "You Win"
            statusLable.textColor = .green
            newGameButton.isHidden = false
            if game.isNewRecord{
                showAlert()
            }else{
                showAlertActionSheet()
            }
            
        case .lose:
            statusLable.text = "You Lose"
            statusLable.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
            
        }
    }
    
    private func showAlert(){
        
        let alert = UIAlertController(title: "Congratulation", message: "New Record!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertActionSheet(){
        let alert = UIAlertController(title: "Next", message: nil, preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: "New Game", style: .default) { [weak self](_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        let showRecord =  UIAlertAction(title: "Watch the record", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        let menuAction = UIAlertAction(title: "Menu", style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController{
            popover.sourceView = statusLable
            
        }
        
        present(alert, animated: true, completion: nil)
    }
}
