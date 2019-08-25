import ImageService
import PostService
import UIKit

class ListingTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var subredditLabel: UILabel!
    @IBOutlet private var thumbnailImageView: NetworkImageView!

    @IBOutlet var feedbackLabel: UILabel!
    static var reuseIdentifier: String {
        return "ListingTableViewCell"
    }

    static var nib: UINib {
        return UINib(nibName: "ListingTableViewCell", bundle: nil)
    }
    
}

extension ListingTableViewCell: PostDisplayable {
    func display(_ post: Post) {
        configureTitleText(with: post)
        configureThumbnailImageView(with: post)
        configureSubredditLabel(with: post)
        configureBodyText(with: post)
        configureFeedbackLabel(with: post)
    }
}

private extension ListingTableViewCell {
    func configureTitleText(with post: Post) {
        titleLabel.text = post.title
    }

    func configureThumbnailImageView(with post: Post) {
        thumbnailImageView.isHidden = post.thumbnailURL == nil
        thumbnailImageView.url = post.thumbnailURL
    }

    func configureSubredditLabel(with post: Post) {
        guard let subredditName = post.subredditName  else {
            subredditLabel.isHidden = true
            return
        }

        subredditLabel.isHidden = subredditName.isEmpty
        subredditLabel.text = subredditName.strippedHtml
    }
    
    func configureFeedbackLabel(with post: Post) {
    
        let commentNet = CommentNet.shared
        if commentNet.predict(inputString: post.title) {
            feedbackLabel.text = "Feedback"
            feedbackLabel.textColor = .red
        }
        else {
            feedbackLabel.text = "Not Feedback"
            feedbackLabel.textColor = .red
        }
        
    }

    func configureBodyText(with post: Post) {
        guard let selfText = post.selfText  else {
            bodyLabel.isHidden = true
            return
        }

        bodyLabel.isHidden = selfText.isEmpty
        bodyLabel.text = selfText
    }
}
