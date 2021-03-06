//
//  StaticsViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/27.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit
import Charts

class StaticsViewController: UIViewController,UITabBarControllerDelegate {
    
    //折线图
    var chartView: LineChartView!
    var pieChart: PieChartView!
    
    @IBOutlet weak var chart1: UIView!
    @IBOutlet weak var chart2: UIView!
    @IBOutlet weak var completeProbability: UILabel!
    @IBOutlet weak var bestDay: UILabel!
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            setChart()
            setLineChar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //创建折线图组件对象
        chartView = LineChartView()
        chartView.frame = CGRect(x: 0, y: 0, width: 261, height: 220)
        //self.view.addSubview(chartView)
        self.chart2.addSubview(chartView)
        
        // 创建饼状图
        pieChart = PieChartView()
        pieChart.frame = CGRect(x: 0, y: 0, width: 261, height: 220)
        self.chart1.addSubview(pieChart)
        pieChart.chartDescription?.font = UIFont.systemFont(ofSize: 12.0);//字体
        pieChart.chartDescription?.textColor = UIColor.black;//颜色
        pieChart.entryLabelFont = UIFont.systemFont(ofSize: 10);//区块文本的字体
        pieChart.entryLabelColor = UIColor.black;
        
        setChart()
        setLineChar()
        
        // 代理tabBarController
        self.tabBarController?.delegate = self
    }
    

    func setChart() {
        
        //let titles = ["红","黄","蓝色","橙","绿"];
        //let yData = [20,30,10,40,60];
        //initial data
        let arrayTaskDone = CoreDataManager.shared.getTaskByStatus(status: 2)
        let arrayTaskToDo = CoreDataManager.shared.getTaskByStatus(status: 1)
        let completionRate = Double(arrayTaskDone.count) / Double(arrayTaskDone.count + arrayTaskToDo.count) * 100
        print(completionRate)
        completeProbability.text = String(format: "%.1f%%", completionRate)
        let titles = ["已完成","未完成"];
        let yData = [arrayTaskDone.count,arrayTaskToDo.count];
        var yVals = [PieChartDataEntry]();
        for i in 0...titles.count-1 {
            let entry = PieChartDataEntry.init(value: Double(yData[i]), label: titles[i]);
            yVals.append(entry);
        }
        
        let dataSet = PieChartDataSet.init(values: yVals, label: "");
        //dataSet.colors = [UIColor.red,UIColor.yellow,UIColor.blue,UIColor.orange,UIColor.green];

        dataSet.colors = [UIColor.orange,UIColor.green,UIColor.blue,UIColor.orange,UIColor.green];
        //设置名称和数据的位置 都在内就没有折线了哦
        //dataSet.xValuePosition = .insideSlice;
        //dataSet.yValuePosition = .outsideSlice;
        dataSet.yValuePosition = .insideSlice;
        dataSet.sliceSpace = 1;//相邻块的距离
        dataSet.selectionShift = 6.66;//选中放大半径
        //指示折线样式
        dataSet.valueLinePart1OffsetPercentage = 0.8 //折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
        dataSet.valueLinePart1Length = 0.8 //折线中第一段长度占比
        dataSet.valueLinePart2Length = 0.4 //折线中第二段长度最大占比
        dataSet.valueLineWidth = 1 //折线的粗细
        dataSet.valueLineColor = UIColor.black //折线颜色
        
        let data = PieChartData.init(dataSets: [dataSet]);
        //data.setValueFormatter(IAxisValueFormatter.init());//格式化值（添加个%）
        data.setValueFont(UIFont.systemFont(ofSize: 10.0));
        data.setValueTextColor(UIColor.lightGray);
        pieChart.data = data;
    }
    
    func setLineChar(){
        //self.addLimitLine(250, "限制线");
        //let xValues = ["x1","x2","x3","x4","x5","x6","x7","x8","x9","x10","x11","x12"];
        
        let xValues = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        var yValues = [0, 0, 0, 0, 0, 0, 0]
        
        let taskArray = CoreDataManager.shared.getTaskByStatus(status: 2)
        
        for task in taskArray{
            let dayOfWeek = getDayOfWeek(task.time!)!
            var index = dayOfWeek-2
            if index < 0{
                index = 6
            }
            yValues[index] =  yValues[index] + 1
        }
        
        //chartView.xAxis.valueFormatter = IAxisValueFormatter.init(xValues as NSArray);
        //chartView.leftAxis.valueFormatter = IAxisValueFormatter.init();
        
        bestDay.text = getTheBest(values: yValues)
        
        var yDataArray1 = [ChartDataEntry]();
        for i in 0...xValues.count-1 {
            //let y = arc4random()%500;
            let entry = ChartDataEntry.init(x: Double(i+1), y: Double(yValues[i]));
            
            yDataArray1.append(entry);
        }
        let set1 = LineChartDataSet.init(values: yDataArray1, label: "");
        
        set1.colors = [UIColor.orange];
        set1.drawCirclesEnabled = false;//绘制转折点
        set1.lineWidth = 1.0;
        
//        var yDataArray2 = [ChartDataEntry]();
//        for i in 0...xValues.count-1 {
//            let y = arc4random()%500+1;
//            let entry = ChartDataEntry.init(x: Double(i), y: Double(y));
//
//            yDataArray2.append(entry);
//        }
//        let set2 = LineChartDataSet.init(values: yDataArray2, label: "绿色");
//        set2.colors = [UIColor.green];
//        set2.drawCirclesEnabled = false;
//        set2.lineWidth = 1.0;
        
        //let data = LineChartData.init(dataSets: [set1,set2]);
        let data = LineChartData.init(dataSets: [set1]);
        
        chartView.data = data;
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack);
        
    }
    
    //周日是第一天
    func getDayOfWeek(_ todayDate:Date) -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    //best day
    func getTheBest(values: [Int]) -> String {
        var index = 0
        for i in 1...values.count-1 {
            if(values[i] > values[index]){
                index = i
            }
        }
        switch index {
        case 0:
            return "周一"
        case 1:
            return "周二"
        case 2:
            return "周三"
        case 3:
            return "周四"
        case 4:
            return "周五"
        case 5:
            return "周六"
        case 6:
            return "周日"
        default:
            return "???"
        }
    }
}
