//
//  DoneViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/27.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating,UITabBarControllerDelegate {
    
    let sections = Model.sections
    let indexes = Model.indexes
    var sectionDic:[String:[Task]] = [:]
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var editBtn: UIBarButtonItem!

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1{
              setupSectionDic()
              self.tableView.reloadData()
        }
    }
    
    @IBAction func editItem(_ sender: Any) {
        editAction()
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 110
        //initial data
        setupSectionDic()
        // 注册cell
        self.tableView.register(UINib(nibName:"NewCellTableViewCell", bundle:nil), forCellReuseIdentifier:"cell")
        // 代理tabBarController
        self.tabBarController?.delegate = self
    }
    
    func setupSectionDic() {
        var taskArrayDayBefore: Array<Task> = []
        var taskArrayThreeDayBefore: Array<Task> = []
        var taskArrayWeekBefore: Array<Task> = []
        var taskArrayEarlier: Array<Task> = []
        //search the task already been done
        let taskArray = CoreDataManager.shared.getTaskByStatus(status: 2)
        //sort the taskArray by time
        for task in taskArray{
            let diff = dayDifference(toDate: task.time!)
            print(diff)
            if diff < 0 && diff >= -1{
                //一天前
                taskArrayDayBefore.append(task)
            }else if diff < -1 && diff >= -3 {
                //三天前
                taskArrayThreeDayBefore.append(task)
            }else if diff < -3 && diff >= -7{
                //一周前
                taskArrayWeekBefore.append(task)
            }else if diff < -7{
                //更早
                taskArrayEarlier.append(task)
            }
        }
        
       sectionDic = ["一天前": taskArrayDayBefore, "三天前": taskArrayThreeDayBefore, "一周前":taskArrayWeekBefore, "更早": taskArrayEarlier]
    }
    
    func dayDifference(toDate: Date) -> Int {
       let calendar = NSCalendar.current
       let startOfNow = calendar.startOfDay(for: Date())
       let startOfTimeStamp = calendar.startOfDay(for: toDate)
       let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
       return components.day!
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
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        var indexSection : Int = 0
        for i in sections {
            if i == title {
                return indexSection
            }
            indexSection += 1
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDic.count
        //return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionDic[self.sections[section]]!.count
        //return indexes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewCellTableViewCell
        //print(indexPath)
        let task = sectionDic[self.sections[indexPath[0]]]![indexPath[1]]
        cell.iconImage.image = UIImage(named: "statics")
        cell.titleLable.text = task.name
        cell.contentLabel.text = dateFormatter.string(from: task.time!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let actionDel = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
            //self.ints.remove(at: indexPath.row)
            let task = self.sectionDic[self.sections[indexPath[0]]]!.remove(at: indexPath[1])
            tableView.deleteRows(at: [indexPath], with: .fade)
            //remove it in data core
            CoreDataManager.shared.deleteTask(objectID: task.objectID)
            finished(true)
        }

        actionDel.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [actionDel])
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let actionDel = UITableViewRowAction(style: .normal, title: "删除") { (_, indexPath) in
//            self.ints.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//
//        actionDel.backgroundColor = UIColor.red
//        if tableView.isEditing == true {
//            return [actionDel]
//        } else {
//            return nil
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections
    }
    

}
