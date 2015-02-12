//
//  SubViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/11/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

// FIX THE LOADING FORMAT OF THE TEXTVIEW FROM THE CATEGORY ITEMS, ETC...

import UIKit
import CoreData

class SubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            return managedObjectContext
            
        } else {
            
            return nil
            
        }
        
        }()
    
    var tableView: UITableView?
    
    var categoryItemsItems = [CategoryItem]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        println(textViewData)
        
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewCategoryItem")
        self.navigationItem.rightBarButtonItem = addButton
        
        view.backgroundColor = UIColor.whiteColor()
        
        // navigationController?.navigationBar.topItem?.title = "Categories"
        
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        
        tableView!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CategoryItemCell")
        
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
        
        let fetchRequest = NSFetchRequest(entityName: "CategoryItem")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "category == %@", categoryTitleProperty)
        
        fetchRequest.predicate = predicate
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [CategoryItem] {
            
            categoryItemsItems = fetchResults
            
        }
        
    }
    
    func addNewCategoryItem() {
        
        self.saveNewCategoryItem(textViewData, category: categoryTitleProperty)
        
    }
    
    func saveNewCategoryItem(title: String, category: String) {
        
        if title != "" {
            
            var newCategoryItem = CategoryItem.createInManagedObjectContext(self.managedObjectContext!, title: title, category: category)
            
            self.fetchCategory()
            
            if let newCategoryIndex = find(categoryItemsItems, newCategoryItem) {
                
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
            
            let logItemToDelete = categoryItemsItems[indexPath.row]
            
            managedObjectContext?.deleteObject(logItemToDelete as NSManagedObject)
            
            self.fetchCategory()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            save()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItemsItems.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryItemCell") as UITableViewCell
        
        let categoryItem = categoryItemsItems[indexPath.row]
        
        cell.textLabel?.text = categoryItem.title
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let categoryItem = categoryItemsItems[indexPath.row]
        
        if textViewData == nil {
            
            textViewData = String(categoryItem.title)
            
            textViewRef.text = textViewData
            
            speakAndPauseButton.enabled = true
            
        } else {
        
            textViewData = textViewData + " " + String(categoryItem.title)
        
            textViewRef.text = textViewData
            
            speakAndPauseButton.enabled = true
            
        }
        
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