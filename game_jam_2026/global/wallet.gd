extends Node

var balance = 5

func addMoney(money: int):
	balance += money
	
func takeMoney(money: int):
	if(checkWalletHasEnoughFor(2)):
		balance -= money

func checkWalletHasEnoughFor(money: int):
	if(balance >= money):
		return true
	return false
