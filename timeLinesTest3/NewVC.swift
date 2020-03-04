//
//  NewVC.swift
//  timeLinesTest3
//
//  Created by Andrea Maria Lupi on 22/02/2020.
//  Copyright © 2020 Andrea Maria Lupi. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MultipeerConnectivity

class NewVC:  UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceBrowserDelegate ,MCNearbyServiceAdvertiserDelegate {

    
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
       

    var nearby: MCNearbyServiceBrowser!
    var serviceAdvertiser : MCNearbyServiceAdvertiser!
    var recMsg: String!
    var sendMsg: String!
    var hosting: Bool!
       
   
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {

     }

     func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {

     }

    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var connectionButton: UIButton!
    
    public var people: [NSManagedObject] = []

     override func viewDidLoad() {
         
      
         super.viewDidLoad()
        
              peerID = MCPeerID(displayName: UIDevice.current.name)
              mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
              mcSession.delegate = self
              
              nearby = MCNearbyServiceBrowser(peer: self.peerID, serviceType: "123-prova")
              nearby.delegate = self
              
              let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeKeyboard(_:)))
              view.addGestureRecognizer(tap)
              sendBtn.isEnabled = false
              chatTextView.isEditable = false
              hosting = false
              mcSession.disconnect()
              self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "123-prova")
              self.serviceAdvertiser.delegate = self
              self.serviceAdvertiser.startAdvertisingPeer()
        
                                     
        let alert3 = UIAlertController(title: "Add a title", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
                                             
            [unowned self] action in
            
                                            

        guard let textField = alert3.textFields?.first,
              let nameToSave = textField.text
            
              else {
              return
        }
          
            self.title = textField.text
            self.save(name: nameToSave)
    }
         
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
         
        alert3.addTextField()
        alert3.addAction(saveAction)
        alert3.addAction(cancelAction)
    
        self.present(alert3, animated: true)
                                    
     }
    @objc func removeKeyboard(_ sender: UITapGestureRecognizer) {
         view.endEditing(true)
     }
  
    @IBAction func sendBtnTapped(_ sender: Any) {
        if inputTextField.text != "" {
            sendMsg = "\n\(peerID.displayName): \(inputTextField.text)\n"
            let message = sendMsg.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            do {
                try self.mcSession.send(message!, toPeers: self.mcSession.connectedPeers, with: .reliable)
            } catch {
                print("error sending")
            }
            chatTextView.text = chatTextView.text + " \nMe: \(inputTextField.text!)\n "
            inputTextField.text = ""
            
        } else {
            let emptyAlert = UIAlertController(title: "Enter a Message", message: nil, preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
    }
    
    
    @IBAction func connectionBtnTapped(_ sender: Any) {
        if mcSession.connectedPeers.count == 0 && !hosting
             {
                 let connectActSheet = UIAlertController(title: "Create", message: "You want to host or Join? ", preferredStyle: .actionSheet)
                 connectActSheet.addAction(UIAlertAction(title: "Host", style: .default, handler: { (action: UIAlertAction) in

                     self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "123-prova", discoveryInfo: nil, session: self.mcSession)
                     self.mcAdvertiserAssistant.start()
                     self.hosting = true
                 }))

                 connectActSheet.addAction(UIAlertAction(title: "Join Chat", style: .default, handler: {
                     (action: UIAlertAction) in
                     let mcBrowser = MCBrowserViewController(serviceType: "123-prova", session: self.mcSession)

                     //                mcBrowser.view.translatesAutoresizingMaskIntoConstraints = false


                     mcBrowser.delegate = self
                     self.present(mcBrowser, animated: true)
                 }))

                 connectActSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                 self.present(connectActSheet, animated: true, completion: nil)

             } else if mcSession.connectedPeers.count == 0 && hosting {
                 let waitActSheet = UIAlertController(title: "Waiting", message: "Waiting for other to join", preferredStyle: .actionSheet)
                 waitActSheet.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: {
                     (action) in
                     self.mcSession.disconnect()
                     self.hosting = false
                 }))
                 waitActSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                 self.present(waitActSheet, animated: true, completion: nil)
             } else {

             }
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
    
    @objc func showConnectionPrompt() {
         let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
         ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
         ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
         ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
         present(ac, animated: true)
       }
       
       func startHosting(action: UIAlertAction) {
         mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "123-prova", discoveryInfo: nil, session: mcSession)
         mcAdvertiserAssistant.start()
         print("I started hosting a session!")
       }

       func joinSession(action: UIAlertAction) {
         let mcBrowser = MCBrowserViewController(serviceType: "123-prova", session: mcSession)
         mcBrowser.delegate = self
         present(mcBrowser, animated: true)
         
       }
       
       func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
           switch state {
            
           case MCSessionState.connected:
               print("Connected\(peerID.displayName)")
           case MCSessionState.connecting:
               print("Connecting\(peerID.displayName)")
           case MCSessionState.notConnected:
               print(" Not Connected\(peerID.displayName)")
           @unknown default: break
               
    
         
           }
           
           if mcSession.connectedPeers.count == 0 {
               sendBtn.isEnabled = false
           } else {
               sendBtn.isEnabled = true
           }
       }
       
       func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
           DispatchQueue.main.async {
               self.recMsg = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as String?
               self.chatTextView.text = self.chatTextView.text + self.recMsg
           }
       }
       
       func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
           
       }
       
       func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
           
       }
       
       func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
           
       }
       func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
           NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
       }

       
       func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
           NSLog("%@", "didReceiveInvitationFromPeer \(peerID.displayName)")
           invitationHandler(true, self.mcSession)
       }
       
       func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
           dismiss(animated: true, completion: nil)
       }
       
       func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
           dismiss(animated: true, completion: nil)
       }
       
       }


    
 
     

