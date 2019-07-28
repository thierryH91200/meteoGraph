//
//  vc2Controller.swift
//  newGraph2
//
//  Created by thierryH24A on 23/06/2016.
//  Copyright © 2016 thierryH24A. All rights reserved.
//

import AppKit
import Charts


open class ForecastDailyBarViewController: NSViewController
{
    @IBOutlet var chartView0: HorizontalBarChartView!
    @IBOutlet var chartView1: HorizontalBarChartView!
    @IBOutlet var chartView2: HorizontalBarChartView!
    @IBOutlet var chartView3: HorizontalBarChartView!
    
    @IBOutlet weak var titleView: NSView!
    
    var chartViews = [BarChartView]()
    let colors = [#colorLiteral(red: 0.537254901960784, green: 0.901960784313725, blue: 0.317647058823529, alpha: 1.0), #colorLiteral(red: 0.941176470588235, green: 0.941176470588235, blue: 0.117647058823529, alpha: 1.0), #colorLiteral(red: 0.349019607843137, green: 0.780392156862745, blue: 0.980392156862745, alpha: 1.0), #colorLiteral(red: 0.980392156862745, green: 0.407843137254902, blue: 0.407843137254902, alpha: 1.0)]
    
    let OpenWeatherAPIKey = "ea147318c8f481f57d6a94b4e75ea228"
    var dtMini = 0.0
    let interval = 3600.0 * 24.0
    
    let Defaults = UserDefaults.standard
    
    let textLayer = CATextLayer()
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        self.view.window!.title = "Bar Weather"
    }
    
    override open func viewWillAppear() {
        super.viewWillAppear()
        
        NotificationCenter.receive(instance: self, name: .updateTown, selector: #selector(updateChangeTown(_:)))
    }

    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        let layer = CALayer()
        layer.frame = self.titleView.frame
        layer.backgroundColor = NSColor.clear.cgColor
        self.titleView.layer = layer
        self.titleView.wantsLayer = true
        layer.layoutManager = CAConstraintLayoutManager()
        
        chartViews = [chartView0, chartView1, chartView2, chartView3]
        
        let colors = [#colorLiteral(red: 0.537254901960784, green: 0.901960784313725, blue: 0.317647058823529, alpha: 1.0), #colorLiteral(red: 0.941176470588235, green: 0.941176470588235, blue: 0.117647058823529, alpha: 1.0), #colorLiteral(red: 0.349019607843137, green: 0.780392156862745, blue: 0.980392156862745, alpha: 1.0), #colorLiteral(red: 0.980392156862745, green: 0.407843137254902, blue: 0.407843137254902, alpha: 1.0)]
        
        for i in 0..<chartViews.count
        {
            setupChart(chartViews[i], color: colors[i % colors.count])
        }
        
        textLayer.foregroundColor = NSColor.black.cgColor
        textLayer.frame = layer.frame
        textLayer.string = "Town"
        textLayer.font = "Menlo" as CFTypeRef
        textLayer.fontSize = 32.0
        textLayer.shadowOpacity = 0.5
        textLayer.allowsFontSubpixelQuantization = true
        textLayer.foregroundColor = CGColor(red: 13.0/255.0, green: 116.0/255.0, blue: 1.0, alpha: 1.0)
        
        textLayer.addConstraint(constraint(attribute: .midX, relativeTo: "superlayer", attribute2: .midX))
        textLayer.addConstraint(constraint(attribute: .midY, relativeTo: "superlayer", attribute2: .midY))
        
        layer.addSublayer(textLayer)
        
        ConnectOpenWeather()
    }
    
    func setupChart(_ chartView: BarChartView,  color: NSUIColor)
    {
        chartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.gridBackgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.drawGridBackgroundEnabled = true
        chartView.dragEnabled = true
        chartView.pinchZoomEnabled = false
        chartView.drawBordersEnabled = true
        chartView.maxVisibleCount = 200
        
        chartView.chartDescription.enabled = true
        
        chartView.chartDescription.textAlign = .right
        chartView.chartDescription.textColor = .blue
        
        let xAxis  = chartView.xAxis
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 1.0
        xAxis.labelPosition = .bottom
        xAxis.spaceMin = xAxis.granularity / 2
        xAxis.spaceMax = xAxis.granularity / 2
        xAxis.drawAxisLineEnabled = true
        xAxis.labelCount = 50
        
        let leftAxis = chartView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0.0
        leftAxis.labelTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        chartView.rightAxis.enabled = false
//        chartView.rightAxis1.axisSecondaryEnabled = false
//        chartView.leftAxis1.axisSecondaryEnabled = false
        
        let marker = RectMarker(color: .yellow, font: .systemFont(ofSize: CGFloat(12.0)), insets: NSEdgeInsetsMake(4.0, 4.0, 4.0, 4.0))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: CGFloat(80.0), height: CGFloat(40.0))
        chartView.marker = marker
        
        chartView.legend.enabled = false
    }
    
