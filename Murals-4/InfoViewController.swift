//
//  InfoViewController.swift
//  Murals-4
//
//  Created by Marc Beepath on 12/12/2022.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    
    var info = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = info

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
