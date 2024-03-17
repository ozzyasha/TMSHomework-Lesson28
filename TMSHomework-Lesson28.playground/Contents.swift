import Foundation

var lock = NSLock()

class BankAccount {
    var currentBalance: Decimal = 0

    var balance: Decimal {
        get {
            let temp = currentBalance
            return temp
        } set {
            currentBalance = newValue
        }
    }

    func deposit(_ value: Decimal) {
        currentBalance += value
        print("Пополнение счёта на сумму \(value). Текущий баланс: \(account.balance)")
    }

    func withdraw(_ value: Decimal) {
        if balance > 0 {
            currentBalance -= value
            print("Снятие со счёта суммы \(value). Текущий баланс: \(account.balance)")
        } else {
            print("Не удалось снять сумму \(value). Недостаточно средств")
        }
    }
}

let account = BankAccount()

let depositThread = Thread {
    lock.lock()
    account.deposit(2000.50)
    account.deposit(1000)
    lock.unlock()
}

let withdrawThread = Thread {
    lock.lock()
    account.withdraw(550.20)
    account.withdraw(100.30)
    lock.unlock()
}

depositThread.start()
withdrawThread.start()
