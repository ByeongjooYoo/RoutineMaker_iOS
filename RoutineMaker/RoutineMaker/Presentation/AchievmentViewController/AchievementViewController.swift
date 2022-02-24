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
    @IBOutlet weak var dayAchivementLabel: UILabel!
    
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
        setupNotification()
    }
    
    @objc func getDayAchivementData(_ notification: Notification) {
        let data = notification.object as! Double
        DispatchQueue.main.async {
            self.dayAchivementProgressView.progress = Float(data)
            self.dayAchivementLabel.text = "오늘의 달성도는 \(Int(data * 100))%입니다!"
        }
    }
}

private extension AchievementViewController {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getDayAchivementData(_:)), name: Notification.Name("getDayAchivementData"), object: nil)
    }
    
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
        drawNoDataChartView(barChartView: weekBarChartView)
        drawBarChartView(rowData: weeks, values: completionCount, barChartView: weekBarChartView)
    }
    
    func setupMonthViewLayout() {
        monthView.layer.cornerRadius = 10
        setupMonthBarChartView()
    }
    
    func setupMonthBarChartView() {
        drawNoDataChartView(barChartView: monthBarChartView)
        drawBarChartView(rowData: months, values: weekCompletionCount, barChartView: monthBarChartView)
    }
    
    func drawNoDataChartView(barChartView: BarChartView) {
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
    }
    
    func drawBarChartView(rowData: [String], values: [Double], barChartView: BarChartView) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0 ..< rowData.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "달성률(%)")
        chartDataSet.colors = [.systemGreen]
        chartDataSet.highlightEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartData.barWidth = Double(0.5)
        
        barChartView.data = chartData

        barChartView.xAxis.setLabelCount(rowData.count, force: false)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: rowData)
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.rightAxis.enabled = false
        
        barChartView.leftAxis.axisMaximum = 100.0
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.drawGridLinesEnabled = false
        
        barChartView.backgroundColor = .systemBackground
        barChartView.doubleTapToZoomEnabled = false
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}
