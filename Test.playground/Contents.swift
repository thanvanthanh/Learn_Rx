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


let bag  = DisposeBag()
let nums = [5, 6,8,7,9,10,12]
let numb = 6
let num = Observable.of([nums, numb])
num.asMaybe()
    .subscribe(onSuccess: { element in
        print("Completed with element \(element)")
    }, onError: { error in
        print("complete with an error \(error.localizedDescription)")
    }, onCompleted: {
        print("Completed with no element")
    })
    .disposed(by: bag)

