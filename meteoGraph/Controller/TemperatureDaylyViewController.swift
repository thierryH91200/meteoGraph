//
//  TemperatureHourlyViewController.swift
//  iMeteoGraph
//
//  Created by thierry hentic on 27/06/2019.
//  Copyright © 2019 thierryH24. All rights reserved.
//

import AppKit
import Charts

class TemperatureDaylyViewController: NSViewController {
    
    @IBOutlet var chartView: LineChartView!
    @IBOutlet weak var titleView: NSView!
    
    var dtMini = Double()
    let interval = 3600.0 * 3.0
    
    let Defaults = UserDefaults.standard
    
    let textLayer = CATextLayer()
    var isAnimate = true

    override func viewDidAppear()
    {
        super.viewDidAppear()
        self.view.window?.title = "Temperature Hourly"
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NotificationCenter.receive(instance: self, name: .updateTown, selector: #selector(updateChangeTown(_:)))
        NotificationCenter.receive( instance: self,name: .preferencesChanged, selector: #selector(reloadUI))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let layer = CALayer()
        layer.frame = self.titleView.frame
        layer.backgroundColor = NSColor.clear.cgColor
        self.titleView.layer = layer
        layer.layoutManager = CAConstraintLayoutManager()

        chartView.backgroundColor = .white
        chartView.gridBackgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.drawGridBackgroundEnabled = true
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
        xAxis.drawGridLinesEnabled = true
        xAxis.granularity = 1.0
        
        xAxis.nameAxis = "Date"
        xAxis.nameAxisEnabled = true
        
        let leftAxis = self.chartView.leftAxis
        leftAxis.enabled = true
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.gridColor = .black
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = false
        
        leftAxis.labelTextColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        leftAxis.valueFormatter = DoubleAxisValueFormatter(postFixe: "°C")
        
        leftAxis.nameAxis = "Température"
        leftAxis.nameAxisEnabled = true
        
        self.chartView.rightAxis.enabled = false
        
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

        isAnimate = true
        ConnectOpenWeather()
    }
    
    @objc func updateChangeTown(_ note: Notification) {
        isAnimate = true
        ConnectOpenWeather()
    }
    @objc func reloadUI(_ notification: Notification) {
        isAnimate = false
        ConnectOpenWeather()
    }
    
    func ConnectOpenWeather()
    {
        guard id != "" else {return}

        let newApi = HPOpenWeather(apiKey: OpenWeatherAPIKey, temperatureFormat: .celsius, language: .french)
        let nameID = id
        let requestCnt = CntRequest("16")
        let request = CityIdRequest(nameID)
                
        newApi.requestDailyForecast(with: request, requestCnt: requestCnt)  { (weather, error) in
            
            guard let weather = weather, error == nil else {
                print(error?.localizedDescription ?? "erreur")
                return;
            }
                        
            var temperatureMin = [Double]()
            var temperatureMax = [Double]()
            var temperatureDay = [Double]()
            var icon = [String]()
            var dt = [Double]()
            
            let dataPoints = weather.dataPoints
            for i in 0..<dataPoints.count
            {
                dt.append( dataPoints[i].forecastTimeStamp)
                temperatureDay.append( dataPoints[i].temperature.day)
                temperatureMin.append( dataPoints[i].temperature.minimum)
                temperatureMax.append(  Double(dataPoints[i].temperature.maximum))
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
                }
                else
                {
                    self.chartView.leftAxis.axisMinimum = preferences[.temperatureMini]
                    self.chartView.leftAxis.axisMaximum = preferences[.temperatureMaxi]
                }
                
                self.chartView.xAxis.valueFormatter = DateFullValueFormatter(miniTime: self.dtMini, interval: self.interval)
                self.chartView.xAxis.labelCount = dt.count + 48
                
                let iconWeather = NSImage(named:  NSImage.Name( "01d"))
                let marker = RectMarker(color: NSUIColor.yellow, font: NSUIFont.systemFont(ofSize: CGFloat(12.0)), insets: NSEdgeInsetsMake(4.0, 4.0, 4.0, 4.0))
                marker.chartView = self.chartView
                marker.image = iconWeather
                marker.miniTime = dt.min()!
                marker.interval = 3600 * 3
                marker.minimumSize = CGSize(width: CGFloat(80.0), height: CGFloat(40.0))
                self.chartView.marker = marker
                
                let data = self.generateLineData(x: dt, y1: temperatureMax, y2: temperatureMin, y3: temperatureDay, icon: icon)
                self.chartView.data = data
            }
        }
        if isAnimate == true {
            self.chartView.animate(xAxisDuration: 1.0)
        }
    }
    
    func generateLineData(x: [Double], y1: [Double], y2: [Double], y3: [Double], icon: [String]) -> LineChartData
    {
        var iconOld = ""
        
        let yVals1 = (0..<y1.count).map { (i) -> ChartDataEntry in
            let x1 = ( x[i] - dtMini) / interval
            let image = NSImage(named: NSImage.Name( icon[i]))
            var img = image?.resizeImage(width: (image?.size.width)! / 2, (image?.size.height)! / 2)
            if iconOld != icon[i] {
                iconOld = icon[i]
            }
            else {
                img = nil
            }
            return ChartDataEntry(x: x1, y: y1[i], icon: img)
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "Temp max")
        set1.colors = [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
        set1.lineWidth = 2.5
        set1.mode = .cubicBezier
        set1.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set1.valueTextColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        set1.drawCirclesEnabled = false
        set1.axisDependency = .left
        set1.drawIconsEnabled = true
        set1.iconsOffset = CGPoint(x: 0, y: 20.0)
        
        let formatter1 = BarChartFormatter()
        set1.drawValuesEnabled = true
        formatter1.setValues(unit: " °C")
        set1.valueFormatter =  formatter1
        
        let yVals2 = (0..<y2.count).map { (i) -> ChartDataEntry in
            let x1 = ( x[i] - dtMini) / interval
            return ChartDataEntry(x: x1 , y: y2[i])
        }
        
        let set2 = LineChartDataSet(values: yVals2, label: "Temp Min")
        set2.colors = [#colorLiteral(red: 0.8725001216, green: 0.2796577215, blue: 0.05547843128, alpha: 1)]
        set2.lineWidth = 2.5
        set2.mode = .cubicBezier
        set2.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set2.valueTextColor = #colorLiteral(red: 0.8725001216, green: 0.2796577215, blue: 0.05547843128, alpha: 1)
        set2.axisDependency = .left
        set2.drawCircleHoleEnabled = false
        set2.drawCirclesEnabled = false
        set2.drawValuesEnabled = false
        
        
        let formatter2 = BarChartFormatter()
        formatter2.setValues(unit: " °C")
        set2.valueFormatter =  formatter2
        
        let yVals3 = (0..<y3.count).map { (i) -> ChartDataEntry in
            let x1 = ( x[i] - dtMini) / interval
            return ChartDataEntry(x: x1 , y: y3[i])
        }
        
        let set3 = LineChartDataSet(values: yVals3, label: "Temp Day")
        set3.colors = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
        set3.lineWidth = 2.5
        set3.mode = .cubicBezier
        set3.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set3.valueTextColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        set3.axisDependency = .left
        set3.drawCircleHoleEnabled = false
        set3.drawCirclesEnabled = false
        set3.drawValuesEnabled = false
        
        let formatter3 = BarChartFormatter()
        formatter3.setValues(unit: " °C")
        set3.valueFormatter =  formatter3
        
        var dataSets = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)
        
        let data = LineChartData(dataSets: dataSets)
        return data
    }
    
    
}
