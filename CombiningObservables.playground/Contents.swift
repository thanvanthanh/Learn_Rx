import UIKit
import RxSwift
import RxCocoa

let bag = DisposeBag()

// MARK: - Merger : cho phép kết hợp nhiều Obseravble bằng cách gộp cái emit lại với nhau
// Bạn có thể kết hơp nhiều output của nhiều Obseravble thành một Obseravble khi sử dụng Merger operator
// .merge() complete chỉ khi tất cả các Inner Sequence và source Observable đều complete.
// Các Inner Sequence hoạt động đọc lập không liên quan với nhau.

//Nếu bết kỳ Inner Sequence nào emit Error thì Source Observable ngay lập tức emit ra Error và terminate.

let left = PublishSubject<Int>()
let right = PublishSubject<Int>()

//let soucre = Observable.of(left.asObserver(), right.asObserver())
//let obserable = soucre.merge()
//obserable.subscribe(onNext: { event in
//    print(event)
//}, onError: nil , onCompleted: nil )
//
//left.onNext(1)
//right.onNext(4)
//left.onNext(2)
//left.onNext(3)
//
//right.onNext(5)
//right.onNext(6)

// MARK: - Concat :  tương tư như hoạt động của merge() sự khác nhau nằm ở chỗ concat sẽ đợi các luồng trước kết thúc trước rồi đến các luồng sau, còn merger() thì bạn có thể thay thế output
// Lưu ý : chỉ có thể nối các chuỗi có cùng kiểu dữ liệu với nhau, nếu nối khác kiểu sẽ báo lỗi

let obserable2 = Observable.concat([left, right])

obserable2.subscribe(onNext: { event in
    print(event)
}, onError: nil, onCompleted: nil )
.disposed(by: bag)

left.onNext(1)
right.onNext(4)
left.onNext(2)
left.onNext(3)
right.onNext(6)
/// Lý do 4 không chạy vì luồng left chưa kết thúc nên 4 sẽ không được hiển thị


// MARK: - Start with : được sử dụng khi ta muốn phát sinh sự kiện với một tập giá trị nào đó, sau đó mới phát sinh các tập giá trị được định nghĩa trong Observable.
    
func startWith(){
    let number = Observable.of(4,5,6)
    let obserable = number.startWith(1,2,3)
    obserable.subscribe(onNext: { (event) in
        print("event: \(event)")
    },onError: nil , onCompleted:  nil).dispose()
}
//print(startWith())
//Kết quả lúc này sẽ là : 1,2,3,4,5,6,7



// MARK: - map : Rxswift map hoạt động tương tự thư viện chuẩn của swift điểm khác biệt là nó hoạt động trong một observables hép biến đổi Map cho phép ta thực hiện biến đổi ứng với từng phần tử trong Observable Sequence trước khi gửi tới Subscribe

let obserable1 = Observable.of(1,2,3)

obserable1.map {
    return $0 * 2
}.subscribe(onNext: { event in
    print("event: \(event)")
}).disposed(by: bag)
// Kết quả sẽ là 2,4,6

// MARK: - flat map : Đinh nghĩa flatMap biến đổi các thành phần phát ra bởi một Observable trong thành nhiểu Observable sau đó gộp lại thành một Observable duy nhất
struct Player {
    var score:BehaviorRelay<Int>
}

let thanh = Player(score: BehaviorRelay(value: 50))

let player = PublishSubject<Player>()

player.asObserver().flatMap { $0.score.asObservable() }
    .subscribe(onNext: { event in
        print("event \(event)")
    }).disposed(by: bag)
player.onNext(thanh)
// KQ : event 50

// MARK: - flatMapLatest : Sự khác biệt giữa flatMap và flatMapLatest là nó huỷ trước khi subscription khi subscription xảy ra
let outerObservable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance).take(2)
let combineObservable = outerObservable.flatMapLatest { value in
    return Observable<NSInteger>.interval(0.3, scheduler: MainScheduler.instance).take(3).map { inerValue in
        print("Outer value :\(value) Iner Value :\(inerValue)")
    }
}
combineObservable.subscribe(onNext: { event in
    print("event \(event)")
}, onError: nil, onCompleted: nil )
.disposed(by: bag)
//Kết quả sẽ là : Outer value 0 Iner Value 0 event () Outer value 1 Iner Value 0 event () Outer value 1 Iner Value 1 event () Outer value 1 Iner Value 2 event ()




