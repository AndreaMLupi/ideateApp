//
//  ViewController.swift
//  TimeLine2
//
//  Created by Andrea Maria Lupi on 21/02/2020.
//  Copyright © 2020 Andrea Maria Lupi. All rights reserved.
//
import CoreData
import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
      
        
    }
    
    
 
         
  

    @IBOutlet weak var tableView: UITableView!

    
    var people: [NSManagedObject] = []
    
    @IBAction func addName(_ sender: Any) {
             let alert = UIAlertController(title: "Brainstorming", message: "Add a new Session", preferredStyle: UIAlertController.Style.alert)
        
   
            alert.addAction(UIAlertAction(title: "New", style: UIAlertAction.Style.default, handler:{(alert:UIAlertAction) -> Void in
                            
            self.performSegue(withIdentifier: "nextNew", sender: self)}))
             
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    // show the alert
                    self.present(alert, animated: true)
             

    }
    


    
    func save(name: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "ShareEntity",
                                   in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
        person.setValue(name, forKeyPath: "shareLabel")
      
      // 4
      do {
        try managedContext.save()
        people.insert(person, at: 0)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
   
 
 
    override func viewDidLoad() {
          
         super.viewDidLoad()
  
          
          title = "The List"
       tableView.tableFooterView = UIView(frame: .zero)
        
  
     
        }
   
    
    
    
    override func viewWillAppear(_ animated: Bool) {
     
        DispatchQueue.main.async {
            
           
          
                   self.tableView.reloadData()
                   self.tableView.beginUpdates()
                   self.tableView.endUpdates()
               }
      super.viewWillAppear(animated)
        
     
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
       let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "ShareEntity")
              let sort = NSSortDescriptor(key: #keyPath(ShareEntity.shareLabel), ascending: true)
              fetchRequest.sortDescriptors = [sort]
   
      //3
      do {
        people = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }

  

        // Do any additional setup after loading the view.
    }




extension ViewController: UITableViewDataSource {
    
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {

    let person = people[indexPath.row]
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "Cell",
                                    for: indexPath)
    cell.textLabel?.text =
    person.value(forKeyPath: "shareLabel") as? String
    cell.textLabel?.font = .systemFont(ofSize: 28, weight: .light)
    return cell
  }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         let persons = people[indexPath.row]
        let personEntity = "ShareEntity" //Entity Name
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       
        
      if editingStyle == .delete {

            
         managedContext.delete(persons)

        
      
        
        do {
        
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: personEntity)
        

            do {
                people = try managedContext.fetch(fetchRequest) as! [ShareEntity]
            } catch let error as NSError {
                print("Error While Fetching Data From DB: \(error.userInfo)")
              
                      
            }
        
   
      
        tableView.deleteRows(at: [indexPath], with: .fade)
         guard let appDelegate =
                      UIApplication.shared.delegate as? AppDelegate else {
                          return
                  }
        let managedContext =
                     appDelegate.persistentContainer.viewContext
                  managedContext.delete(people[indexPath.row] as NSManagedObject)
       try? managedContext.save()

        
           
        
        }
 


    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "next", sender: self)
            }
    
 
          
}