    @objc func updateChangeTown(_ note: Notification) {
        ConnectOpenWeather()
    }
    
    func ConnectOpenWeather()
    {
        guard id != "" else {return}

        let newApi = HPOpenWeather(apiKey: OpenWeatherAPIKey, temperatureFormat: .celsius, language: .french)
        let nameID = id
        
        let requestCnt = CntRequest("16")
        let request = CityIdRequest(nameID)
        newApi.requestDailyForecast(with: request, requestCnt: requestCnt) { (weather, error) in

            guard let weather = weather, error == nil else {
                print(error?.localizedDescription ?? "default")
                return
            }
            
            var dt = [Double]()
            var temperature = [Double]()
            var humidity = [Double]()
            var rain = [Double]()
            var icon = [String]()
            var speed = [Double]()

            struct dataStruct{
                let dt : Double
                let temperature : Double
                let pressure : Double
                let rain : Int
            }
            
            let dataPoints = weather.dataPoints
            for i in 0..<dataPoints.count
            {
                dt.append( dataPoints[i].forecastTimeStamp)
                temperature.append( dataPoints[i].temperature.day)
                humidity.append( Double(dataPoints[i].humidity))
                rain.append(  Double(dataPoints[i].rain))
                speed.append(  Double(dataPoints[i].rain))
                icon.append( dataPoints[i].condition.icon)
            }
            
            DispatchQueue.main.async {
                
                self.textLayer.string = Flag.of(code:weather.city.countryCode ) + " " + weather.city.name

                self.generateBarData(index: 0, x: dt, y: rain, label: "Rain")
                self.generateBarData(index: 1, x: dt, y: temperature, label: "Temperature")
                self.generateBarData(index: 2, x: dt, y: humidity, label: "Humidity")
                self.generateBarData(index: 3, x: dt, y: speed, label: "Speed")
            }
        }
    }
    
    func generateBarData(index: Int, x : [Double], y :[Double], label: String)
    {
        let scale = self.Defaults.integer(forKey: "EchelleAutomatique")
        if scale == 1
        {
            self.chartViews[index].leftAxis.resetCustomAxisMin()
            self.chartViews[index].leftAxis.resetCustomAxisMax()
            
        }
        else
        {
            if index == 0
            {
                self.chartViews[index].leftAxis.axisMinimum = self.Defaults.double(forKey: "hauteurPluieMini")
                self.chartViews[index].leftAxis.axisMaximum = self.Defaults.double(forKey: "hauteurPluieMaxi")
            }
            
            if index == 1
            {
                self.chartViews[index].leftAxis.axisMinimum = self.Defaults.double(forKey: "temperatureMini")
                self.chartViews[index].leftAxis.axisMaximum = self.Defaults.double(forKey: "temperatureMaxi")
            }
            
            if index == 2
            {
                self.chartViews[index].leftAxis.axisMinimum = 0
                self.chartViews[index].leftAxis.axisMaximum = 100
            }
            
        }
        
        self.dtMini = x.min()!
        
        self.chartViews[index].xAxis.valueFormatter = DateFullValueFormatter(miniTime: self.dtMini, interval: self.interval)
        self.chartViews[index].xAxis.labelCount = x.count
        self.chartViews[index].chartDescription.text = label
        
        let yVals1 = (0..<y.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: y[i])
        }

        var set1 = BarChartDataSet()
        
        set1            = BarChartDataSet(values: yVals1, label: label)
        set1.colors         = [colors[index]]
        set1.valueTextColor = colors[index]
        set1.valueFont      = NSUIFont.systemFont(ofSize: CGFloat(12.0))
        set1.axisDependency = .left
        set1.drawValuesEnabled = false
        
        let barWidth = 1.0
        
        let data = BarChartData(dataSets: [set1])
        data.barWidth       = barWidth
        
        chartViews[index].data = data
    }
}

