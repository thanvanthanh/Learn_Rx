import UIKit
import RxSwift
import RxCocoa

// Trait: là một wrapper struct với một thuộc tính là một Observable Sequence nằm bên trong nó. Trait có thể được coi như là một sự áp dụng của Builder Pattern cho Observable.
// Để chuyển Trait về thành Observable, chúng ta có thể sử dụng operator .asObservable()

// MARK: Tóm gọn, Traits sẽ chỉ thực hiện một nhiệm vụ cụ thể nào đó mà thôi.

//struct Single<Element> {
//    let source: Observable<Element>
//}
//
//struct Driver<Element> {
//    let source: Observable<Element>
//}
/// Nó không xảy ra lỗi.
/// Trait được observe và subscribe trên MainScheduler.
/// Trait không chia sẻ Side Effect. (một số loại khác sẽ có)

// MARK: Trait trong RxSwift có 3 loại :
/// - Single
/// - Completable
/// - Maybe
//------------------------------------------
// MARK: Single :

// Single: là một biến thể của Observable trong RxSwift.
// Thay vì emit được ra một chuỗi các element như Observable thì Single sẽ chỉ emit ra duy nhất một element hoặc một error.
// Không chia sẻ Side Effect.

enum FileError: Error {
    case pathError
    case failedCachang
}
let bag = DisposeBag()

func readFile(path: String?) ->Single<String> {
    return Single.create { single -> Disposable in
        if let patch = path {
            single(.success("Success!"))
        }else{
            single(.error(FileError.pathError))
        }
        return Disposables.create()
    }
}
// Ta tạo ra 1 enum cho error và 1 túi rác quốc dân. Sau đó, ta tạo tiếp function readFile với tham số path là 1 String Optional.
// Với path == nil thì trả về error
// Với path != nil thì trả về Success!
// Function readFile có giá trí trả về là 1 Single với kiểu Output là String. Vì Single cũng là 1 Observable, nên ta lại áp dụng toán tử .create để tạo. Và quan trọng là handle các thao tác trong đó (lúc nào là error hay giá trị ….)

readFile(path: nil)
    .subscribe { event in
        switch event {
        case .success(let value):
            print(value)
        case .error(let error):
            print(error)
        }
    }.disposed(by: bag)
// ta sẽ switch ... case được giá trị mà Single trả về. Với 2 trường hợp.

/// Có thể biến 1 Observable thành một Single bằng toán tử .asSingle().

// Tới đây, bạn đã thấy được ứng dụng RxSwift vào trong các Model gọi API rồi đó. Cách gọi hay hơn là các call back.
// --------------------------------------------------------------------------------------------------------

// MARK: Completable :

// Giống với Single, Completable cũng là một biến thể của Observable.
// Điểm khác biệt của Completable so với Single, đó là nó chỉ có thể emit ra một error hoặc chỉ complete (không emit ra event mà chỉ terminate).
// Không chia sẻ Side Effect.

func cacheLocaly() -> Completable {
    return Completable.create { completable in
        // Store some data locally
        
        let success = true
        
        guard success else {
            completable(.error(FileError.failedCachang))
            return Disposables.create()
        }
        completable(.completed)
        return Disposables.create()
    }
}
// Function cacheLocally trả về một kiểu Completable. Và áp dụng cách tương tự như Single, thì sử dụng .create để tạo một Observabe Completable và hành vi cho nó. Cách sử dụng cũng tương tự như trên.
cacheLocaly()
    .subscribe { completable in
        switch completable {
        case .completed :
            print("Completed with no error")
        case .error(let error) :
            print("Completed with an error : \(error)")
        }
    }
    .disposed(by: bag)

// Hoặc cụ thể cho khỏi nhập nhèn với onCompleted & onError.

cacheLocaly()
    .subscribe(onCompleted: {
        print("Completed with no error")
    }, onError: { error in
        print("Completed with an error: \(error)")
    })
    .disposed(by: bag)
//--------------------------------------------------------------------------------------------------------------

// MARK: Maybe :
 // Maybe :  cũng là một biến thể của Observable và là sự kết hợp giữa Single và Completable.
// Nó có thể emit một element, complete mà không emit ra element hoặc emit ra một error.

/// Đặc điểm của Maybe:
// Có thể phát ra duy nhất một element, phát ra một error hoặc cũng có thể không phát ra bất cứ event nào và chỉ complete.
// Sau khi thực hiện bất kỳ 1 trong 3 sự kiện nêu trên thì Maybe cũng sẽ terminate.
// Không chia sẻ Side Effect.

enum MyError: Error {
    case anError
}
func generateString() -> Maybe<String> {
    return Maybe<String>.create { maybe in
        maybe(.success("RxSwift"))
        // OR
        
        maybe(.completed)
        // OR
        
        maybe(.error(MyError.anError))
        
        return Disposables.create {}
    }
}
// Về Maybe , tương tự như 2 cái trên về cách tạo và xử lý. Nó có thể phát đi cái gì cũng đc, linh hoạt hơn. Dùng cho cách xử lý mà có thể trả không cần phát đi gì cả hoặc kết thúc.

/// Cách subscribe như sau:
generateString()
    .subscribe { maybe in
        switch maybe {
        case .success(let element):
            print("Completed with element \(element)")
        case .completed:
            print("Completed with no element")
        case .error(let error):
            print("Completed with an eror \(error.localizedDescription)")
        }
    }
    .disposed(by: bag)

/// Hoặc Fulloptions như sau :

generateString()
    .subscribe(onSuccess: { element in
        print("Completed with element \(element)")
    }, onError: { error in
        print("Completed with an error \(error.localizedDescription)")
    }, onCompleted: {
        print("Completed with no element")
    })
    .disposed(by: bag)

// Có thể dùng toán tử .asMayBe() để biến 1 Observable thành 1 Maybe.

// MARK: Note
// Traits trong RxSwift và RxCocoa có thể xem là các Observable đặc biệt. Chỉ đảm đương vài tính chất hoặc 1 tính chất nào đó
// Trong RxSwift thì bao gồm:
/// Single
/// Completable
/// Maybe

//Có thể chuyển đổi từ Observable sequence thành 1 Traits thông 2 toán tử sau:
// .asSingle()
// .asMaybe()
