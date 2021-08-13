import UIKit
import RxSwift
import RxCocoa

let bag = DisposeBag()
// MARK: - Element at : Sẽ lấy một phần tử nằm ở một vị trí xác định trong chuỗi mà bạn muốn nhận được và bỏ qua
let observable1 = Observable.of(1,2,3)

observable1.elementAt(2)
    .subscribe(onNext: { (event) in
        print("event: \(event)")
    }).disposed(by: bag)
// kq: 3

// MARK: - Filter : Chỉ phát ra những phần tử thoả mãn điều kiện
let observable2 = Observable.of(1,2,3,4,5,6)

observable2.filter { $0 % 2 == 0 }
    .subscribe(onNext: { (event) in
        print("event \(event)")
    }).disposed(by: bag)

// kq : 2,4,6

// MARK: - Skipping operators : Cho phép bỏ qua phần tử khi truyền vào 1 prametter
let observable3 = Observable.of("A" , "B" , "C" , "D", "E" , "F")
observable3.skip(1).subscribe{ (event) in
        print(event)
    }.disposed(by: bag)

// MARK: - Take : Phát ra phần tử đầu tiên thứ n trong chuỗi n-> là parmater truyền vào take ()

Observable.of(1,2,3,4,5).take(2).subscribe{ (event) in
    print(event)
}.disposed(by: bag)
// kq : 1 ,2

// MARK: - Take while : Đối chiếu nhiều item đuợc phát ra bởi môt Observable cho đến khi một điều kiện cụ thể false , Take while sẽ đối chiếu nguồn Observable cho đến khi điều kiện false thì TakeWhile dừng việc đối chiếu nguồn Observable và kết thúc Observable

Observable.of(2,4,6,7,5,8,10).takeWhile {
return $0 % 2 == 0
}.subscribe(onNext: { (event) in
    print(event)
}).disposed(by: bag)
// kq : 2 , 4 , 6

// MARK: - Take until : Loại bỏ bất kỳ items nào được phát ra bởi một Observable sau 1 giây Observable phát ra 1 item hoặc kết thúc

let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()
subject.takeUntil(trigger).subscribe(onNext: { (event) in
    print(event)
}).disposed(by: bag)

subject.onNext("event 1")
trigger.onNext("X")

subject.onNext("event 2")

trigger.onNext("event 3")
// kq : 1
