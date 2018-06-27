//
//  PositiveNegativeBarChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import UIKit
import Charts

class PositiveNegativeBarChartViewController: DemoBaseViewController {

    @IBOutlet var chartView: BarChartView!

    let dataLabels = ["12-19",
                      "12-30",
                      "12-31",
                      "01-01",
                      "01-02"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Bar Chart"
        self.options = [.toggleValues,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData,
                        .toggleBarBorders]
        
        self.setup(barLineChartView: chartView)
        
        chartView.delegate = self
        
        chartView.setExtraOffsets(left: 0, top: -30, right: 0, bottom: 10)
    
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        
        chartView.chartDescription?.enabled = false
        
        chartView.rightAxis.enabled = false

        chartView.scaleYEnabled = false
        chartView.dragYEnabled = false
        chartView.dragDecelerationEnabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 13)
        xAxis.drawAxisLineEnabled = false
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = 5
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 1
        xAxis.valueFormatter = self
        
        let leftAxis = chartView.leftAxis
        leftAxis.drawLabelsEnabled = false
        leftAxis.spaceTop = 0.25
        leftAxis.spaceBottom = 0.25
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawZeroLineEnabled = true
        leftAxis.zeroLineColor = .gray
        leftAxis.zeroLineWidth = 0.7

        /// Autoscale if necessary

        chartView.autoScaleMinMaxOnTouchEndEnabled = true
        chartView.autoScaleOnlyIfNecessary = true
        chartView.autoScaleDifferenceFactor = 1
        
        self.updateChartData()
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setChartData()
    }
    
    func setChartData() {

        let start = 0
        let count = 100
        let range: UInt32 = 50000

        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))

            return BarChartDataEntry(x: Double(i), y: val)
        }

        let negativVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))

            return BarChartDataEntry(x: Double(i), y: -val)
        }
    

        let red = UIColor(red: 211/255, green: 74/255, blue: 88/255, alpha: 1)
        let green = UIColor(red: 110/255, green: 190/255, blue: 102/255, alpha: 1)
        let colors = yVals.map { (entry) -> NSUIColor in
            return entry.y > 0 ? red : green
        }
        
        let set = BarChartDataSet(values: yVals, label: "Values")
        set.colors = colors
        set.valueColors = colors

        let set2 = BarChartDataSet(values: negativVals, label: "Values")
        set2.colors = colors
        set2.valueColors = colors
        
        let data = BarChartData(dataSets: [set, set2])
        data.setValueFont(.systemFont(ofSize: 13))
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.barWidth = 0.8
        
        chartView.data = data
    }
    
    override func optionTapped(_ option: Option) {
        super.handleOption(option, forChartView: chartView)
    }
}

extension PositiveNegativeBarChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}
