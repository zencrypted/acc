import Foundation

struct TimesheetEntry: Identifiable, Hashable {
    let id: UUID
    var employeeName: String
    var department: String
    var daysWorked: Int
    var daysAbsent: Int
    var overtimeHours: Double
    var totalHours: Double
    var status: String
}

struct PayrollLine: Identifiable, Hashable {
    let id: UUID
    var employeeName: String
    var department: String
    var position: String
    var grossPay: Double
    var pit: Double  // Personal Income Tax
    var militaryTax: Double
    var pensionFund: Double
    var otherDeductions: Double
    var netPay: Double
    var status: String
}

struct PayrollPayment: Identifiable, Hashable {
    let id: UUID
    var employeeName: String
    var department: String
    var grossPay: Double
    var totalDeductions: Double
    var netPay: Double
    var paymentMethod: String  // "Bank" or "Cash"
    var paymentDocNumber: String
    var status: String  // "Paid", "Deposited", "Pending"
}

struct EmployeeRecord: Identifiable, Hashable {
    let id: UUID
    var fullName: String
    var personnelNumber: String
    var department: String
    var position: String
    var hireDate: Date
    var salary: Double
    var status: String  // "Active", "On Leave", "New Hire"
}
