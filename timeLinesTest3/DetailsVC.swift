//
//  File.swift
//  timeLinesTest3
//
//  Created by Andrea Maria Lupi on 22/02/2020.
//  Copyright © 2020 Andrea Maria Lupi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailsVC: UIViewController {
    
    @IBOutlet weak var checkPointName: UILabel!
      var checkPoints: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let point1 = CGPoint(x: 59.5, y: 200)
             let point2 = CGPoint(x: 59.5, y: 500)
             addLine(fromPoint: point1, toPoint: point2)
        
//        checkPointName.text =
        
        guard let appDelegate =
             UIApplication.shared.delegate as? AppDelegate else {
               return
           }
           
           let managedContext =
             appDelegate.persistentContainer.viewContext
           
           //2
            let fetchRequest =
                   NSFetchRequest<NSManagedObject>(entityName: "Check")
                   let sort = NSSortDescriptor(key: #keyPath(Check.checkPoint), ascending: true)
                   fetchRequest.sortDescriptors = [sort]
        
            
             
         
         
           
           //3
           do {
             checkPoints = try managedContext.fetch(fetchRequest)
           } catch let error as NSError {
             print("Could not fetch. \(error), \(error.userInfo)")
           }
         
        
     
      
    
}
    
    func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
            let line = CAShapeLayer()
            let linePath = UIBezierPath()
            linePath.move(to: start)
            linePath.addLine(to: end)
            line.path = linePath.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 0.5
            line.lineJoin = CAShapeLayerLineJoin.round
            self.view.layer.addSublayer(line)
        }
     }

