import UIKit
import RxCocoa
import RxSwift

// MARK: - BehaviorSubject luôn luôn phát ra phần tử gần nhất nên bạn không thể tạo ra nó mà không cung cấp giá trị ban đầu. Nếu bạn không thể cung cấp giá trị ban đầu tại thời điểm khởi tạo, có nghĩa là bạn cần dùng PublishSubject thay vì BehaviorSubject.

enum MyEror : Error {
    case anError
}

func print<T: CustomStringConvertible> (label : String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}
// event.element ?? (event.error ?? event) -> nếu element không nil thì trả về event.element, nếu nil thì trả về cái thằng bên trong dấu ngoặc này.

// bên trong dấu ngoặc, nếu error không nil (tức là nó bị error) thì trả về event.error không thì trả về event. Event này thì bạn đã biết event gì rồi đấy, là completed.
let subject = BehaviorSubject(value: "Initial value")
let bag = DisposeBag()

//subject.onError(MyEror.anError)
//subject.subscribe {
//    print(label: "2")
//}
subject.onNext("X")
// 2:  Đến đây X sẽ được in ra, vì X là giá trị gần nhất

subject
    .subscribe{
        print(label : "1" , event: $0)
    }
    .disposed(by: bag)
// 1: Đoạn này tạo một subscription tới subject, và không có bất kì elements nào được add vào subject, cho nên nó sẽ phát lại giá trị ban đầu đến thằng subscriber.Kết quả thu được sẽ là: 1) Initial value



// MARK: - BehaviorSubject được dùng khi bạn muốn thông báo cho một ai đó về dữ liệu gần nhất. Ví dụ như login một app, đôi khi bạn muốn show lại latest value để hiển thị trong form login chẳng hạn.
