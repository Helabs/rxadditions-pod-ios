import Foundation
import RxSwift
import RxCocoa

private struct ActivityToken<E>: ObservableConvertibleType, Disposable {

    private let _source: Observable<E>
    private let _dispose: Cancelable

    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }

    func dispose() {
        _dispose.dispose()
    }

    func asObservable() -> Observable<E> {
        return _source
    }

}

/**
 Enables monitoring of sequence computation.
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
class ActivityTracking: SharedSequenceConvertibleType {

    //swiftlint:disable type_name
    typealias E = Bool
    //swiftlint:enable type_name
    typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _variable = Variable(0)
    private let _loading: SharedSequence<SharingStrategy, Bool>

    init() {
        _loading = _variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { tracked in
            return tracked.asObservable()
        }
    }

    private func increment() {
        _lock.lock()
        _variable.value += 1
        _lock.unlock()
    }

    private func decrement() {
        _lock.lock()
        _variable.value -= 1
        _lock.unlock()
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _loading
    }

}

extension ObservableConvertibleType {

    func trackActivity(_ activityIndicator: ActivityTracking) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }

}
