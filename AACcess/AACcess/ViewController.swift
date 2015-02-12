//
//  ViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/11/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // ...
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.topItem?.title = "Categories"
        
        tableView = UITableView(frame: CGRectZero, style: .Plain)

        tableView!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CategoryCell")

        var viewFrame = self.view.frame

        viewFrame.size.height -= 400

        tableView!.frame = viewFrame
        
        self.view.addSubview(tableView!)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}