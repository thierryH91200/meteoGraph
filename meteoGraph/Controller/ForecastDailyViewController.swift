//
//  vc2Controller.swift
//  newGraph2
//
//  Created by thierryH24A on 23/06/2016.
//  Copyright © 2016 thierryH24A. All rights reserved.
//

import AppKit
import Charts

class ForecastDailyViewController: NSViewController
{   
    @IBOutlet var chartView: CombinedChartView!
    @IBOutlet weak var titleView: NSView!
    
    let OpenWeatherAPIKey = "ea147318c8f481f57d6a94b4e75ea228"
    var dtMini = Double()
    let interval = 3600.0 * 24.0
    
    let Defaults = UserDefaults.standard
    
    let textLayer = CATextLayer()
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        self.view.window!.title = "Daily Weather"
        
//        self.parent?.view.wantsLayer = true
//        self.parent?.view.layer?.contents = nil
//        self.parent?.view.needsDisplay = true
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        NotificationCenter.receive(instance: self, name: .updateTown, selector: #selector(updateChangeTown(_:)))
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let layer = CALayer()
        layer.frame = self.titleView.frame
        layer.backgroundColor = NSColor.clear.cgColor
        self.titleView.layer = layer
        layer.layoutManager = CAConstraintLayoutManager()
        
        chartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.gridBackgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        chartView.drawGridBackgroundEnabled = true
        chartView.dragEnabled = true
        self.chartView.pinchZoomEnabled = true
        chartView.drawBordersEnabled = true
        chartView.maxVisibleCount = 200
        
        chartView.chartDescription.enabled = true
        chartView.chartDescription.textAlign = .right
        chartView.chartDescription.textColor = NSUIColor.blue
        
        let xAxis  = chartView.xAxis
        xAxis.gridLineDashLengths = [10.0, 10.0]
        xAxis.gridLineDashPhase = 0.0
        xAxis.gridColor = .black
        xAxis.labelPosition = .bottom
        xAxis.labelRotationAngle = -90
        xAxis.granularity = 1.0
        xAxis.spaceMin = xAxis.granularity / 5
        xAxis.spaceMax = xAxis.granularity / 5
        
        xAxis.nameAxis = "Date"
        xAxis.nameAxisEnabled = true
        
        let leftAxis = self.chartView.leftAxis
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.gridColor = .black
        leftAxis.drawZeroLineEnabled = true
        leftAxis.labelTextColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        leftAxis.valueFormatter = DoubleAxisValueFormatter(postFixe: "°C")
        
        leftAxis.nameAxis = "Temperature"
        leftAxis.nameAxisEnabled = true
        
//        let leftAxis1 = self.chartView.leftAxis
//        leftAxis1.axisSecondaryEnabled = true
//        leftAxis1.drawGridLinesEnabled = false
//        leftAxis1.drawZeroLineEnabled = true
//        leftAxis1.labelTextColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
//        leftAxis1.valueFormatter = DoubleAxisValueFormatter(postFixe: "mm")
        
//        leftAxis1.nameAxis = "Hauteur"
//        leftAxis1.nameAxisEnabled = true
        
        let rightAxis = self.chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.labelTextColor = #colorLiteral(red: 0.8725001216, green: 0.2796577215, blue: 0.05547843128, alpha: 1)
        rightAxis.valueFormatter = DoubleAxisValueFormatter(postFixe: "hPa")
        
        rightAxis.nameAxis = "Pression"
        rightAxis.nameAxisEnabled = true
        
//        self.chartView.rightAxis1.axisSecondaryEnabled = false
        
        chartView.legend.form = .line
        chartView.legend.enabled = true
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
    
    @objc func updateChangeTown(_ notification: Notification) {
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
            var pressure = [Double]()
            var rain = [Double]()
            var icon = [String]()
            
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
                pressure.append( dataPoints[i].pressure)
                rain.append(  Double(dataPoints[i].rain))
                icon.append( dataPoints[i].condition.icon)
            }
            self.dtMini = dt.min()!
            
            DispatchQueue.main.async {
                
                self.textLayer.string = Flag.of(code:weather.city.countryCode ) + " " + weather.city.name

                let scale = self.Defaults.integer(forKey: "EchelleAutomatique")
                if scale == 1
                {
                    self.chartView.leftAxis.resetCustomAxisMin()
                    self.chartView.leftAxis.resetCustomAxisMax()
                    //                self.chartView.leftAxis1.resetCustomAxisMin()
                    //                self.chartView.leftAxis1.resetCustomAxisMax()
                    self.chartView.rightAxis.resetCustomAxisMin()
                    self.chartView.rightAxis.resetCustomAxisMax()
                }
                else
                {
                    self.chartView.leftAxis.axisMinimum = self.Defaults.double(forKey: "temperatureMini")
                    self.chartView.leftAxis.axisMaximum = self.Defaults.double(forKey: "temperatureMaxi")
                    
                    //                self.chartView.leftAxis1.axisMinimum = self.Defaults.double(forKey: "hauteurPluieMini")
                    //                self.chartView.leftAxis1.axisMaximum = self.Defaults.double(forKey: "hauteurPluieMaxi")
                    
                    self.chartView.rightAxis.axisMinimum = self.Defaults.double(forKey: "pressionMini")
                    self.chartView.rightAxis.axisMaximum = self.Defaults.double(forKey: "pressionMaxi")
                }
                
                self.chartView.xAxis.valueFormatter = DateFullValueFormatter(miniTime: self.dtMini, interval: self.interval)
                
                self.chartView.xAxis.labelCount = dataPoints.count
                
                let marker = RectMarker(color: NSUIColor.yellow, font: NSUIFont.systemFont(ofSize: CGFloat(12.0)), insets: NSEdgeInsetsMake(4.0, 4.0, 4.0, 4.0))
                marker.chartView = self.chartView
                marker.minimumSize = CGSize(width: CGFloat(80.0), height: CGFloat(40.0))
                marker.miniTime = self.dtMini
                marker.interval = 3600 * 24
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
        set1.colors = [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
        set1.lineWidth = 2.5
        set1.mode = .cubicBezier
        set1.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set1.valueTextColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        set1.drawCirclesEnabled = false
        set1.axisDependency = .left
        set1.drawIconsEnabled = true
        set1.iconsOffset = CGPoint(x: 0, y: 20.0)
        set1.drawValuesEnabled = true
        
        let formatter1 = BarChartFormatter()
        formatter1.setValues(unit: " °C")
        set1.valueFormatter =  formatter1
        
        let set2 = LineChartDataSet(values: yVals2, label: "Pressure")
        set2.colors = [#colorLiteral(red: 0.8725001216, green: 0.2796577215, blue: 0.05547843128, alpha: 1)]
        set2.lineWidth = 2.5
        set2.mode = .cubicBezier
        set2.valueFont = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set2.valueTextColor = #colorLiteral(red: 0.8725001216, green: 0.2796577215, blue: 0.05547843128, alpha: 1)
        set2.axisDependency = .right
        set2.drawCircleHoleEnabled = false
        set2.drawCirclesEnabled = false
        set2.drawValuesEnabled = false
        
        let formatter2 = BarChartFormatter()
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
        set1.colors         = [#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)]
        set1.valueTextColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        set1.valueFont      = NSUIFont.systemFont(ofSize: CGFloat(10.0))
        set1.axisDependency = .left
        set1.drawIconsEnabled = false
        
        let formatter = BarChartFormatter()
        set1.drawValuesEnabled = true
        formatter.setValues(unit: " mm")
        set1.valueFormatter =  formatter
        
        let data = BarChartData(dataSets: [set1])
        return data
    }
    
    
    
    // Zoom Buttons
    @IBAction func zoomAll(_ sender: AnyObject) {
        chartView.fitScreen()
    }
    
    @IBAction func zoomIn(_ sender: AnyObject) {
        chartView.zoomToCenter(scaleX: 1.5, scaleY: 1) //, x: self.view.frame.width, y: 0)
    }
    
    @IBAction func zoomOut(_ sender: AnyObject) {
        chartView.zoomToCenter(scaleX: 2/3, scaleY: 1) //, x: self.view.frame.width, y: 0)
    }
}

extension CAGradientLayer
{
    func turquoiseColor() -> CAGradientLayer {
        let topColor = NSUIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = NSUIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: Array <AnyObject> = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: Array <NSNumber> = [0.0 , 1.0 ]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}

extension NSImage {
    func resizeImage(width: CGFloat, _ height: CGFloat) -> NSImage {
        let img = NSImage(size: CGSize(width:width, height:height))
        
        img.lockFocus()
        let ctx = NSGraphicsContext.current
        ctx?.imageInterpolation = .high
        self.draw(in: NSMakeRect(0, 0, width, height), from: NSMakeRect(0, 0, size.width, size.height), operation: .copy, fraction: 1)
        img.unlockFocus()
        
        return img
    }
}

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, ValueFormatter
{
    let formatter = NumberFormatter()
    var unit = String()
    
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.minimumIntegerDigits = 1
        let str = "\(formatter.string(from: NSNumber(value: value))!)\(self.unit)"
        return str
    }
    
    public func setValues(unit: String)
    {
        self.unit = unit
    }
}
