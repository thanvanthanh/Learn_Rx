import UIKit
import RxSwift
import RxCocoa

/* Relay là thành phần mới được thêm vào RxSwift. Đi kèm với đó là khai tử đi Variable , một trong nhưng Class sử dụng rất nhiều trong các project với RxSwift.
 
 Thứ nhất, Relay là một wraps cho một subject. Tuy nhiên, nó không giống như các subject hay các observable chung chung. Ở một số đặc điểm sau:

 Không có hàm .onNext(_:) để phát đi dữ liệu
 Dữ liệu được phát đi bằng cách sử dụng hàm .accept(_:)
 Chúng sẽ không bao giờ .error hay .completed
 Thứ hai, nó sẽ liên quan tới 2 Subject khác. Do đó, ta có 2 loại Relay

 PublishRelay đó là warp của PublishSubject. Relay này mang đặc tính của PublishSubject
 BehaviorRelay đó là warp của BehaviorSubject. Nó sẽ mang các đặc tính của subject này
 Đúng là không có gì mới, ngoại trừ cái tên được thay thế thôi. Chúng ta sẽ đi vào ví dụ cụ thể cho từng trường hợp nào. */

// MARK: - tạo một Publish Relay & túi rác quốc dân.
let bag = DisposeBag()

enum MyError: Error {
    case anError
}

let publishRelay = PublishRelay<String>()

// Tiếp theo, bạn sẽ tìm cách phát đi 1 giá trị bằng đối tượng Relay mới đó.
publishRelay.accept("0")
//Lần này, sẽ khác cách Subject emit dữ liệu đi. Bạn sử dụng .accept thay cho .onNext truyền thống. Chỉ là một chút thay đổi nhỏ thôi và cũng không có gì khó hết.

//Subscribe
publishRelay
    .subscribe {  print("🔵 ", $0) }
    .disposed(by: bag)

publishRelay.accept("1")
publishRelay.accept("2")
publishRelay.accept("3")

publishRelay
    .subscribe { print("🔴 ", $0) }
    .disposed(by: bag)
publishRelay.accept("4")
// function .subcribe() để đăng ký tới 1 Relay. Trong ví dụ này, subscriber sẽ nhận được các giá trị mới sau khi nó đăng ký. Còn subscribe2, chỉ nhận được giá trị 4 thôi.

// MARK: - Terminate
// Bạn không thể kết thúc Relay được, vì chúng không hề phát đi error hay completed.  Việc phát đi error & completed thì đều bị trình biên dịch ngăn cản.
//publishRelay.accept(MyError.anError)
//publishRelay.onCompleted()

// MARK: - BehaviorRelays

let behaviorRelay = BehaviorRelay<String>(value: "0")
// Class tạo ra 1 Relay này là BehaviorRelay. Tất nhiên, bạn phải cung cấp một giá trị cho value để làm giá trị khởi tạo ban đầu cho Relay này.
behaviorRelay.accept("0")
//Vẫn tương tự như Publish Relay. Sử dụng function .accept() để phát dữ liệu đi.

// Subscribe 1
behaviorRelay
    .subscribe { print("🔵 ", $0) }
    .disposed(by: bag)
behaviorRelay.accept("1")
behaviorRelay.accept("2")
behaviorRelay.accept("3")

// subscribe 2

behaviorRelay.subscribe { print("🔴 ", $0) }
    .disposed(by: bag)
behaviorRelay.accept("4")

// Nhìn qua, nó cũng không khác các Observables & Subject. Và nó tuân theo đặc tính của Behavior Subject, sẽ luôn nhận được giá trị mới nhất khi có 1 Subscriber mới đăng ký tới.
// MARK: - value
// Một điều đặc biệt của Behavior Relay là bạn có thể lấy được giá trị hiện tại được lưu trữ trong Relay. Cách lấy như sau:
print("Current value: \(behaviorRelay.value)")
// Với toán tử .value của Relay, thì bạn có thể truy cập ngay và sử dụng được nó. Tuy nhiên nó là read-only mà thôi.


// MARK: - Kết :
// Relay là wrap một subject
// Đặc điểm
// Không có .onNext, .onError và .onCompleted
// Phát giá trị đi bằng .accpet(_:)
// Không bao giờ kết thúc
// Các class của Relay sẽ có các đặc tính của class mà nó wrap lại.
// PublishRelay là wrap của PublishSubject
// BehaviorRelay là wrap của BehaviorSubject

