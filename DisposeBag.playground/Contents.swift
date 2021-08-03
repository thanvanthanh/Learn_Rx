import UIKit
import RxCocoa
import RxSwift

public func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}

// MARK: DisposeBag (Túi rác quốc dân) dùng để quản lý bộ nhớ  , đây cũng là một cách nhanh nhất để kết thúc một đăng ký mà không cần đợi nguồn phát đi Error hay Completed

let bag = DisposeBag()

    Observable<String>.of("A" , "B" , "C" , "D" , "E")
    .subscribe{ event in
        print(event)
    }
    .disposed(by: bag)
 /// tất cả sẽ được disposeBag quản lý và thủ tiêu
 /// Áp dụng trong project , khai báo 1 disposeBag là biến toàn cục . Khi đó chỉ cần ném tất cả các Subscription hoặc các observable vào đí , bộ nhớ sẽ không ảnh hưởng


example(of: "deferred") {
  let disposeBag = DisposeBag()
  
  // 1
  var flip = false
  
  // 2
  let factory: Observable<Int> = Observable.deferred {
    
    // 3
    flip.toggle()
    
    // 4
    if flip {
      return Observable.of(1, 2, 3)
    } else {
      return Observable.of(4, 5, 6)
    }
  }
    for _ in 0...3{
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
        .disposed(by: disposeBag)
    }
}


    
