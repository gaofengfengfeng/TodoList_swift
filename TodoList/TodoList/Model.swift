//
//  Model.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/27.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import Foundation
import UIKit

class Model {
    static let sections = ["一天前","三天前","一周前", "更早"]
    static let indexes = ["1", "2", "3", "4", "5"]
    
    static let sectionDic: [String : [String]] = ["一天前": ["1", "2", "3", "4", "5"], "三天前": ["1", "2", "3"], "一周前": ["1", "2", "3", "4"], "更早": ["1"]]
}
