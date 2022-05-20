//
//  NSDateExtension.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 18/04/22.
//

import Foundation

extension Date {
    
    func dateInWriting() -> String {
        let date = Calendar.current.dateComponents([.year,.month,.day], from: self)
        let day: String = String(date.day ?? 0)
        var moth = ""
        let year: String = String(date.year ?? 0)
        
        switch date.month {
        case 1:
            moth = "Janeiro"
        case 2:
            moth = "Fevereiro"
        case 3:
            moth = "Março"
        case 4:
            moth = "Abril"
        case 5:
            moth = "Maio"
        case 6:
            moth = "Junho"
        case 7:
            moth = "Julho"
        case 8:
            moth = "Agosto"
        case 9:
            moth = "Setembro"
        case 10:
            moth = "Outubro"
        case 11:
            moth = "Novembro"
        case 12:
            moth = "Dezembro"
        default:
            break
        }
        return "\(day) de \(moth) de \(year)"
    }
    
    func minorDate(dateMessageCurrent: Date) -> Bool {
        let date = Calendar.current.dateComponents([.year,.month,.day], from: self)
        let dateCurrent = Calendar.current.dateComponents([.year,.month,.day], from: dateMessageCurrent)
        
        let dateSum = ((date.year ?? 0) + (date.month ?? 0) + (date.day ?? 0))
        let dateCurrentSum = ((dateCurrent.year ?? 0) + (dateCurrent.month ?? 0) + (dateCurrent.day ?? 0))
        
        if  dateSum < dateCurrentSum {
            return true
        } else {
            return false
        }
    }
}
