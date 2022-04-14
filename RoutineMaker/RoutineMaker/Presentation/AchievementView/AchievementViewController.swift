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
    
    var ref: DatabaseReference!
    
    // viewModel.weekAchievement
    var completionCount: [Double] = []
    
    // viewModel.monthAchivement
    var monthsCompletionCount: [Double] = []
    
    var time: Float = 0.0
    var timer: Timer?
    
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
            
        })
    }
}

extension AchievementViewController {
    
    func calculateMonthAchievement( dayAchievement:[DayAchievement]) -> Double {
        let count = dayAchievement.count
        var result: Double = 0
        if count == 0 {
            return 0
        }
        
        for data in dayAchievement {
            result += data.dayAchivement
        }
        
        return result / Double(count)
    }
    
    //TODO: 성취도 계산(일주일)
    func fetchAchievementData() {
        ref = Database.database().reference()
        ref.child("user1").child("AchievementList").observeSingleEvent(of: .value, with: { [self] snapshot in
            if snapshot.value is NSNull { return }
            guard let value = snapshot.value else {
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let loadData = try JSONDecoder().decode([String: DayAchievement].self, from: jsonData)
                
                var monthAchievement: [Double] = []
                for month in viewModel.months {
                    var monthArray: [DayAchievement] = []
                    for date in loadData.keys {
                        if date.contains(month) {
                            monthArray.append(loadData[date] ?? DayAchievement(dayAchivement: 0.0, date: date))
                        }
                    }
                    let achievement = calculateMonthAchievement(dayAchievement: monthArray)
                    monthAchievement.append(achievement)
                }
                monthsCompletionCount = monthAchievement
                setupMonthViewLayout()
            }  catch let error {
                print("Error JSON parsing: \(error.localizedDescription)")
            }
        }) { error in
            print(error.localizedDescription)
        }
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
        //TODO: Firebase 데이터로 교체
        drawBarChartView(rowData: viewModel.weeks, values: weekAchievement, barChartView: weekBarChartView)    }
    
    func setupMonthViewLayout() {
        monthView.layer.cornerRadius = 10
        drawNoDataChartView(barChartView: monthBarChartView)
        //TODO: Firebase 데이터로 교체
        drawBarChartView(rowData: viewModel.months, values: monthsCompletionCount, barChartView: monthBarChartView)
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
