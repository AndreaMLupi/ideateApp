//
//  CustomView.swift
//  timeLinesTest3
//
//  Created by Andrea Maria Lupi on 22/02/2020.
//  Copyright © 2020 Andrea Maria Lupi. All rights reserved.
//

import UIKit
import CoreData

public class CustomView: UIView {
    
   
    @IBOutlet weak var myLabel: UILabel!
    
   public var myLabelText : String!
    
    
    override init(frame: CGRect) {

            super.init(frame:frame)

         
            myLabel?.font = .systemFont(ofSize: 15)
            myLabel?.textColor = .black
            myLabel?.text = myLabelText
        
        }

       public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    public class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        }
    
    
    public func commonInit() {
        
        Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
