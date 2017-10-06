import Foundation
import RxSwift
import RxCocoa
import PINRemoteImage

typealias ProcessorImageAdapter = (UIImage?) -> UIImage?

extension UIImageView {
    func applyBindableImage(_ image: BindableImage, withImageProcessor processor: [String: ProcessorImageAdapter]? = nil) {
        pin_updateWithProgress = true

        switch image {
        case .remote(let url, let placeholder):
            guard let url = url else { return }
            if let processor = processor, let key = processor.keys.first, let block = processor.values.first {
                pin_setImage(from: url, placeholderImage: placeholder, processorKey: key, processor: { (result, _) -> UIImage? in
                    return block(result.image)
                })
            }
            else {
                pin_setImage(from: url, placeholderImage: placeholder)
            }
        case .local(let image):
            self.image = image
        }
    }
}

extension Reactive where Base: UIImageView {

    var downloadableImage: UIBindingObserver<Base, BindableImage> {
        return downloadableImage(withImageProcessor: nil)
    }

    func downloadableImage(withImageProcessor processor: [String: ProcessorImageAdapter]?) -> UIBindingObserver<Base, BindableImage> {
        return UIBindingObserver(UIElement: base) { imageView, content in
            imageView.applyBindableImage(content, withImageProcessor: processor)
        }
    }

}
