//
//  YSTreeTableView.swift
//  YSTreeTableView
//
//  Created by yaoshuai on 2017/1/10.
//  Copyright © 2017年 ys. All rights reserved.
//

import UIKit

private let YSTreeTableViewNodeCellID:String = "YSTreeTableViewNodeCellID"
private let YSTreeTableViewContentCellID:String = "YSTreeTableViewContentCellID"

private let YSTreeTableViewNodeCellHeight:CGFloat = 50
private let YSTreeTableViewContentCellHeight:CGFloat = 50 //change

protocol YSTreeTableViewDelegate:NSObjectProtocol {
    
    func treeCellClick(node:YSTreeTableViewNode,indexPath:IndexPath)
}

class YSTreeTableView: UITableView {
    
    var treeDelegate:YSTreeTableViewDelegate?
    
    /// 外部传入的数据源(根节点集合)External incoming data sources (root node collection)
    var rootNodes:[YSTreeTableViewNode] = [YSTreeTableViewNode](){
        didSet{
            getExpandNodeArray()
            reloadData()
        }
    }
    
    /// 内部使用的数据源(由nodeArray变形而来)
    //The data source used internally (deformed by nodeArray)
    fileprivate var tempNodeArray:[YSTreeTableViewNode] = [YSTreeTableViewNode]()
    
    /// 点击“展开”，添加的子节点的“索引数组”
    //Click "expand", add the sub-node "index array"
    fileprivate var insertIndexPaths:[IndexPath] = [IndexPath]()
    private var insertRow = 0
    
    /// 点击“收缩”，删除的子节点的“索引数组”
    //Click "shrink", delete the sub-node "index array"
    fileprivate var deleteIndexPaths:[IndexPath] = [IndexPath]()
    
    override init(frame:CGRect, style: UITableViewStyle){
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableView()
    }
    
    private func setupTableView(){
        dataSource = self
        delegate = self
        register(YSTreeTableViewNodeCell.self, forCellReuseIdentifier: YSTreeTableViewNodeCellID)
        register(YSTreeTableViewContentCell.self, forCellReuseIdentifier: YSTreeTableViewContentCellID)
    }
    
    
    /// 添加本节点及展开的子节点(包括展开的孙子节点)至数组中
    //Add this node and its expanded children (including the expanded grandchild node) into the array
    ///
    /// - Parameters:
    ///   - node: 本节点
    /// - node: This node
    private func addExpandNodeToArray(node:YSTreeTableViewNode) -> Void{
        tempNodeArray.append(node)
        
        if node.isExpand{ // 当前节点展开，添加其子节点 The current node expands to add its children
            for childNode in node.subNodes{
                addExpandNodeToArray(node: childNode)
            }
        }
    }
    
    /// 获取所有展开的节点数组
    //Gets all the expanded node arrays
    private func getExpandNodeArray() -> (){
        for rootNode in rootNodes{
            if rootNode.parentNode == nil{ // 再次判断是否是根节点 Again determine whether it is the root node
                addExpandNodeToArray(node: rootNode)
            }
        }
    }
    
    /// 是否是叶子节点
    ///
    /// - Parameter node: 节点
    /// - Returns: true-是；false-否
    
    /// is a leaf node
    ///
    /// - Parameter node: node
    /// - Returns: true-yes; false-no
    fileprivate func isLeafNode(node:YSTreeTableViewNode) -> Bool{
        return node.subNodes.count == 0
    }
    
    
    /// 点击“展开”，添加子节点(如果子节点也处于展开状态，添加孙子节点)
    ///
    /// - Parameter node: 节点
    
    /// Click "Expand" to add child nodes (if the child nodes are also expanded, add the grandchild nodes)
    ///
    /// - Parameter node: node
    fileprivate func insertChildNode(node:YSTreeTableViewNode){
        node.isExpand = true
        if node.subNodes.count == 0{
            return
        }
        
        insertRow = tempNodeArray.index(of: node)! + 1
        
        for childNode in node.subNodes{
            let childRow = insertRow
            let childIndexPath = IndexPath(row: childRow, section: 0)
            insertIndexPaths.append(childIndexPath)
            
            tempNodeArray.insert(childNode, at: childRow)
            
            insertRow += 1
            if childNode.isExpand{
                insertChildNode(node: childNode)
            }
        }
    }
    
    /// 点击“收缩”，删除所有处于展开状态的子节点的索引
    ///
    /// - Parameter node: 节点
    
    /// Click Shrink to delete the index of all child nodes in the expanded state
    ///
    /// - Parameter node: node
    fileprivate func getDeleteIndexPaths(node:YSTreeTableViewNode){
        if node.isExpand{ // 再次确认节点处于展开状态
            
            for childNode in node.subNodes{
                let childRow = tempNodeArray.index(of: childNode)!
                let childIndexPath = IndexPath(row: childRow, section: 0)
                deleteIndexPaths.append(childIndexPath)
                
                if childNode.isExpand{
                    getDeleteIndexPaths(node: childNode)
                }
            }
        }
    }
    
    /// 点击“收缩”，删除所有处于展开状态的子节点
    ///
    /// - Parameter node: 节点
    /// Click "Shrink" to delete all children in the expanded state
    ///
    /// - Parameter node: node
    fileprivate func deleteChildNode(node:YSTreeTableViewNode){
        getDeleteIndexPaths(node: node)
        
        node.isExpand = false
        
        for _ in deleteIndexPaths{
            tempNodeArray.remove(at: deleteIndexPaths.first!.row)
        }
    }
}

extension YSTreeTableView:UITableViewDataSource,UITableViewDelegate{
    // MARK: - cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempNodeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = tempNodeArray[indexPath.row]
        
        if isLeafNode(node: node){ // 叶子节点，内容cell
            let cell:YSTreeTableViewNodeCell = tableView.dequeueReusableCell(withIdentifier: YSTreeTableViewNodeCellID, for: indexPath) as! YSTreeTableViewNodeCell
            
            cell.node = node
            
            return cell
        } else{ // 节点cell
            let cell:YSTreeTableViewContentCell = tableView.dequeueReusableCell(withIdentifier: YSTreeTableViewContentCellID, for: indexPath) as! YSTreeTableViewContentCell

            cell.node = node

            return cell
        }
    }
    
    // MARK: - 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let node = tempNodeArray[indexPath.row]
        
        if isLeafNode(node: node){ // 叶子节点，内容cell
            return YSTreeTableViewContentCellHeight
        } else{ // 节点cell
            return YSTreeTableViewNodeCellHeight
        }
    }
    
    // MARK: - 点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = tempNodeArray[indexPath.row]
        treeDelegate?.treeCellClick(node: node, indexPath: indexPath)
        
        if isLeafNode(node: node){ // 叶子节点，内容cell
            return
        } else{ // 节点cell
            if node.isExpand{ // 当前节点展开，要进行收缩操作
                deleteIndexPaths = [IndexPath]()
                deleteChildNode(node: node)
                deleteRows(at: deleteIndexPaths, with: .top)
            }
            else{ // 当前节点收缩，要进行展开操作
                insertIndexPaths = [IndexPath]()
                insertChildNode(node: node)
                insertRows(at: insertIndexPaths, with: .top)
            }
        }
    }
}
