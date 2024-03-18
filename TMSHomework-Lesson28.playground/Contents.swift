import Foundation

var lock = NSLock()
var threadLock = NSLock()

class BankAccount {
    var currentBalance: Decimal = 0

    func deposit(_ value: Decimal) {
        lock.lock()
        currentBalance += value
        print("Пополнение счёта на сумму \(value). Текущий баланс: \(account.currentBalance)")
        lock.unlock()
    }

    func withdraw(_ value: Decimal) {
        lock.lock()
        if value <= currentBalance {
            currentBalance -= value
            print("Снятие со счёта суммы \(value). Текущий баланс: \(account.currentBalance)")
        } else {
            print("Не удалось снять сумму \(value). Недостаточно средств")
        }
        lock.unlock()
    }
}

let account = BankAccount()

let withdrawThread = Thread {
    threadLock.lock()
    account.withdraw(550.20)
    account.withdraw(100.30)
    threadLock.unlock()
}

let depositThread = Thread {
    threadLock.lock()
    account.deposit(2000.50)
    account.deposit(1000)
    threadLock.unlock()
}

depositThread.start()
withdrawThread.start()

// MARK: - Вариант с использованием GCD

class BankAccountGCD {
    var currentBalance: Decimal = 0

    func deposit(_ value: Decimal) {
        currentBalance += value
        print("Пополнение счёта на сумму \(value). Текущий баланс: \(accountGCD.currentBalance)")
    }

    func withdraw(_ value: Decimal) {
        if value <= currentBalance {
            currentBalance -= value
            print("Снятие со счёта суммы \(value). Текущий баланс: \(accountGCD.currentBalance)")
        } else {
            print("Не удалось снять сумму \(value). Недостаточно средств")
        }
    }
}

let accountGCD = BankAccountGCD()

let withdrawalQueue = DispatchQueue(label: "com.example.withdrawalQueue")
let depositQueue = DispatchQueue(label: "com.example.depositQueue")

DispatchQueue.global().sync {
    print("---- GCD вариант ----")
}

depositQueue.sync {
    accountGCD.deposit(200)
    accountGCD.deposit(300)
}

withdrawalQueue.sync {
    accountGCD.withdraw(600)
    accountGCD.withdraw(500)
}

