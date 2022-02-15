//
//  AchievementViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/06.
//

import UIKit
import Charts

class AchievementViewController: UIViewController {
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayAchivementProgressView: UIProgressView!
    
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var weekBarChartView: BarChartView!
    
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthBarChartView: BarChartView!
    
    let weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    let completionCount: [Double] = [50, 40, 20, 50, 70, 80, 90]
    
    let months: [String] = ["3주 전", "2주 전", "1주 전", "이번 주"]
    let weekCompletionCount: [Double] = [80, 70, 50, 98]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupDayViewLayout()
        setupWeekViewLayout()
        setupMonthViewLayout()
    }
}

private extension AchievementViewController {
    func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupDayViewLayout() {
        dayView.layer.cornerRadius = 10
        dayAchivementProgressView.layer.cornerRadius = 8
    }
    
    func setupWeekViewLayout() {
        weekView.layer.cornerRadius = 10
        setupWeekBarChartView()
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
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "달성률(%)")
        
        chartDataSet.colors = [.systemGreen]
//        chartDataSet.highlightEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartData.barWidth = Double(0.5)
        
        weekBarChartView.data = chartData
        weekBarChartView.rightAxis.enabled = false
        weekBarChartView.doubleTapToZoomEnabled = false
        weekBarChartView.xAxis.labelPosition = .bottom
        weekBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weeks)
        
        weekBarChartView.leftAxis.axisMaximum = 100.0
        weekBarChartView.leftAxis.axisMinimum = 0.0
        
        
        weekBarChartView.xAxis.drawGridLinesEnabled = false
        //weekBarChartView.legend.setCustom(entries: [])
        
        weekBarChartView.leftAxis.drawGridLinesEnabled = false
        weekBarChartView.backgroundColor = .systemBackground
        weekBarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func setupMonthViewLayout() {
        monthView.layer.cornerRadius = 10
        setupMonthBarChartView()
    }
    
    func setupMonthBarChartView() {
        monthBarChartView.noDataText = "데이터가 없습니다."
        monthBarChartView.noDataFont = .systemFont(ofSize: 20)
        monthBarChartView.noDataTextColor = .lightGray
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0 ..< months.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: weekCompletionCount[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "달성률(%)")
        
        chartDataSet.colors = [.systemGreen]
//        chartDataSet.highlightEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartData.barWidth = Double(0.5)
        monthBarChartView.xAxis.setLabelCount(months.count, force: false)
        monthBarChartView.data = chartData
        monthBarChartView.rightAxis.enabled = false
        monthBarChartView.doubleTapToZoomEnabled = false
        monthBarChartView.xAxis.labelPosition = .bottom
        monthBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        
        monthBarChartView.leftAxis.axisMaximum = 100.0
        monthBarChartView.leftAxis.axisMinimum = 0.0
        
        
        monthBarChartView.xAxis.drawGridLinesEnabled = false
        //weekBarChartView.legend.setCustom(entries: [])
        
        monthBarChartView.leftAxis.drawGridLinesEnabled = false
        monthBarChartView.backgroundColor = .systemBackground
        monthBarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}
