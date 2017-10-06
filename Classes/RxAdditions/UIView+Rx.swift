import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIView {

    public var backgroundColor: UIBindingObserver<Base, UIColor> {
        return UIBindingObserver(UIElement: self.base) { (view, value) in
            view.backgroundColor = value
        }
    }

}
