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
    
    /// Save reminders info to file
    func saveReminders() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(reminders)
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    /// Load reminders info from file
    func loadReminders() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                let temp = try decoder.decode([Reminder].self, from: data)
                reminders = temp
                
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
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
