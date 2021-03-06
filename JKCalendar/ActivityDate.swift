//
//  ActivityDate.swift
//  Presell
//
//  Created by Jarosław Krajewski on 06/12/2016.
//  Copyright © 2016 Ekspert Systemy Informatyczne. All rights reserved.
//

import Foundation


public class ActivityDate{
    var month:Int
    var year:Int
    var day:Int?
    let dateFormatter:DateFormatter!
    static let PL_LOCALE = "pl_PL"
    
    var weekDay:String{
        get{
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self.toDate()).capitalized
        }
    }
    var isWeekendDay:Bool{
        get{
            return Calendar.current.isDateInWeekend(toDate())
        }
    }
    static func ==(left:ActivityDate,right:ActivityDate) -> Bool{
        if left.day == right.day
            && left.month == right.month
            && left.year == right.year{
            return true
        }
        return false
    }
    
    public convenience init(month:Int, year:Int) {
        self.init(month:month, year:year ,day:1)
    }
    
    public init(month:Int, year:Int, day:Int) {
        self.month = month;
        self.year = year
        self.day = day
        dateFormatter = ActivityDate.createTimeFormatter()
    }
    
    
    
    public static func createTimeFormatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: ActivityDate.PL_LOCALE)
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }
    
    public convenience init( from :String, format:String){
        let date = ActivityDate.dateFrom(string:from,format:format)
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        
        if components.day == nil {
            self.init(month: components.month!, year:components.year!)
        }else{
            self.init(month: components.month!, year:components.year!, day:components.day!)
        }
    }
    
    public static func dateFrom(string:String, format:String) ->Date{
        let dateFormatter = createTimeFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: string)!
        
        return date
    }
    
    public static func today() ->ActivityDate{
        let components = Calendar.current.dateComponents([.day, .month,.year], from: Date())
        return ActivityDate(month: components.month!, year: components.year!, day: components.day!)
    }
    
    public var monthAndYear:String{
        get{
            return  string(format:"MMMM yyyy")
        }
    }
    
    public func string(format:String) ->String{
        let date = ActivityDate.dateFrom(string:"\(month) \(year) \(day!)",format:"MM yyyy dd")
        
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    public var monthString:String{
        get{
            let date = ActivityDate.dateFrom(string:"\(month) \(year)",format:"MM yyyy")
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: date)
            
        }
    }
    public func skipMonth(){
        month += 1
        if month > 12 {
            year += 1
            month = 1
        }
    }
    
    public func goToPreviousMonth(){
        month -= 1
        if month < 1 {
            year -= 1
            month = 12
        }
    }
    public func next(months: Int) -> ActivityDate{
        var result = ActivityDate(month:month,year:year)
        for _ in 0 ..<  months{
            result = result.nextMonth()
        }
        return result
    }
    
    private func nextMonth() -> ActivityDate{
        var m = month
        var y = year
        m += 1
        if m > 12{
            y += 1
            m = 1
        }
        return ActivityDate(month: m, year: y)
    }
    
    public func toDate() -> Date{
        if day == nil {
            return ActivityDate.dateFrom(string: "\(year) \(month)", format: "yyyy MM")
        }else {
            return ActivityDate.dateFrom(string: "\(year) \(month) \(day!)", format: "yyyy MM dd")
        }
    }
    
    public func previous(months: Int) -> ActivityDate{
        var result = ActivityDate(month:month,year:year)
        for _ in 0 ..<  months{
            result = result.previousMonth()
        }
        return result
    }
    
    private func previousMonth() ->ActivityDate{
        var m = month
        var y = year
        
        m -= 1
        if m < 1{
            y -= 1
            m = 12
        }
        return ActivityDate(month: m, year: y)
    }
    
    public func next(days: Int) ->ActivityDate{
        
        let result = ActivityDate(month: month, year: year, day: day! + days)
        
        var thisMonth = Month(year: year, month: month)
        
        while result.day! > thisMonth.days{
            result.skipMonth()
            result.day! -= thisMonth.days
            thisMonth = Month(year: result.year, month: result.month)
            
        }
        return result
    }
    
    func monthInformation() -> Month {
        return Month(year: year, month:self.month)
    }
}

