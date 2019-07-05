//
//  ViewControllerPressureReadings.swift
//  LineChart
//
//  Thanks to: Nguyen Vu Nhat Minh on 25/8/17.
//  https://github.com/nhatminh12369/LineChart.git
//  His tutorial on Medium.com:
//  https://medium.com/@leonardnguyen/building-your-own-chart-in-ios-part-2-line-chart-7b5cfc7c866
//
//  k9doghouse 2019
//  https://github.com/k9doghouse/LineChart-Pressure.git
//

import UIKit 
import CoreMotion

class ViewControllerPressureReadings: UIViewController {

    var pointEntryArray: [PointEntry] = []
    var newPointEntryItem: PointEntry = PointEntry()
    
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!


    var rawPressure = 999.99
    var intervalTimer: Timer!

    let hour = 3600
    let day: Int = 86400
    let altimeter = CMAltimeter()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory,
                        in: .userDomainMask).first?.appendingPathComponent("PressureDataLineChart.plist")

    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.05952013284, green: 0.4955016375, blue: 0.3789333105, alpha: 1)

        loadHistoricalReadings()
        getSensorData()
        intervalTimer3600()
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

                    // time and date
                    var date = Date()
                    date.addTimeInterval(TimeInterval(self.day))
                    let currentDateTime = Date()

                    let formatter00 = DateFormatter()
                    formatter00.timeStyle = .short
                    formatter00.dateStyle = .short
                    formatter00.string(from: currentDateTime)
                    self.dateTimeLabel.text = formatter00.string(from: currentDateTime)

                    //MARK - Append the new entry here
                    self.newPointEntryItem.dateTimeTitle = self.dateTimeLabel.text ?? "appending broke"
                    self.newPointEntryItem.pressureValue = Int(self.rawPressure)
                    self.pointEntryArray.append(self.newPointEntryItem)
                    
                    //Mark - Save the new entry
                    self.saveNewReading()
                    self.altimeter.stopRelativeAltitudeUpdates()
                } else { self.pressureLabel.text = " Oops! 😕 1 " }
            }  }  else { self.pressureLabel.text = " Oops! 😕 2 " }
    }


    //Mark - Model Massaging Methods
    func saveNewReading() {

        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(pointEntryArray)
            try data.write(to: dataFilePath!)

            //MARK - update the line graph after the save()
            lineChart.dataEntries = pointEntryArray
        } catch {
            print("Error in encoding item array, \(error)")
        }

        //reload
    }


    //MARK - get all readings from the sensor
    func loadHistoricalReadings() {

        if let data = try? Data(contentsOf: dataFilePath!) {

            let decoder = PropertyListDecoder()
            do {
                pointEntryArray = try decoder.decode([PointEntry].self, from: data)

                for point in 0..<pointEntryArray.count {
                    print("point: \(point) \(pointEntryArray[point].dateTimeTitle), \(pointEntryArray[point].pressureValue)\n")
                    
                }

            } catch {
                print("Error decoding item Array: \(error)")
            }
        }
    }
    @IBAction func refreshButton(_ sender: UIButton)
    { getSensorData() }
}
