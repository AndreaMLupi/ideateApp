//
//  CustomViewController.swift
//  timeLinesTest3
//
//  Created by Andrea Maria Lupi on 23/02/2020.
//  Copyright © 2020 Andrea Maria Lupi. All rights reserved.
//

import UIKit
import CoreData


public class CustomViewController: UIViewController {

    @IBOutlet var publicView: UIView!
    let myLabel = UILabel()
                  
    
    override public func viewDidLoad() {
        myLabel.text = "ottimismo"
        myLabel.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        super.viewDidLoad()
        publicView.addSubview(myLabel)

        // Do any additional setup after loading the view.
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
