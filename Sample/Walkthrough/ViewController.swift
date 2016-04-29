import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        walkthrough()
    }
    
    // MARK: -
    @IBAction func onRereshPressed(sender: AnyObject) {
        walkthroughState = 0
        walkthrough()
    }
    
    func onTap(gesture: UITapGestureRecognizer) {
        walkthroughState += 1
        walkthrough()
    }
    
    // MARK: - Private
    
    private var walkthroughState = 0
    private var walkthroughView: WalkthroughView!
    
    private func walkthrough() {
        if walkthroughView == nil {
            guard let window = UIApplication.sharedApplication().keyWindow else { return }
            let w = WalkthroughView(frame: window.frame)
            w.show(window)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.onTap(_:)))
            w.addGestureRecognizer(tap)
            
            walkthroughView = w
        }
        
        let view: UIView
        let caption: String
        
        switch walkthroughState {
        case 0:
            view = navigationItem.leftBarButtonItem?.valueForKey("view") as! UIView
            caption = "This is for menu as you read. This works better than three lines thingy."
        case 1:
            view = navigationItem.rightBarButtonItem?.valueForKey("view") as! UIView
            caption = "Believe it or not, this magnifier is for Search.  Surprising, isn't it?"
        case 2:
            view = toolbarItems?[0].valueForKey("view") as! UIView
            caption = "Take pictures or it never happened. Fact."
        case 3:
            view = toolbarItems?[2].valueForKey("view") as! UIView
            caption = "Or you can write it down as detail as possible. Good luck with that."
        case 4:
            view = toolbarItems?[4].valueForKey("view") as! UIView
            caption = "Yes, you can walk this through again. \nWhy not?"
        default:
            walkthroughView.hide()
            walkthroughView = nil
            return
        }
        
        var rect = view.convertRect(view.bounds, toView: walkthroughView)
        if rect.width > rect.height {
            rect.origin.x -= rect.size.width / 4
            rect.size.width *= 1.5
            rect.origin.y -= (rect.width - rect.height) / 2
            rect.size.height = rect.width
        } else {
            rect.origin.y -= rect.size.height / 4
            rect.size.height *= 1.5
            rect.origin.x -= (rect.height - rect.width) / 2
            rect.size.width = rect.height
        }
        
        walkthroughView.setSpotlightRect(rect, duration: 0.4)
        walkthroughView.caption = caption
    }
}

class WalkthroughView: SpotlightView {
    
    var caption: String = "" {
        didSet {
            if let l = subviews.first as? UILabel {
                UIView.animateWithDuration(0.4, animations: {
                    l.alpha = 0
                }) { finished in
                    l.removeFromSuperview()
                }
            }
            
            let l = addLabel()
            l.text = caption
            UIView.animateWithDuration(0.4) {
                l.alpha = 1
            }
        }
    }
    
    func show(parent: UIView) {
        alpha = 0
        parent.addSubview(self)
        UIView.animateWithDuration(0.25) {
            self.alpha = 1
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.25, animations: {
            self.alpha = 0
        }) { finished in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Private
    
    private func addLabel() -> UILabel {
        let l = UILabel()
        l.alpha = 0
        l.numberOfLines = 0
        l.textColor = UIColor.whiteColor()
        l.font = UIFont.systemFontOfSize(28, weight: UIFontWeightThin)
        l.translatesAutoresizingMaskIntoConstraints = false
        addSubview(l)
        
        l.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        l.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        l.leadingAnchor.constraintGreaterThanOrEqualToAnchor(leadingAnchor, constant: 40).active = true
        return l
    }
}
