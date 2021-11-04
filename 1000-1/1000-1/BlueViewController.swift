//
//  blueViewController.swift
//  1000-1
//
//  Created by Sodik Petrov on 21.09.2021.
//

import UIKit

class BlueViewController: UIViewController {

    @IBOutlet weak var testLable: UILabel!
    var textForLabel = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        testLable.text = textForLabel
        
    }
    @IBAction func goToGreenController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "greenVC")
        vc.title = "Green"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
