//
//  greenViewController.swift
//  1000-1
//
//  Created by Sodik Petrov on 21.09.2021.
//

import UIKit

class greenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    
    @IBAction func goToRoot(_ sender: Any) {
      //  self.navigationController?.popToRootViewController(animated: true)

    if let viewControllers = self.navigationController?.viewControllers{
        for vc in viewControllers{
            if vc is YellowViewController{
                self.navigationController?.popToViewController(vc, animated: true)
            }

        }
    }
}
}
