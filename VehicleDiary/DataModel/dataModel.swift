//
//  dataModel.swift
//  VehicleDiary
//
//  Created by Vachko on 26.10.20.
//

import Foundation

class DataModel {
    
    var reminders: [Reminder] = []
    
    var indexOfReminders: Int {
        get {
            return UserDefaults.standard.integer(
                forKey: "ReminderIndex")
        }
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: "ReminderIndex")
        }
    }
    
    init() {
        loadReminders()
        registerDefaults()
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent(
            "Reminders.plist")
    }
    
    func saveReminders() {
        print("save")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(reminders)
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
            print(data)
            print(dataFilePath())
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadReminders() {
        print("load")
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                let temp = try decoder.decode([Reminder].self, from: data)
                print ("XXX: \(temp)")
                
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
        print (reminders)
    }
    
    func sortReminders() {
        let sortedReminders = reminders.sorted(by: { $0.dueDate < $1.dueDate })
        reminders = sortedReminders
    }
    
    private func registerDefaults() {
        let dictionary = [ "RemindersIndex": -1 ]
        UserDefaults.standard.register(defaults: dictionary)
    }
}
