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

let helloSequence = Observable.just("Hello Rx")

let subscriptions = helloSequence.subscribe { event in
    print(event)
}

/* Observable sequences có thể phát ra không hoặc nhiều event trong vòng đời của nó Trong Rxswift một Event như một Enumeration Type (Nôm na là danh sách các trường hợp )có với 3 trạng thái
 
 .next(value: T) — xảy ra khi một hay một tập hợp các giá trị được bổ sung thêm vào Observable sequences, nó sẽ gửi next event cho các subscribers đã đăng ký ở ví dụ trên.

 .error(error: Error) — Nếu gặp phải Error một chuỗi sẽ phát ra sự kiện lỗi , và sẽ kết thúc Observable sequences

 .completed — Nếu một chuỗi kết thúc nó sẽ gửi event hoàn thành gửi đến cho các subscribers
 */
