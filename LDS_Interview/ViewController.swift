//
//  ViewController.swift
//  LDS_Interview
//
//  Created by Jeremy Barger on 12/17/19.
//  Copyright © 2019 Jeremy Barger. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ProfilePicTableViewController: UITableViewController {

    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Person.self))
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self as NSFetchedResultsControllerDelegate
                    return frc
        }()
        override func viewDidLoad() {
            super.viewDidLoad()
            updateContent()
            
        }
        
        func updateContent() {
            do {
                try self.fetchedhResultController.performFetch()
                print(fetchedhResultController.fetchedObjects as Any)
                print("count fetched: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
            } catch let error {
                print(error.localizedDescription)
            }
            
            let client = HttpClient()
            client.getDataWith { result in
              switch result {
                case .Success(let data):
                    self.clearData()
                    self.saveToCoreDataWith(array: data)
                    
                case .Error(let message):
                    DispatchQueue.main.async {
                        self.showAlertWith(title: "Error", message: message)
                    }
                }
                
            }
        }
        
        private func createPersonEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            if let personEntity = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as? Person {
                personEntity.id = (dictionary["id"] as! Int16)
                personEntity.firstName = dictionary["firstName"] as? String
                personEntity.lastName = dictionary["lastName"] as? String
                personEntity.birthDate = dictionary["birthdate"] as? String
                personEntity.profilePic = dictionary["profilePicture"] as? String
                personEntity.forceSensitive = (dictionary["forceSensitive"] as! Bool)
                personEntity.affiliation = dictionary["affiliation"] as? String
                
                
                return personEntity
            }
            return nil
        }

        // MARK: Data and web call functions
        
        func saveToCoreDataWith(array: [[String: AnyObject]]) {
            _ = array.map{self.createPersonEntityFrom(dictionary: $0)}
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
        
        private func clearData() {
            do {
                let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Person.self))
                
                do {
                    let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                    _ = objects.map{$0.map{context.delete($0)}}
                    CoreDataStack.sharedInstance.saveContext()
                } catch let error {
                    print("Error deleting: \(error.localizedDescription)")
                }
            }
            
            
        }
        
        // MARK: ui and tableview functions
        
        func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            let action = UIAlertAction(title: title, style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePicCell", for: indexPath) as! ProfilePicCell
            
            if let person = fetchedhResultController.object(at: indexPath) as? Person {
                cell.setPersonCellWith(person: person)
            }
            
            return cell
        }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let count = fetchedhResultController.sections?.first?.numberOfObjects {
              return count
            }
            
            return 0
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 70
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fetchedhResultController.object(at: indexPath) as? Person
                let controller = (segue.destination as! DetailViewController)
                
                controller.person = object
            }
        }
    }

    

}

    extension ProfilePicTableViewController: NSFetchedResultsControllerDelegate {
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            switch type {
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            default:
                break
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.tableView.endUpdates()
        }
        
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
        }
    }





