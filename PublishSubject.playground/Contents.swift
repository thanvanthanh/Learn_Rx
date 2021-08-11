import UIKit
import RxSwift
import RxCocoa

let bag = DisposeBag()

let subject = PublishSubject<String>()
// Đối tượng subject thuộc class PublishSubject. Và cần phải cung cấp kiểu dữ liệu cho các phần tử được Subject phát đi. Trong ví dụ, nó là String.

subject.onNext("1")
// Với .onNext là toán tử giúp bạn emit dữ liệu đi. Bạn có thể emit bất cứ khi nào và bất cử ở đâu, mà không phụ thuộc vào dữ liệu ban đầu. Đây là ưu điểm mà Subject hơn Observable.


//Tạo 1 subject và phát dữ liệu đi rồi, phần tiếp theo là đăng ký tới Subject để nhận dữ liệu. Thêm đoạn code này vào sau cùng

// subscribe 1
let subcription1 = subject
    .subscribe(onNext: { value in
        print("Sub 1 :" , value)
    })
// Vẫn là function quen thuộc .subscribe(onNext: _) từ cái thời Observables. Nên cũng không có gì mới lạ tại đây. Bạn có thể thực thi đoạn code vừa hoàn thành thì sẽ thấy. subscription1 sẽ không nhận được gì. Nguyên nhân, là đã subscribe sau khi subject phát đi 1.
// emit
subject.onNext("2")

// subscribe 2
let subcription2 = subject
    .subscribe(onNext: { value in
        print("Sub 2 : ", value)
    },onCompleted: {
        print("Sub 1 : Completed")
    })
// emit
subject.onNext("3")
subject.onNext("4")
subject.onNext("5")

/// Giá trị 1 sẽ không nhận được, vì trước thời điểm phát đó, không có subscribe nào tới subject.
/// subscription1 sẽ nhận được giá trị 2, còn subscription2 sẽ không nhận được 2 vì đã subscribe sau khi phát 2.
/// Các giá trị liên tiếp sau thì cả 2 đều nhận được.

// dispose subcription2
subcription2.dispose()

subject.onNext("6")
subject.onNext("7")

//completed
subject.on(.completed)

// emit
subject.onNext("8")

// subscribe 3

subject .subscribe{
    print("sub 3 :", $0.element ?? $0)
}
.disposed(by: bag)
