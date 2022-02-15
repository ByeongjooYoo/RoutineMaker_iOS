//
//  AchievmentViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/06.
//

import UIKit
import Charts

class AchievmentViewController: UIViewController {
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayAchivmentProgressView: UIProgressView!
    
    @IBOutlet weak var weekBarChartView: BarChartView!
    let weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    let completionCount: [Double] = [5, 4, 2, 5, 7, 8, 9]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupDayViewLayout()
        setupWeekBarChartView()
    }
}

private extension AchievmentViewController {
    func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupDayViewLayout() {
        dayView.layer.cornerRadius = 10
        dayAchivmentProgressView.layer.cornerRadius = 8
    }
    
    func setupWeekBarChartView() {
        weekBarChartView.noDataText = "데이터가 없습니다."
        weekBarChartView.noDataFont = .systemFont(ofSize: 20)
        weekBarChartView.noDataTextColor = .lightGray
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0 ..< weeks.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: completionCount[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        
        chartDataSet.colors = [.systemGreen]
        chartDataSet.highlightEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartData.barWidth = Double(0.5)
        
        weekBarChartView.data = chartData
        weekBarChartView.rightAxis.enabled = false
        weekBarChartView.doubleTapToZoomEnabled = false
        weekBarChartView.xAxis.labelPosition = .bottom
        weekBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weeks)
        
        weekBarChartView.xAxis.drawGridLinesEnabled = false
        weekBarChartView.legend.setCustom(entries: [])
        
        weekBarChartView.leftAxis.drawGridLinesEnabled = false
        weekBarChartView.backgroundColor = .systemBackground
        weekBarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}
