//
//  WeatherHourlyViewController.swift
//  iMeteoGraph
//
//  Created by thierryH24 on 07/11/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import AppKit
import Charts

class WeatherHourlyViewController: NSViewController {
    
    @IBOutlet weak var titleView: NSView!
    @IBOutlet var chartView: CombinedChartView!
    
    var dtMini = 0.0
    let interval = 3600.0 * 3.0
    
    let Defaults = UserDefaults.standard
    
    let textLayer = CATextLayer()
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        self.view.window?.title = "Weather Hourly"
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NotificationCenter.receive(instance: self, name: .updateTown, selector: #selector(updateChangeTown(_:)))
        NotificationCenter.receive( instance: self,name: .preferencesChanged, selector: #selector(reloadUI))
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
        
        chartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.gridBackgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.drawGridBackgroundEnabled = true
        chartView.dragEnabled = true
        chartView.pinchZoomEnabled = true
        chartView.drawBordersEnabled = true
        chartView.maxVisibleCount = 200
        chartView.autoScaleMinMaxEnabled = true
        
        chartView.chartDescription.enabled = true
        chartView.chartDescription.textAlign = .right
        chartView.chartDescription.textColor = NSUIColor.blue
        
        let xAxis  = chartView.xAxis
        xAxis.gridLineDashLengths = [10.0, 10.0]
        xAxis.gridLineDashPhase = 0.0
        xAxis.gridColor = .black
        xAxis.centerAxisLabelsEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.labelRotationAngle = -90
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        
        xAxis.nameAxis = "Date"
        xAxis.nameAxisEnabled = true
        
        let leftAxis = self.chartView.leftAxis
        leftAxis.enabled = true
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.gridColor = .black
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularityEnabled = false
        
        leftAxis.labelTextColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        leftAxis.valueFormatter = DoubleAxisValueFormatter(postFixe: "°C")
        
        leftAxis.nameAxis = "Température"
        leftAxis.nameAxisEnabled = true
                
        let rightAxis = self.chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.labelTextColor = #colorLiteral(red: 0.8725001216, green: 0.2796577215, blue: 0.05547843128, alpha: 1)
        rightAxis.valueFormatter = DoubleAxisValueFormatter(postFixe: "hPa")
        
        rightAxis.nameAxis = "Pression"
        rightAxis.nameAxisEnabled = true
        
        //        self.chartView.rightAxis1.axisSecondaryEnabled = false
        
        chartView.legend.enabled = true
        chartView.legend.form = .line
        chartView.legend.verticalAlignment = .top
        chartView.legend.horizontalAlignment = .left
        chartView.legend.drawInside = false
        
        chartView.chartDescription.enabled = false
        
        textLayer.foregroundColor = NSColor.black.cgColor
        textLayer.frame = layer.frame
        textLayer.string = ""
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
    
    @objc func updateChangeTown(_ note: Notification) {
        ConnectOpenWeather()
    }
    @objc func reloadUI(_ notification: Notification) {
        ConnectOpenWeather()
    }

    
    func ConnectOpenWeather()
    {
        guard id != "" else {return}

        let newApi = HPOpenWeather(apiKey: OpenWeatherAPIKey, temperatureFormat: .celsius, language: .french)
        let nameID = id
        let requestCnt = CntRequest("16")
        
        let request = CityIdRequest(nameID)
        newApi.requestHourlyForecast(with: request, requestCnt: requestCnt, for: .threeHourly) { (weather, error) in
            
            guard let weather = weather, error == nil else {
                print(error?.localizedDescription ?? "erreur")
                return;
            }
                        
            var temperature = [Double]()
            var pressure = [Double]()
            var rain = [Double]()
            var icon = [String]()
            var dt = [Double]()
            
            let dataPoints = weather.dataPoints
            for i in 0..<dataPoints.count
            {
                dt.append( dataPoints[i].forecastTimeStamp)
                temperature.append( dataPoints[i].main.temperature )
                pressure.append( dataPoints[i].main.pressure)
                rain.append(  Double(dataPoints[i].rain.lastThreeHours))
                icon.append( dataPoints[i].condition.iconString)
            }
            self.dtMini = dt.min()!
            
            DispatchQueue.main.async {
                
                self.textLayer.string = Flag.of(code:weather.city.countryCode ) + " " + weather.city.name

                let scale = self.Defaults.integer(forKey: "EchelleAutomatique")
                if scale == 1
                {
                    self.chartView.leftAxis.resetCustomAxisMin()
                    self.chartView.leftAxis.resetCustomAxisMax()

                    self.chartView.rightAxis.resetCustomAxisMin()
                    self.chartView.rightAxis.resetCustomAxisMax()
                }
                else  {
                    self.chartView.leftAxis.axisMinimum = self.Defaults.double(forKey: "temperatureMini")
                    self.chartView.leftAxis.axisMaximum = self.Defaults.double(forKey: "temperatureMaxi")
                    
                    self.chartView.rightAxis.axisMinimum = self.Defaults.double(forKey: "pressionMini")
                    self.chartView.rightAxis.axisMaximum = self.Defaults.double(forKey: "pressionMaxi")
                }
                
                self.chartView.xAxis.valueFormatter = DateValueFormatter(miniTime: self.dtMini, interval: self.interval, dateStep: "00:00")
                self.chartView.xAxis.labelCount = dt.count + 48
                
                let iconWeather = NSImage(named:  NSImage.Name( "01d"))
                let marker = RectMarker(color: NSUIColor.yellow, font: NSUIFont.systemFont(ofSize: CGFloat(12.0)), insets: NSEdgeInsetsMake(4.0, 4.0, 4.0, 4.0))
                marker.chartView = self.chartView
                marker.image = iconWeather
                marker.miniTime = dt.min()!
                marker.interval = 3600 * 3
                marker.minimumSize = CGSize(width: CGFloat(80.0), height: CGFloat(40.0))
                self.chartView.marker = marker
                
                let data = CombinedChartData()
                data.lineData = self.generateLineData(x: dt, y1: temperature, y2: pressure, icon: icon)
                data.barData = self.generateBarData(x: dt, y: rain)
                self.chartView.data = data
            }
        }
        
        self.chartView.animate(xAxisDuration: 1.0)
    }
    
    func generateLineData(x: [Double], y1: [Double], y2: [Double], icon: [String]) -> LineChartData
    {
        var iconOld = ""
        
        let yVals1 = (0..<y1.count).map { (i) -> ChartDataEntry in
            let x1 = ( x[i] - dtMini) / interval
            let image = NSImage(named: NSImage.Name( icon[i]))
            var img = image?.resizeImage(width: (image?.size.width)! / 2, (image?.size.height)! / 2)
            if iconOld != icon[i]
            {
                iconOld = icon[i]
            }
            else
            {
                img = nil
            }
            return ChartDataEntry(x: x1, y: y1[i], icon: img)
        }
        
        let yVals2 = (0..<y1.count).map { (i) -> ChartDataEntry in
            let x1 = ( x[i] - dtMini) / interval
            return ChartDataEntry(x: x1 , y: y2[i])
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "Temperature")
        set1.colors = [preferences.colorTemperature]
        set1.lineWidth = 2.5
        set1.mode = .cubicBezier
        set1.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set1.valueTextColor = preferences.colorTemperature
        set1.drawCirclesEnabled = false
        set1.axisDependency = .left
        set1.drawIconsEnabled = true
        set1.iconsOffset = CGPoint(x: 0, y: 20.0)
        
        let formatter1 = BarChartFormatter()
        set1.drawValuesEnabled = true
        //        set1.valueRotationAngle = 0
        formatter1.setValues(unit: " °C")
        set1.valueFormatter =  formatter1
        
        let set2 = LineChartDataSet(values: yVals2, label: "Pressure")
        set2.colors = [preferences.colorPressure]
        set2.lineWidth = 2.5
        set2.mode = .cubicBezier
        set2.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set2.valueTextColor = preferences.colorPressure
        set2.axisDependency = .right
        set2.drawCircleHoleEnabled = false
        set2.drawCirclesEnabled = false
        
        let formatter2 = BarChartFormatter()
        set2.drawValuesEnabled = false
        formatter2.setValues(unit: " hPa")
        set2.valueFormatter =  formatter2
        
        var dataSets = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        
        let data = LineChartData(dataSets: dataSets)
        return data
    }
    
    func generateBarData(x : [Double], y :[Double]) -> BarChartData
    {
        let yVals1 = (0..<y.count).map { (i) -> ChartDataEntry in
            let x1 = ( x[i] - dtMini) / interval
            return BarChartDataEntry(x: x1 , y: y[i])
        }
        
        let set1            = BarChartDataSet(values: yVals1, label: "Rain")
        set1.colors         = [preferences.colorRain]
        set1.valueTextColor = preferences.colorRain
        set1.valueFont      = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set1.axisDependency = .left
        set1.drawIconsEnabled = false
        
        let formatter = BarChartFormatter()
        set1.drawValuesEnabled = true
        //        set1.valueRotationAngle = -90
        formatter.setValues(unit: " mm")
        set1.valueFormatter =  formatter
        
        let data = BarChartData(dataSets: [set1])
        return data
    }
}
