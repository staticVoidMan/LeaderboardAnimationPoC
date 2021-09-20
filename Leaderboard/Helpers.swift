//
//  Helpers.swift
//  Leaderboard
//
//  Created by Amin
//

import Foundation
import UIKit

let brandColor: UIColor = .blue

var profilePlaceholderImage: UIImage {
    UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))!
}

extension Int {
    var withSeparators: String { Int.withSeparators(self) }
    
    static func withSeparators(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: value))
        return formatted ?? String(value)
    }
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}

extension UISegmentedControl {
    
    func applyiOS12Style() {
        if #available(iOS 13, *) {
            let tintColorImage = UIImage(color: tintColor)
            // Must set the background image for normal to something (even clear) else the rest won't work
            setBackgroundImage(UIImage(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            setBackgroundImage(UIImage(color: tintColor.withAlphaComponent(0.2)), for: .highlighted, barMetrics: .default)
            setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor
        }
    }
    
}

extension UIViewController {
    
    func embed(_ child: UIViewController, inside someView: UIView? = nil) {
        guard self.children.contains(child) == false else { return }
        
        if let someView = someView,
           self.view.subviews.contains(someView) == false {
            fatalError("Child can't be added inside a specified view that is not itself a subview of the parent")
        }
        
        let containerView = someView ?? self.view!
        containerView.addSubview(child.view)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint
            .activate([child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                       child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                       child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                       child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
        
        self.addChild(child)
        child.didMove(toParent: self)
    }
    
    func removeChild(_ child: UIViewController) {
        guard self.children.contains(child) else { return }
        
        child.willMove(toParent: nil)
        child.removeFromParent()
        
        child.view.removeFromSuperview()
    }
    
}

extension UIView {
    
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
    }
    
}
