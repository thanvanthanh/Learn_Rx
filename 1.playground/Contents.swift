import UIKit
import RxSwift
import RxCocoa

let hello = Observable.just("Hello Rx") // hello là 1 biến kiểu observable
///Observable này là nguồn phát dữ liệu , trong vd dữ liệu phát ra là kiểu String
/// just : là ám chỉ việc Observable này đc tạo ra và phát 1 lần duy nhất, sau đó kết thúc

hello.subscribe { value in
    print(value)
} /// để lăng nghe những gì mà hello phát ra cần phải subscribe tới nó.
/// cần cung cấp 1 closure để xử lý các giá trị nhận được từ nguồn phát
/// sau khi nguồn phát ra "Hello Rx" , nguồn sẽ tiếp tục phát tín hiệu kết thúc "completed"


