import UIKit
import RxSwift
import RxCocoa

// MARK: - Về Transforming Operators, chúng nó là các nhóm toán tử được sử dụng để biến đổi dữ liệu phát ra từ Observable, nhằm phù hợp với các yêu cầu từ Subscriber.
let bag = DisposeBag()
// toArray :
Observable.of(1, 2, 3, 4, 5, 6)
    .toArray()
    .subscribe(onSuccess: { value in
        print(value)
    }) { error in
        print(error)
    }

///Thực thi code trên, bạn sẽ thấy giá trị nhận được là một Array Int. Điểm đặc biệt ở đây là với toán tử toArray thì nó sẽ biến đổi Observable đó về thành là 1 Single. Khi đó chỉ cho phép là  .onSuccess hoặc .error


// map :
/// Về toán tử map , nó thuộc hạng thần thánh nhất rồi. Xuất hiện nhiều ở nhiều ngôn ngữ và ý nghĩa không thay đổi. Khi sử dụng toán tử này thì có một số đặc điểm sau

///Biến đổi từ kiểu dữ liệu này thành kiểu dữ liệu khác cho các phần tử nhận được
/// Việc biến đổi được xử lý bằng một closure
///Sau khi biến đổi nếu bạn subscribe thì hãy chú ý tới kiểu dữ liệu mới đó, tránh bị nhầm lẫn.

let formatter = NumberFormatter()
formatter.numberStyle = .spellOut

Observable<Int>.of(1, 2, 3, 4, 5, 10, 999, 9999, 1000000)
    .map { formatter.string(for: $0) ?? "" }
    .subscribe(onNext: { string in
        print(string)
    })
    .disposed(by: bag)
///Đoạn code trên sẽ biến đổi các giá trị là Int thành String và hàm biến đổi được thực hiện dựa vào một đối tượng NumberFormatter dùng để đọc/phát âm các số đó


// toán tử enumerated kết hợp với map:

Observable<Int>.of(1, 2, 3, 4, 5)
    .enumerated()
    .map { index, integer in
        index > 2 ? integer * 2 : integer
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: bag)

/* Từ một Observable với Int là kiểu dữ liệu cho các phần tử được phát đi
 enumerated biến đổi Observable đó với kiểu dữ liệu giờ là 1 Tuple, do sự kết hợp thêm index từ nó
 Qua lại em toán tử map để tính toán và biến đổi nó về lại 1 Int
 subscribe thì như bình thường
 Đây là cách bạn lấy được index của các phần tử rồi sau đó biến chúng về lại kiểu giá trị ban đầu. */

//MARK: - Transforming inner observables:

struct User {
    let message: BehaviorSubject<String>
}

//flatMap :

/* Ta có 1 Observable gốc có kiểu dữ liệu cho các element của nó là 1 kiểu thuộc Observable
Vì các element có kiểu Observable ,thì nó có thể phát dữ liệu. Lúc này, chúng ta có rất nhiều stream phát đi
Muốn nhận được tất cả dữ liệu từ tất cả các element của Observable gốc, thì ta dùng toán tử flatMap
Chúng sẽ hợp thể tất cả các giá trị của các element đó phát đi thành 1 Observable ở đầu cuối. Mọi công việc subcirbe vẫn bình thường và ta không hề hay biết gì ở đây. */
let tom = User(message: BehaviorSubject(value: "hello, im Tom !"))
let merry = User(message: BehaviorSubject(value: "Hello, Im Min !"))

let subject = PublishSubject<User>()

subject.flatMap { $0.message }
    .subscribe(onNext: { msg in
        print(msg)
    }).disposed(by: bag)
//Ta sử dụng flatMap để biến đổi từ User về là String , vì kiểu dữ liệu phát đi của thuộc tính message là String. Tiếp theo tiến hành phát tín hiệu.
subject.onNext(tom)

tom.message.onNext("Is any body here")
tom.message.onNext("Are you alone?")
tom.message.onNext("So sad !")

subject.onNext(merry)
merry.message.onNext("Hi Tom, are you ok ?")

tom.message.onNext("Yeah ! Im ok !")

// Chu y:
/* Có 3 đối tượng luân phiên nhau phát dữ liệu
 subject đóng vài trò là Observable gốc, sẽ phát đi các dữ liệu là các Observable khác
 tom & merry sẽ phát đi mà String */

//MARK: - flatMapLastest :
print("_______flatmapLatest______")
 /* Về cơ bản là giống như flatMap về việc hợp nhất các Observable lại với nhau. Tuy nhiên, điểm khác là nó sẽ chỉ phát đi giá trị của Observable cuối cùng tham gia vào. Ví dụ
 
 Có 3 Observable là O1, O2 và O3 join vào lần lượt
 flatMapLatest sẽ biến đổi các Observable đó thành 1 Observable duy nhất
 Giá trị nhận được tại một thời điểm chính ta giá trị của phần tử cuối cùng join vào lúc đó */

subject.flatMapLatest { $0.message }
    .subscribe(onNext: { msg in
        print(msg)
    })
    .disposed(by: bag)

subject.onNext(tom)

tom.message.onNext("Tom: Có ai ở đây không?")
tom.message.onNext("Tom: Có một mình mình thôi à!")
tom.message.onNext("Tom: Buồn vậy!")
tom.message.onNext("Tom: ....")

// subject
subject.onNext(merry)

// merry
merry.message.onNext("Merry: Chào Tèo, bạn có khoẻ không?")

// tom
tom.message.onNext("Tèo: Chào Merry, mình khoẻ. Còn bạn thì sao?")

// merry
merry.message.onNext("Tom: Mình cũng khoẻ luôn")
merry.message.onNext("Tom: Mình đứng đây từ chiều nè")

// merry
tom.message.onNext("Merry: Kệ Tom. Ahihi")


