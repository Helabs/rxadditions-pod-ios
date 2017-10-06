import RxSwift
import RxCocoa

protocol RxAlertActionType {
    associatedtype Result

    var title: String? { get }
    var style: UIAlertActionStyle { get }
    var result: Result { get }
}

struct RxAlertAction<R>: RxAlertActionType {
    typealias Result = R

    let title: String?
    let style: UIAlertActionStyle
    let result: R
}

struct RxDefaultAlertAction: RxAlertActionType {
    typealias Result = RxAlertControllerResult

    let title: String?
    let style: UIAlertActionStyle
    let result: Result
}

enum RxAlertControllerResult {
    case action
    case customAction(identifier: String)
    case cancel
}

extension Reactive where Base: UIAlertController {

    static func presentAlert<Action: RxAlertActionType, Result>(viewController: UIViewController, title: String?, message: String?, preferredStyle: UIAlertControllerStyle = .alert, animated: Bool = true, actions: [Action]) -> Observable<Result> where Action.Result == Result {
        return Observable.create { observer -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

            actions.map { rxAction in
                UIAlertAction(title: rxAction.title, style: rxAction.style, handler: { _ in
                    observer.on(.next(rxAction.result))
                    observer.on(.completed)
                })
            }.forEach(alertController.addAction)

            viewController.present(alertController, animated: animated, completion: nil)

            return Disposables.create {
                dismissViewController(alertController, animated: true)
            }
        }
    }

}

fileprivate func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }

        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}
