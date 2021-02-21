import SDWebImage

public class ImageLoader {

    // MARK: - Properties.

    private var operation: SDWebImageOperation?

    // MARK: - Public.

    public func cancelRequest() {
        operation?.cancel()
    }

    public func fetchImage(from url: URL?, then completion: ((_ image: UIImage?) -> Void)?) {
        guard let url = url else {
            completion?(nil)
            return
        }

        operation = SDWebImageManager.shared.loadImage(with: url, options: .retryFailed, progress: nil) { (image, _, _, _, _, _) in
            completion?(image)
        }
    }
    
    public func prefetchImage(from url: URL?) {
        guard let url = url else {
            return
        }
        
        SDWebImagePrefetcher.shared.prefetchURLs([url])
    }

}
