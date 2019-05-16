var divisibleByBoth: [Int] = []

func sortNumbers() {
    for index in 0...100 {
        if index % 3 == 0 && index % 5 == 0 {
            print("Mountainland Technical College")
            divisibleByBoth.append(index)
        } else if index % 3 == 0 {
            print("Mountainland")
        } else if index % 5 == 0 {
            print("Technical")
        } else {
            print("\(index)")
        }
    }
    print(divisibleByBoth)
}

sortNumbers()
