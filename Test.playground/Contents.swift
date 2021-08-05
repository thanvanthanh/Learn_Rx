import UIKit
import RxSwift
import RxCocoa

let subject = PublishSubject<String>()

subject.onNext("hello")

let subjectOne = subject
    .subscribe(onNext: { value in
        print(value)
    })
subject.onNext("1")

func doActions() -> Observable<Void>{
    self.someAsynOperation {
        
    }
    return Observable.create()
}

