import UIKit
import RxSwift

//MARK: - Đặc tính cơ bản của Operators
//Biến đổi dữ liệu này thành một dữ liệu khác.
//Biến đổi cả 1 sequence observable thành 1 sequence observable khác.
//Handle các sự kiện.
//Thực thiện một số chức năng đặc biệt.
//Điều đặc biệt nữa là:
//
//Bạn có thể gọi các Operator liên tiếp nhau.
//Đầu ra của Operator này là đầu vào của Operator khác.
let bag = DisposeBag()

let hello = Observable.from(["1" , "2", "3" , "4" , "5", "6", "7", "8", "9"])

hello.subscribe { value in
    print(value)
} onError: { error in
    print(error)
} onCompleted: {
    print("completed")
} onDisposed: {
    print("disposed")
}
.disposed(by: bag)

//Với reduce là toán tử giúp bạn thu gọn lại toàn bộ các phần tử được phát đi. Để nhận được một giá trị duy nhất. Và khi bạn thực thi đoạn code thì sẽ nhận được một kết quả duy nhất mà thôi.
print("Reduce")
hello
    .reduce("", accumulator: +)
    .subscribe { value in
        print(value)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("disposed")
    }
    .disposed(by: bag)

//Vẫn là Observable trên, lần này ta sử dụng toán tử map. Một trong những toán tử điển hình cho việc biến đổi kiểu dữ liệu.
print("Map")
hello
    .map { Int($0) }
    .subscribe { value in
        print(value ?? 0)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("disposed")
    }

//  Sử dụng các toán tử liên tiếp nhau

hello
    .map { string -> Int in
        Int(string) ?? 0
    }
    .filter { $0 % 2 == 0 }
    .subscribe { value in
        print(value)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("disposed")
    }.disposed(by: bag)
//map biến đổi String thành Int. Nếu có lỗi gì đó thì sẽ thay bằng giá trị là 0
//filter với điều kiện chia hết cho 2. Nên sẽ lọc ra được các phần tử chẵn của chuỗi số đã phát đi.
//đầu ra của map chính là đầu vào của filter
