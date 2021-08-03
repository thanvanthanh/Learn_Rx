import UIKit
import RxCocoa
import RxSwift

let iOS = 1
let android = 2
let flutter = 3

let observable1 = Observable<Int>.just(iOS)
/// observablel là kiểu Observable
/// <Int> là kiểu dữ liệu output cho Observable
///just là toán tử tạo ra 1 Observable sequence với 1 phần tử duy nhất

let observable2 = Observable.of(iOS, android , flutter)
/// Observable sử dụng toán tử of
/// không cần khai báo kiểu dữ liệu cho Output
/// thư viện tự động suy ra kiểu dữ liệu cung cấp trong of(...)

let observable3 = Observable.of([iOS , android , flutter])
/// vẫn là of nhưng kiểu dữ liệu cho observable3 lúc này là Observable<[Int]>
/// nó khác cái ở trên là kiểu giá trị phát ra là 1 Array Int , chứ không phải Int riêng lẻ.

let observable4 = Observable.from([iOS , android , flutter])
/// sử dụng from , tham số cần truyền là 1 array
/// observable4 là Observable<Int> , cách này đỡ phải of nhiều phần tử

let observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: nil) { notification in
    ///ví dụ cho việc lắng nghe từ sự kiện của bàn phím.
}

/// với RxSwift, bạn có thể xem các dữ liệu mà Observable phát ra. Nó cũng là 1 sequence trình tự lần lượt phát đi các phần tử. Nó tương đương với hàm onNext của Observable. Đoạn code sau mô tả cho việc phát đi lần lượt các giá trị.
//let sequence = 0..<3
//var iterator = sequence.makeIterator()
//while let n = iterator.next(){
//    print(n)
//}

/// gọi toán tử .subscribe để handle dữ liệu nhận được , cấp cho nó 1 closure và chỉ có in giá trị ra thôi.
observable1.subscribe{ event in
    print(event)
}
///có cái chữ next & completed cũng khó chịu. Muốn lấy được giá trị trong chữ đó, phải biến tấu thêm
observable2.subscribe{ event in
    if let element = event.element {
        print(element)
    }
}

// Handle Event :
///OnNext:
observable3.subscribe(onNext : { element in
    print(element)
})
/// Full options :
observable4.subscribe { (value) in
    print(value)
} onError: { (error) in
    print(error.localizedDescription)
} onCompleted: {
    print("Completed")
} onDisposed: {
    print("Disposed")
}
/// với Full Options có thể bắt được hết các kiểu event đầy đủ 3 kiểu giá trị mà Observable có thể phát ra .
///đối với mỗi loại , xử lý bằng việc cung cấp 1 closure cho nó , và có thể bỏ bớt đi các handle không cần thiết

// nếu quan tâm tới onNext và onComplete :
observable4.subscribe(onNext : { (value) in
    print(value)
}, onCompleted: {
    print("completed")
})

// MARK: Các dạng đặc biệt của Observables
// Empty : tạo ra 1 observable , và observable này không phát ra phần tử nào và sẽ kết thúc ngay
let observable = Observable<Void>.empty()

observable.subscribe(onNext : { element in
    print(element)
}, onCompleted: {
    print("completed")
})

//Never : cũng tạo ra 1 observable như Empty , không có gì đươhc phát và được nhận hết.
let observabless = Observable<Any>.never()
observabless.subscribe(onNext : { element in
    print(element)
}, onCompleted: {
    print("completeda")
})
/// Empty khác với Never . Never sẽ không phát ra gì và cũng không kết thúc

//Range :
let observabledd = Observable<Int>.range(start: 1, count: 10)
var sum = 0
observabledd
    .subscribe(
        onNext: { i in
            sum += i
        }, onCompleted: {
            print("sum = \(sum)")
        }
    )
