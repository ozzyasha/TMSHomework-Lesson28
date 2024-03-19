// MARK: - Вариант с использованием GCD
import Foundation

protocol BankAccount {
    func getBalance(result: ((Decimal) -> ())?)
    func deposit(_ value: Decimal)
    func withdraw(_ value: Decimal)
}

class BankAccountGCD: BankAccount {
    var queue = DispatchQueue(label: "com.example.queue", attributes: .concurrent)
    
    func getBalance(result: ((Decimal) -> ())? = nil) {
        queue.async {
            result?(self._balance)
        }
    }
    
    private var _balance: Decimal = 0

    func deposit(_ value: Decimal) {
        queue.async(flags: .barrier) {
            self._balance += value
            print("Пополнение счёта на сумму \(value). Текущий баланс: \(self._balance)")
        }
    }

    func withdraw(_ value: Decimal) {
        queue.async(flags: .barrier) {
            if value <= self._balance {
                self._balance -= value
                print("Снятие со счёта суммы \(value). Текущий баланс: \(self._balance)")
            } else {
                print("Не удалось снять сумму \(value). Недостаточно средств")
            }
        }
    }
    
}

let bankAccount: BankAccount = BankAccountGCD()

let group = DispatchGroup()

DispatchQueue.global().async(group: group) {
    for _ in 1...10000 {
        bankAccount.deposit(1)
    }
}

DispatchQueue.global().async(group: group) {
    for _ in 1...10000 {
        bankAccount.deposit(1)
    }
}

group.notify(queue: DispatchQueue.global()) {
    bankAccount.getBalance { print($0) }
}
