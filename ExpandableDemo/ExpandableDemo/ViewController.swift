//
//  ViewController.swift
//  ExpandableDemo
//
//  Created by avani on 27/11/17.
//  Copyright © 2017 zaptech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblData: YSTreeTableView!
    
    //YSTreeTableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu01 = YSTreeTableViewNode(nodeID: 1, nodeName: "Groups", leftImageName: "expand", rightImageName: "expand", isExpand: true)!
        
        let menu011 = YSTreeTableViewNode(nodeID: 1, nodeName: "Coins", leftImageName: "collapse", rightImageName: "collapse", isExpand: true)!
        let menu012 = YSTreeTableViewNode(nodeID: 1, nodeName: "Jewellery", leftImageName: "", rightImageName: "", isExpand: true)!
        let menu013 = YSTreeTableViewNode(nodeID: 1, nodeName: "Bullion", leftImageName: "", rightImageName: "", isExpand: true)!
        
        menu01.addChildNode(childNode: menu011)
        menu01.addChildNode(childNode: menu012)
        menu01.addChildNode(childNode: menu013)
        
        
        let menu0111 = YSTreeTableViewNode(nodeID: 1, nodeName: "Coin1", leftImageName: "", rightImageName: "", isExpand: true)!
        let menu0112 = YSTreeTableViewNode(nodeID: 1, nodeName: "Coin2", leftImageName: "", rightImageName: "", isExpand: true)!
        let menu0113 = YSTreeTableViewNode(nodeID: 1, nodeName: "Coin3", leftImageName: "", rightImageName: "", isExpand: true)!
        
        menu011.subNodes = [menu0111,menu0112,menu0113]
        
        let menu02 = YSTreeTableViewNode(nodeID: 1, nodeName: "Manage Groups", leftImageName: "", rightImageName: "", isExpand: true)!
        
        let menu03 = YSTreeTableViewNode(nodeID: 1, nodeName: "Create Groups", leftImageName: "", rightImageName: "", isExpand: true)!
        
        
        
        let rootnodes = [menu01,menu02,menu03]
        tblData.rootNodes = rootnodes
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

