//
//  StaticsViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/27.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit
import Charts

class StaticsViewController: UIViewController {
    
    //折线图
    var chartView: LineChartView!
    var pieChart: PieChartView!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    let state = ["已完成", "未完成"]
    let values = [88, 12]

    @IBOutlet weak var chart1: UIView!
    @IBOutlet weak var chart2: UIView!
    @IBOutlet weak var completeProbability: UILabel!
    @IBOutlet weak var bestDay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //创建折线图组件对象
        chartView = LineChartView()
        chartView.frame = CGRect(x: 0, y: 0, width: 261, height: 220)
        //self.view.addSubview(chartView)
        self.chart1.addSubview(chartView)
        
        //生成20条随机数据
        var dataEntries = [ChartDataEntry]()
        for i in 0..<20 {
            let y = arc4random()%100
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
        //这50条数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "图例1")
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
        
        //设置折现图数据
        chartView.data = chartData
        
        // 创建饼状图
        pieChart = PieChartView()
        pieChart.frame = CGRect(x: 0, y: 0, width: 261, height: 220)
        self.chart2.addSubview(pieChart)
        
        setChart(dataPoints: state, values: values)
        setLineChar()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setChart(dataPoints: [String], values: [Int]) {
        
        let titles = ["红","黄","蓝色","橙","绿"];
        let yData = [20,30,10,40,60];
        var yVals = [PieChartDataEntry]();
        for i in 0...titles.count-1 {
            let entry = PieChartDataEntry.init(value: Double(yData[i]), label: titles[i]);
            yVals.append(entry);
        }
        
        let dataSet = PieChartDataSet.init(values: yVals, label: "");
        dataSet.colors = [UIColor.red,UIColor.yellow,UIColor.blue,UIColor.orange,UIColor.green];
        //设置名称和数据的位置 都在内就没有折线了哦
        dataSet.xValuePosition = .insideSlice;
        dataSet.yValuePosition = .outsideSlice;
        dataSet.sliceSpace = 1;//相邻块的距离
        dataSet.selectionShift = 6.66;//选中放大半径
        //指示折线样式
        dataSet.valueLinePart1OffsetPercentage = 0.8 //折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
        dataSet.valueLinePart1Length = 0.8 //折线中第一段长度占比
        dataSet.valueLinePart2Length = 0.4 //折线中第二段长度最大占比
        dataSet.valueLineWidth = 1 //折线的粗细
        dataSet.valueLineColor = UIColor.brown //折线颜色
        
        let data = PieChartData.init(dataSets: [dataSet]);
        //data.setValueFormatter(IAxisValueFormatter.init());//格式化值（添加个%）
        data.setValueFont(UIFont.systemFont(ofSize: 10.0));
        data.setValueTextColor(UIColor.lightGray);
        pieChart.data = data;
//        var dataEntries: [ChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let y = values[i]
//            let dataEntry = ChartDataEntry(x: Double(i), y: Double(y))
//            dataEntries.append(dataEntry)
//        }
//
//        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "label")
//
//        pieChart.data = pieChartDataSet
//
//        var colors: [UIColor] = []
//        colors.append(UIColor.blue)
//        colors.append(UIColor.red)
//        finishPieChartDataSet.colors = colors
    }
    
    func setLineChar(){
        //self.addLimitLine(250, "限制线");
        let xValues = ["x1","x2","x3","x4","x5","x6","x7","x8","x9","x10","x11","x12"];
        //chartView.xAxis.valueFormatter = VDChartAxisValueFormatter.init(xValues as NSArray);
        //chartView.leftAxis.valueFormatter = VDChartAxisValueFormatter.init();
        
        var yDataArray1 = [ChartDataEntry]();
        for i in 0...xValues.count-1 {
            let y = arc4random()%500;
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y));
            
            yDataArray1.append(entry);
        }
        let set1 = LineChartDataSet.init(values: yDataArray1, label: "橙色");
        set1.colors = [UIColor.orange];
        set1.drawCirclesEnabled = false;//绘制转折点
        set1.lineWidth = 1.0;
        
        var yDataArray2 = [ChartDataEntry]();
        for i in 0...xValues.count-1 {
            let y = arc4random()%500+1;
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y));
            
            yDataArray2.append(entry);
        }
        let set2 = LineChartDataSet.init(values: yDataArray2, label: "绿色");
        set2.colors = [UIColor.green];
        set2.drawCirclesEnabled = false;
        set2.lineWidth = 1.0;
        
        let data = LineChartData.init(dataSets: [set1,set2]);
        
        chartView.data = data;
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack);
    }

}
