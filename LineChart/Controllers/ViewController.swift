//
//  ViewController.swift
//  LineChart
//
//  Thanks to: Nguyen Vu Nhat Minh on 25/8/17.
//  k9doghouse 2019
//

import UIKit 
import CoreMotion

class ViewController: UIViewController {

    var pointEntryArray = [PointEntry]()
    var newPointEntryItem: PointEntry = PointEntry()
    
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var pressureLabel: UILabel!


    var rawPressure = 999.99
    var intervalTimer: Timer!

    let hour = 6//3600
    let altimeter = CMAltimeter()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemProperties4LineChart.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        print("dataFilePath: \(String(describing: dataFilePath))")

        getSensorData()
        intervalTimer3600()
        self.view.backgroundColor = #colorLiteral(red: 0.05952013284, green: 0.4955016375, blue: 0.3789333105, alpha: 1)
    }

    func intervalTimer3600()
    {
        intervalTimer = Timer.scheduledTimer(timeInterval: TimeInterval(hour),
                                             target: self,
                                             selector: #selector(getSensorData),
                                             userInfo: nil,
                                             repeats: true)
    }

    @objc func getSensorData()
    {
        if CMAltimeter.isRelativeAltitudeAvailable()
        {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main)
            {
                (data, error) in
                if !(error != nil)
                {
                    self.rawPressure = Double(truncating: (data?.pressure)!) * 10.00
                    self.pressureLabel.text = String(format: "%.0f", self.rawPressure)+"mb"

                    //MarK - Append the new reading here
                    self.newPointEntryItem.dateTimeTitle = self.pressureLabel.text ?? "appending broke"
                    self.newPointEntryItem.pressureValue = Int(self.rawPressure)

                    self.pointEntryArray.append(self.newPointEntryItem)
                    print("self.newPointEntryItem.pressureValue: \(self.newPointEntryItem.pressureValue)")
                    print("self.newPointEntryItem.dateTimeTitle: \(self.newPointEntryItem.dateTimeTitle)")
                    print("pointEntryArray.count: \(self.pointEntryArray.count)")
                    self.saveItems()
                    self.altimeter.stopRelativeAltitudeUpdates()
                } else {
                    self.pressureLabel.text = " Oops! 😕 1 "
                }
            }
        }  else {
            self.pressureLabel.text = " Oops! 😕 2 "
        }
    }


    //Mark - Model Massaging Methods
    func saveItems() {

        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(pointEntryArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error in encoding item array, \(error)")
        }

        //reload
    }


    //MARK - get all readings from the sensor
    func loadItems() {

        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                pointEntryArray = try decoder.decode([PointEntry].self, from: data)
                print("pointEntryArray.count: \(pointEntryArray.count)")
            } catch {
                print("Error decoding item Array: \(error)")
            }
        }
    }
    @IBAction func refreshButton(_ sender: UIButton)
    { saveItems() }
}
