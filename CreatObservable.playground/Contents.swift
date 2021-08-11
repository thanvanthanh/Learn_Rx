import UIKit
import RxCocoa
import RxSwift

let bag = DisposeBag()

var flip = true
let factory = Observable<Int>.deferred {
    flip.toggle()
    
    if flip {
        return Observable.of(1)
    } else {
        return Observable.of(0)
    }
    
}

// bag là túi rác quốc dân
// flip là cờ lật qua lật lại
// Nếu flip == true thì trả về 1 Observable với giá trị phát đi là 1
// Ngược lại là 0
// Ở đây, mỗi lần return là 1 Observable mới. Tất nhiên, để làm được việc này, ta sử dụng toán tử .deferred để tạo ra 1 Observable, mà người ta gọi là Observable factories

//MARK: .deferred tạo ra 1 Observable nhưng sẽ trì hoãn nó lại. Và nó sẽ được return trong closure xử lí được gán kèm theo.


// Nhìn qua thì Observable factories cũng giống như các Observable bình thường khác. Bên ngoài, bạn sẽ không phân biệt được nó có gì khác lạ. Xem tiếp cách sử dụng của nó :
for _ in 0...10 {
    factory.subscribe(onNext: {
        print($0 , terminator: "")
    }).disposed(by: bag)
    print()
}

//  Kết quả: Lặp từ 0 đến 10, cứ mỗi bước in ra giá trị nhận được. Đây là cách đếm chẵn lẻ cao cấp bằng RxSwift


// create :  là cách linh hoạt nhất để tạo ra một Observable
// just : sẽ giúp bạn biến 1 giá trị thành 1 Observable. Ngoài ra, nó còn những người anh em thân thương của mình nữa. Với mỗi loại cho một nhiệm vụ đặc biệt.
// deferred : trì hoãn việc phát dữ liệu khi có 1 subscription tới. Giúp cho bạn có thời gian để xử lý dữ liệu trước khi gởi đi
