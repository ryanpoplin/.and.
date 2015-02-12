//
//  ViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/11/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import UIKit
import CoreData

public var categoryTitleProperty: String!

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            return managedObjectContext
            
        } else {
            
            return nil
            
        }
        
        }()
    
    var tableView: UITableView?
    
    var categoryItems = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewCategory")
        self.navigationItem.rightBarButtonItem = addButton
        
        // println(managedObjectContext!)
        
        view.backgroundColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.topItem?.title = "Categories"
        
        tableView = UITableView(frame: CGRectZero, style: .Plain)

        tableView!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CategoryCell")

        var viewFrame = self.view.frame

        viewFrame.size.height -= 400

        viewFrame.size.width -= 700
        
        tableView!.frame = viewFrame
        
        self.view.addSubview(tableView!)
        
        tableView!.dataSource = self
        tableView!.delegate = self
        
        fetchCategory()
        
    }
    
    func fetchCategory() {
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Category] {
            
            categoryItems = fetchResults
            
        }
        
    }
    
    func addNewCategory() {
        
        self.saveNewCategory(textViewData)
        
    }
    
    func saveNewCategory(title: String) {
        
        if title != "" {
            
            var newCategory = Category.createInManagedObjectContext(self.managedObjectContext!, title: title)
            
            self.fetchCategory()
            
            if let newCategoryIndex = find(categoryItems, newCategory) {
                
                let newCategoryItemIndexPath = NSIndexPath(forItem: newCategoryIndex, inSection: 0)
                
                tableView!.insertRowsAtIndexPaths([newCategoryItemIndexPath], withRowAnimation: .Automatic)
                
                save()
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let logItemToDelete = categoryItems[indexPath.row]
            
            let fetchRequest = NSFetchRequest(entityName: "CategoryItem")
            
            let predicate = NSPredicate(format: "category == %@", logItemToDelete.title)
            
            fetchRequest.predicate = predicate
            
            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [CategoryItem] {
                
                var testArr = fetchResults
                
                for x in testArr {
                    
                    managedObjectContext?.deleteObject(x as NSManagedObject)
                    
                }
                
            }
            
            managedObjectContext?.deleteObject(logItemToDelete)
            
            self.fetchCategory()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            save()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItems.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as UITableViewCell
        
        let categoryItem = categoryItems[indexPath.row]
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.textLabel?.text = categoryItem.title
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let categoryItem = categoryItems[indexPath.row]
        
        let drilledDownCategoryViewController = SubViewController()
        
        categoryTitleProperty = categoryItem.title
        
        navigationController?.pushViewController(drilledDownCategoryViewController, animated: true)
        
    }
    
    func save() {
        
        var error: NSError? = nil
        if managedObjectContext!.save(&error) {
            println(error?.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}