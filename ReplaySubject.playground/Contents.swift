import UIKit
import RxCocoa
import RxSwift

// MARK: - ReplaySubject :  Là khởi tạo với một kích thước bộ đệm lưu các phần tử gần nhất vào bộ nhớ đệm và sau đó phát lại các phần tử có trong bộ nhớ đệm cho subcriber mới

let replaysubject = ReplaySubject<String>.create(bufferSize: 2)

replaysubject.onNext("Issue #1")
replaysubject.onNext("Issue #2")
replaysubject.onNext("Issue #3")
replaysubject.onNext("Issue #5")
replaysubject.onNext("Issue #6")
replaysubject.onNext("Issue #7")

replaysubject.subscribe{ (event) in
    print("event: \(event)")
}
