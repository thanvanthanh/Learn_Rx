import UIKit
import RxSwift
import RxCocoa

// MARK: Subject hoạt động như vừa là một Observable, vừa là một Observer. Khi một Subject nhận một .next event thì ngay lập tức nó sẽ phát ra các emit cho các subscriber của nó.
//----------------------------------------------------------------------
// MARK:PublishSubject: Khởi đầu empty và chỉ emit các element mới cho Subscriber của nó.

// MARK:BehaviorSubject: Khởi đầu với một giá trị khởi tạo và sẽ relay lại element cuối cùng của chuỗi cho Subscriber mới.

// MARK:ReplaySubject: Khởi tạo với một kích thước bộ đệm cố định, sau đó sẽ lưu trữ các element gần nhất vào bộ đệm này và relay lại các element chứa trong bộ đệm cho một Subscriber mới.

// MARK:AsyncSubject: Chỉ phát ra sự kiện .next cuối cùng trong chuỗi và chỉ khi subject nhận được .completed. Cái này ít được sử dụng, nên chắc skip và hẹn ở một thời gian sau.

// MARK: PublishRelay & BehaviorRelay : là các subject được bọc lại (wrap), nhưng chúng chỉ chấp nhận .next. Bạn không thể thêm các .error hay .completed. Vì vậy chúng thích hợp cho các sự kiện không bao giờ kết thúc.

let subject = PublishSubject<String>()
//subject.onNext("Hello ae")
//let subscroption1 = subject
//    .subscribe(onNext: { value in

//        print(value)
//    })
//subject.onNext("Hello lần nữa")
//subject.onNext("Hello lần thứ 3")
//subject.onNext("Mình đứng đây từ hôm qua")
//
let subscriptionOne = subject
    .subscribe(onNext : { string in
        print(string)
    })
subject.onNext("1")
subject.onNext("2")

let subscriptionTwo = subject
    .subscribe { event in
        print("2)" , event.element ?? event)
    }
subject.onNext("3") ///  số "3" được in 2 lần ,  1 lần cho subscriptionOne và 1 lần cho subscriptionTwo
subscriptionOne.dispose()
subject.onNext("4") /// số 4  chỉ được in cho subscription 2) , vì subscriptionOne đã được xử lý (dispose)


// Behavior Subject
let subject2 = BehaviorSubject(value: "0")
 let disposeBag = DisposeBag()

enum MyError : Error {
    case anError
}
subject2.subscribe {
    print("🔵 " , $0) ///kiểm tra thử việc chúng ta có nhận được giá trị ban đầu khi cấp cho Behavior Subject không
}.disposed(by: disposeBag)

subject2.onNext("1")
//
subject2.subscribe{
    print("🔴 " , $0) /// subscriber thứ 2 nhận được giá trị 1. Do lúc này 1 là mới nhất.
}.disposed(by: disposeBag)

///kết thúc subject với 1 .error.
subject2.onError(MyError.anError)
subject2.subscribe{
    print("🟠 " , $0)
}.disposed(by: disposeBag)
///2 subscriber trước đó sẽ nhận .error và subscriber mới sẽ nhận được error


