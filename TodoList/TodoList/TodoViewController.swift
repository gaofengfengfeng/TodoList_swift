//
//  TodoViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/26.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    // mock假数据
    //var ints : [String] = ["1","2","3","4","5","6","7","8","9","10"]
    // 存储search之后的数据
    var searchResults:Array<Task> = []
    var searchController : UISearchController!
    var taskArray:Array<Task> = []
    var dateFormatter = DateFormatter()

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBAction func editItem(_ sender: Any) {
        editAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

        dateFormatter.dateFormat = "yyyy/MM/dd"

        taskArray = CoreDataManager.shared.getTaskByStatus(status: 1);
        taskArray.sort { (task1, task2) -> Bool in
            return task1.top! > task2.top!
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.showsCancelButton = true;
        searchController.searchBar.barTintColor = UIColor.blue
        
        self.headerView.addSubview(searchController.searchBar)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 110
        // 注册cell
        self.tableView.register(UINib(nibName:"NewCellTableViewCell", bundle:nil), forCellReuseIdentifier:"cell")
        //self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        //self.tableView.register(NewCellTableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func editAction() {
        if self.tableView.isEditing == false {
            self.tableView.setEditing(true, animated: true)
            self.editBtn.title = "完成"
        } else {
            self.tableView.setEditing(false, animated: true)
            self.editBtn.title = "编辑"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : taskArray.count
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionTop = UIContextualAction(style: .normal, title: "置顶") { (action, view, finished) in
            let task = self.taskArray[indexPath.row]
            let first = IndexPath(row: 0, section: 0)
            tableView.moveRow(at: indexPath, to: first)
            CoreDataManager.shared.updateTaskTopByID(objectID: task.objectID, newTop: Date())
            finished(true)
        }
        actionTop.backgroundColor = UIColor.orange
        return UISwipeActionsConfiguration(actions: [actionTop])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDel = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
            let task = self.taskArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //delet it in core data
            CoreDataManager.shared.deleteTask(objectID:task.objectID)
            finished(true)
        }
        
        let actionFinish = UIContextualAction(style: .normal, title: "完成") { (action, view, finished) in
            let task = self.taskArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //update task status in core data
            CoreDataManager.shared.updateTaskStatusByID(objectID: task.objectID, newStatus: 2)
            finished(true)
        }
        
        actionDel.backgroundColor = UIColor.red
        actionFinish.backgroundColor = UIColor.lightGray
        return UISwipeActionsConfiguration(actions: [actionDel, actionFinish])
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let actionDel = UITableViewRowAction(style: .normal, title: "删除") { (_, indexPath) in
            let task = self.taskArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //delete data in core data
            CoreDataManager.shared.deleteTask(objectID:task.objectID)
        }
        
        actionDel.backgroundColor = UIColor.red
        if tableView.isEditing == true {
            return [actionDel]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewCellTableViewCell
        print(indexPath)
        let task = searchController.isActive ? searchResults[indexPath.row] : taskArray[indexPath.row]
        cell.iconImage.image = UIImage(named: "statics")
        cell.titleLable.text = task.name
        cell.contentLabel.text = dateFormatter.string(from:task.time!)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let fromRow = (sourceIndexPath as NSIndexPath).row
        let toRow = (destinationIndexPath as NSIndexPath).row
        let task = taskArray[fromRow]
        
        taskArray.remove(at: fromRow)
        taskArray.insert(task, at: toRow)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 处理cell的点击事件
        self.tableView!.deselectRow(at: indexPath, animated: true)
        let task = self.taskArray[indexPath.row]
        self.performSegue(withIdentifier: "ShowDetailView", sender: task)
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailView"{
            let controller = segue.destination as! ModifyViewController
            controller.task = sender as? Task
        }
    }

    func searchFilter(text: String) {
        if text == "" {
            self.searchResults = taskArray
            return
        }
        self.searchResults = taskArray.filter({ (task) -> Bool in
            return task.name!.localizedCaseInsensitiveContains(text)
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text {
            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
}

class TableViewCell: UITableViewCell {
    
}

