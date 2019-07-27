//
//  MainWindowController.swift
//  iMeteoGraph
//
//  Created by thierryH24 on 04/11/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import AppKit

var id = "6455259"

class MainWindowController: NSWindowController {
    
    var delegate: THSideBarViewDelegate?
    
    @IBOutlet weak var sourceView: NSView!
    @IBOutlet weak var townView: NSView!
    @IBOutlet weak var tableTargetView: NSView!
    
    @IBOutlet weak var splitView: NSSplitView!
    
    var sideBarViewController :  THSideBarViewController?
    var townViewController :  THSideBarViewController?
    
    var weatherHourlyViewController =  WeatherHourlyViewController()
    var forecastDailyBarViewController =  ForecastDailyBarViewController()
    var forecastDailyViewController =  ForecastDailyViewController()
    var currentWeatherViewController =  CurrentWeatherViewController()
    var temperatureDaylyViewController = TemperatureDaylyViewController()
    
    var arrayCity = [Cities1]()
    var town       = Item (name:"Town", icon: "city")
    var weather    = Item (name:"Weather", icon: "01d")
    
    var sectionsCity = [Section]()
    
    let Defaults = UserDefaults.standard
    
    let preferencesWindowController = PreferencesWindowController(
        viewControllers: [
            PreferencesGeneralViewController() ,
            PreferencesAdvancedViewController(),
            PreferencesUnitViewController()
        ]
    )
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        splitView.autosaveName = NSSplitView.AutosaveName( "splitView")
        splitView.minPossiblePositionOfDivider(at: 0)
        splitView.maxPossiblePositionOfDivider(at: 999)
        
        setUpTown()
        setUpSourceWeather()
        
        NotificationCenter.receive(instance: self, name: .addCity, selector: #selector(addCity(_:)))

        delegate = self
    }
    
    @objc func addCity(_ notification: Notification) {
        
        print("addCity")
        
        let citie = notification.object as? Cities1
        
        id = String(citie?.id ?? 0)
        
        let city = Item(name:citie?.name ?? "", icon:"01d", nameView: "City", id: String(citie?.id ?? 0), badge: "0", colorBadge: NSColor.blue)
        sectionsCity[0].item.append(city)
        
        townViewController?.initData( allSection: sectionsCity )
        townViewController?.save()
        townViewController?.reloadData()
    }

    @IBAction func showPreference(_ sender: Any) {
        
        preferencesWindowController.showWindow()
    }
    
    func setUpSourceWeather ()
    {
        self.sideBarViewController = THSideBarViewController()
        
        sideBarViewController?.delegate = self
        sideBarViewController?.colorBackGround = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        sideBarViewController?.rowStyle =  .small
        sideBarViewController?.name = "weather"
        sideBarViewController?.isSaveSection = false
        sideBarViewController?.isAllowDragAndDrop = false

        addSubview(subView: (sideBarViewController?.view)!, toView: sourceView)
        
        setUpLayoutConstraints(item: sideBarViewController!.view, toItem: sourceView)
        self.sideBarViewController!.view.setFrameSize( NSMakeSize(100, 200))
        
        let sections = initDataWeather()
        sideBarViewController?.initData( allSection: sections )

        sideBarViewController?.reloadData()
    }
    
    func initDataWeather() -> [Section] {
        
        let weather    = Item (name:"Weather", icon: "01d")
        var section               = [Section]()
        
        let weather1 = Item(name:"Weather Hourly", icon:"01d", nameView: "WeatherHourlyViewController", badge: "0", colorBadge: NSColor.blue)
        let weather2 = Item(name:"Weather Daily", icon:"01d", nameView: "ForecastDailyViewController", badge: "0", colorBadge: NSColor.blue)
        let weather3 = Item(name:"Weather Daily Bar", icon: "01d", nameView: "ForecastDailyBarViewController", badge: "0", colorBadge: NSColor.blue)
        let weather4 = Item(name:"Current Weather", icon:"01d", nameView: "CurrentWeatherViewController", badge: "0", colorBadge: NSColor.blue)
        let weather5 = Item(name:"Temperature Weather", icon:"01d", nameView: "TemperatureDaylyViewController", badge: "0", colorBadge: NSColor.blue)
        
        var item = [Item]()
        item.append(weather1)
        item.append(weather2)
        item.append(weather3)
        item.append(weather4)
        item.append(weather5)
        
        let section1 = Section(section: weather, item: item)
        section.append(section1)

        return section
    }
    
