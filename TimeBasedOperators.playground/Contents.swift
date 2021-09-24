import UIKit
import RxSwift
import RxCocoa

let bag = DisposeBag()

let elementsPerSercond = 1
let maxElements = 5
let replayedElements = 1
let replayDelay: TimeInterval = 3

let observable = Observable<Int>.create { observable -> Disposable in
    var value = 1
    
    let soucre = DispatchSource.makeTimerSource( queue: .main)
    soucre.setEventHandler {
        if value <= maxElements { observable.onNext(value)
            value += 1
        }
    }
    soucre.schedule(deadline: .now(), repeating: 1.0 / Double(elementsPerSercond), leeway: .nanoseconds(0))
    soucre.resume()
    
    return Disposables.create {
        soucre.suspend()
    }
}
/** Sử dụng DispatchSource.makeTimerSource để tạo ra 1 timer trên main queue
 Cung cấp 1 closure cho source để xử lý sự kiện sau mỗi vòng lặp thời gian
 source.schedule lên kế hoạch phát dữ liệu theo các tham số trên
 source.resume() để kích hoạt
 Về mặt Disposables.create thì chúng ta handle luôn luôn việc dừng souce tại đây. Đây cũng chính là thắc mắc lâu nay với hàm create để làm gì. */

//DispatchQueue.main.async {
//    observable
//        .subscribe(onNext: { value in
//            print("🔵 : ", value)
//        }, onCompleted: {
//            print("🔵 Complete")
//        }, onDisposed: {
//            print("🔵 Disposed")
//        })
//        .disposed(by:bag )
//}

//MARK: Replaying past elements

public func printValue(_ string: String) {
    let d = Date()
    let df = DateFormatter()
    df.dateFormat = "ss.SSS"
    
    print("\(string) --- at \(df.string(from: d))")
}
let replaySoucre = observable.replayAll()
DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
    replaySoucre
        .subscribe(onNext: { value in
            printValue("🔵: \(value)")
        }, onCompleted: {
            print("🔵 Complete")
        }, onDisposed: {
            print("🔵 Disposed")
        })
        .disposed(by: bag)
}
replaySoucre.connect()

