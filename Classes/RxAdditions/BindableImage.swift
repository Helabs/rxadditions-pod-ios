import UIKit

enum BindableImage {
    case remote(url: URL?, placeholder: UIImage?)
    case local(image: UIImage?)
}