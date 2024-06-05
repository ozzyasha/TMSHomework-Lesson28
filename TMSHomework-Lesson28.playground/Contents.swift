import Foundation

var lock = NSLock()

class BankAccount {
    var currentBalance: Decimal = 0

    func deposit(_ value: Decimal) {
        lock.lock()
        currentBalance += value
        print("Пополнение счёта на сумму \(value). Текущий баланс: \(currentBalance)")
        lock.unlock()
    }

    func withdraw(_ value: Decimal) {
        lock.lock()
        if value <= currentBalance {
            currentBalance -= value
            print("Снятие со счёта суммы \(value). Текущий баланс: \(currentBalance)")
        } else {
            print("Не удалось снять сумму \(value). Недостаточно средств")
        }
        lock.unlock()
    }
}

let account = BankAccount()

let group = DispatchGroup()

DispatchQueue.global().async(group: group) {
    for _ in 1 ... 10000 {
        account.deposit(1)
    }
}

DispatchQueue.global().async(group: group) {
    for _ in 1 ... 10000 {
        account.deposit(1)
    }
}

group.notify(queue: DispatchQueue.global()) {
    print(account.currentBalance)
}
