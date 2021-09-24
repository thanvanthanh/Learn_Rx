import UIKit
import RxSwift
import RxCocoa

struct User {
    let message: BehaviorSubject<String>
}

//MARK: - Error
enum MyError: Error {
  case anError
}

let bag = DisposeBag()

let cuTy = User(message: BehaviorSubject(value: "Tý: Cu Tý chào bạn!"))
let cuTeo = User(message: BehaviorSubject(value: "Tèo: Cu Tèo chào bạn!"))

let subject = PublishSubject<User>()

let roomChat = subject
    .flatMapLatest { $0.message.materialize() } // Observable<Event<String>> // Observable<String>
// Event? event.error
// roomChat
//    .subscribe(onNext: { msg in
//        print(msg)
//    })
//    .disposed(by: bag)

roomChat
   .filter{
       guard $0.error == nil else {
           print("Lỗi phát sinh: \($0.error!)")
           return false
       }

       return true
   }
    .dematerialize()
   .subscribe(onNext: { msg in
       print(msg)
   })
   .disposed(by: bag)

subject.onNext(cuTy)

cuTy.message.onNext("Tý: A")
cuTy.message.onNext("Tý: B")
cuTy.message.onNext("Tý: C")

cuTy.message.onError(MyError.anError)
cuTy.message.onNext("Tý: D")
cuTy.message.onNext("Tý: E")

subject.onNext(cuTeo)
   
cuTeo.message.onNext("Tèo: 1")
cuTeo.message.onNext("Tèo: 2")


 //việc cuTy phát ra 1 onError toàn bộ code đã bị sụp đổ. Chúng ta không thể nào handle được các Observable như cuTy phát đi error hay can thiệp vào property của nó. Để giải quyết chúng nó thì ta có cách sau.

//MARK: - materialize
//sử dụng lại đoạn code sau với việc thêm toán tử materialize(dòng 22).
//đã nhận hết các phần tử có thể nhận, kể cả error. Tuy nhiên, có điều lạ ở đây. Nó chính là việc thay vì nhận các giá trị của .next, bây giờ bất cứ event nào cũng sẽ bị biến thành giá trị hết.

// Và khi trỏ vào roomChat và nhấn giữ Option + click chuột thì bạn sẽ thấy kiểu dữ liệu của nó là Observable<Event<Int>>. --> toán tử materialize sẽ biến đổi các event của Observable thành một element.

//MARK: - dematerialize:
// Để biến đổi ngược lại thì như thế nào? Vì chúng ta cần giá trị chứ ko cần event. Trái ngược với toán tử trên thì  dematerialize sẽ biến đổi các event và tách ra các element.

/* - Dùng filter để lọc đi các event là error
  - dematerialize chuyển đổi các giá trị là event .next thành các element
 -  subscribe như bình thường
 */
// Vừa nhận được giá trị, vừa có thể bắt được error

//MARK: - Kết :
/// toArray đưa tất cả phần tử được phát ra của Observavle thành 1 array. Bạn sẽ nhận được array đó khi Observable kia kết thúc.
/// map toán tử huyền thoại với mục đích duy nhất là biến đổi kiểu dữ liệu này thành kiểu dữ liệu khác.
/// flatMap làm phẳng các Observables thành 1 Observable duy nhất. Và các phần tử nhận được là các phần tử từ tất cả các Observables kia phát ra. Không phân biệt thứ tự đăng ký.
/// flatMapLatest tương tư cái flatMap thôi. Nhưng điểm khác biệt ở chỗ chỉ nhận giá trị được phát đi của Observable cuối cùng tham gia vào.
/// materialize thay vì nhận giá trị được phát đi. Nó biến đổi các events thành giá trị để phát đi. Lúc này, error hay completed thì cũng là 1 giá trị mà thôi.
/// dematerialize thì ngược lại materialize. Giải nén các giá trị là events để lấy giá trị thật sự trong đó.
