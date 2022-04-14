//
//  AchievementViewController.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/06.
//

import UIKit 
import Charts
import Firebase

class AchievementViewController: UIViewController {
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayAchivementProgressView: UIProgressView!
    @IBOutlet weak var dayAchivementLabel: UILabel!
    
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var weekBarChartView: BarChartView!
    
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthBarChartView: BarChartView!
    
    private let viewModel = AchievementViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchDayAchievement(completion: { [self] result in
            setupDayViewLayout(progress: result)
        })
        
        viewModel.fetchWeekAchievement(completion: { [self] result in
            setupWeekViewLayout(weekAchievement: result)
        })
        
        viewModel.fetchMonthAchievement(completion: { [self] result in
            setupMonthViewLayout(monthAchievement: result)
        })
    }
}

private extension AchievementViewController {
    func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupDayViewLayout(progress: Float) {
        dayView.layer.cornerRadius = 10
        dayAchivementProgressView.layer.cornerRadius = 8
        dayAchivementProgressView.setProgress(progress, animated: true)
        dayAchivementLabel.text = "오늘의 달성도는 \(Int(progress * 100))%입니다!"
    }
    
    func setupWeekViewLayout(weekAchievement: [Double]) {
        weekView.layer.cornerRadius = 10
        drawNoDataChartView(barChartView: weekBarChartView)
        drawBarChartView(rowData: viewModel.weeks, values: weekAchievement, barChartView: weekBarChartView)    }
    
    func setupMonthViewLayout(monthAchievement: [Double]) {
        monthView.layer.cornerRadius = 10
        drawNoDataChartView(barChartView: monthBarChartView)
        drawBarChartView(rowData: viewModel.months, values: monthAchievement, barChartView: monthBarChartView)
    }
    
    func drawNoDataChartView(barChartView: BarChartView) {
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
    }
    
    func drawBarChartView(rowData: [String], values: [Double], barChartView: BarChartView) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0 ..< rowData.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i] * 100)
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
