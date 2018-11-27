//
//  DoneViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/27.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    let sections = Model.sections
    let indexes = Model.indexes
    var sectionDic = Model.sectionDic
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    @IBAction func editItem(_ sender: Any) {
        editAction()
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 110
        // 注册cell
        self.tableView.register(UINib(nibName:"NewCellTableViewCell", bundle:nil), forCellReuseIdentifier:"cell")
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
        cell.iconImage.image = UIImage(named: "statics")
        cell.titleLable.text = "事项"
        cell.contentLabel.text = sectionDic[self.sections[indexPath[0]]]![indexPath[1]]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let actionDel = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
            //self.ints.remove(at: indexPath.row)
            self.sectionDic[self.sections[indexPath[0]]]!.remove(at: indexPath[1])
            tableView.deleteRows(at: [indexPath], with: .fade)
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
