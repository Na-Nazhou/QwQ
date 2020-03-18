//
//  SegmentedControl.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class SegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    var items: [String] = ["Active", "History"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    var selectedLabelColor: UIColor = .black {
        didSet {
            setSelectedColors()
        }
    }
    
    var unselectedLabelColor: UIColor = .white {
        didSet {
            setSelectedColors()
        }
    }
    
    var thumbColor: UIColor = .white {
        didSet {
            setSelectedColors()
        }
    }
    
    var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var font: UIFont! = UIFont.systemFont(ofSize: 12) {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        layer.borderWidth = 2
        
        backgroundColor = .clear
        
        setupLabels()
        
        addIndividualItemConstraints(items: labels, mainView: self, padding: 0)
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = UIFont(name: "Comfortaa-Regular", size: 15)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(items: labels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        displayNewSelectedIndex()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        var calculatedIndex: Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex() {
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.thumbView.frame = label.frame
        }, completion: nil)
    }
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        for (index, button) in items.enumerated() {
            let topConstraint = NSLayoutConstraint(item: button,
                                                   attribute: NSLayoutConstraint.Attribute.top,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: mainView, attribute: NSLayoutConstraint.Attribute.top,
                                                   multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button,
                                                      attribute: NSLayoutConstraint.Attribute.bottom,
                                                      relatedBy: NSLayoutConstraint.Relation.equal,
                                                      toItem: mainView, attribute: NSLayoutConstraint.Attribute.bottom,
                                                      multiplier: 1.0,
                                                      constant: 0)

            var rightConstraint: NSLayoutConstraint!
            
            if index == items.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button,
                                                     attribute: NSLayoutConstraint.Attribute.right,
                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                     toItem: mainView, attribute: NSLayoutConstraint.Attribute.right,
                                                     multiplier: 1.0,
                                                     constant: -padding)
            } else {
                let nextButton = items[index + 1]
                rightConstraint = NSLayoutConstraint(item: button,
                                                     attribute: NSLayoutConstraint.Attribute.right,
                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                     toItem: nextButton, attribute: NSLayoutConstraint.Attribute.left,
                                                     multiplier: 1.0,
                                                     constant: -padding)
            }
            
            var leftConstraint: NSLayoutConstraint!
            
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: mainView,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    multiplier: 1.0,
                                                    constant: padding)
            } else {
                let prevButton = items[index - 1]
                leftConstraint = NSLayoutConstraint(item: button,
                                                    attribute: NSLayoutConstraint.Attribute.left,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: prevButton,
                                                    attribute: NSLayoutConstraint.Attribute.right,
                                                    multiplier: 1.0,
                                                    constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button,
                                                         attribute: .width,
                                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                                         toItem: firstItem,
                                                         attribute: .width,
                                                         multiplier: 1.0,
                                                         constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors() {
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.isEmpty {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    func setFont() {
        for item in labels {
            item.font = font
        }
    }
}