    func setUpTown()
    {

        self.townViewController = THSideBarViewController()
        
        townViewController?.delegate = self
        townViewController?.colorBackGround = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        townViewController?.rowStyle =  .small
        townViewController?.name = "town"
        townViewController?.isSaveSection = true
        townViewController?.isAllowDragAndDrop = true

        addSubview(subView: (townViewController?.view)!, toView: townView)
        
        setUpLayoutConstraints(item: townViewController!.view, toItem: townView)
        self.townViewController!.view.setFrameSize( NSMakeSize(100, 200))
        
        sectionsCity = townViewController?.load() ?? []
        if sectionsCity.count == 0 {
            sectionsCity = initDataTown()
            townViewController?.save()
        }
        townViewController?.initData( allSection: sectionsCity )
        townViewController?.reloadData()

    }
    
    func initDataTown() -> [Section] {
        
        var section               = [Section]()
        let item = [Item]()

        let town       = Item (name:"Town", icon: "city")
    
        let section1 = Section(section: town, item: item)
        section.append(section1)

        return section
    }
    
    
    func addSubview(subView: NSView, toView parentView : NSView)
    {
        let myView = parentView.subviews
        if myView.count > 0
        {
            parentView.replaceSubview(myView[0], with: subView)
        }
        else
        {
            parentView.addSubview(subView)
        }
    }
    
    func setUpLayoutConstraints(item : NSView, toItem: NSView)
    {
        item.translatesAutoresizingMaskIntoConstraints = false
        let sourceListLayoutConstraints = [
            NSLayoutConstraint(item: item, attribute: .left, relatedBy: .equal, toItem: toItem, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: item, attribute: .right, relatedBy: .equal, toItem: toItem, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1, constant: 0)]
        NSLayoutConstraint.activate(sourceListLayoutConstraints)
    }
    
    
    @IBAction func actionRefresh(_ sender: Any)
    {
        let Defaults = UserDefaults.standard
        Defaults.set("anime", forKey: "THEKEY3")
        Defaults.set("anime", forKey: "THEKEY4")
        Defaults.set("anime", forKey: "THEKEY5")
    }
}

extension MainWindowController: THSideBarViewDelegate
{
    func changeView( item : Item )
    {
        if item.nameView == "City" {
            id = String(item.id)
            NotificationCenter.send(.updateTown)
            return
        }
        
        var  vc = NSView()
        switch item.nameView
        {
        case "WeatherHourlyViewController":
            vc = weatherHourlyViewController.view
            
        case "ForecastDailyViewController":
            vc = forecastDailyViewController.view
            
        case "ForecastDailyBarViewController":
            vc = forecastDailyBarViewController.view
            
        case "CurrentWeatherViewController":
            vc = currentWeatherViewController.view
            
        case "TemperatureDaylyViewController":
            vc = temperatureDaylyViewController.view

        default:
            vc = weatherHourlyViewController.view
        }
        
        addSubview(subView: vc, toView: tableTargetView)
        vc.translatesAutoresizingMaskIntoConstraints = false
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["vc"] = vc
        tableTargetView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vc]|", options: [], metrics: nil, views: viewBindingsDict))
        tableTargetView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[vc]|", options: [], metrics: nil, views: viewBindingsDict))
    }
}


// just for the debug
//extension NSView {
//    
//    override open var description: String {
//        let id = identifier?.rawValue
//        return "id: \(String(describing: id!))"
//    }
//}




