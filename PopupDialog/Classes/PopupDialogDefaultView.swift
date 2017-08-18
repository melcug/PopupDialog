//
//  PopupDialogView.swift
//
//  Copyright (c) 2016 Orderella Ltd. (http://orderella.co.uk)
//  Author - Martin Wildfeuer (http://www.mwfire.de)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

extension UIView {
	func borders(for edges:[UIRectEdge], width:CGFloat = 1, padding:CGFloat = 0, color: UIColor = .black) {
		
		if edges.contains(.all) {
			layer.borderWidth = width
			layer.borderColor = color.cgColor
		} else {
			let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
			
			for edge in allSpecificBorders {
				if let v = viewWithTag(Int(edge.rawValue)) {
					v.removeFromSuperview()
				}
				
				if edges.contains(edge) {
					let v = UIView()
					v.tag = Int(edge.rawValue)
					v.backgroundColor = color
					v.translatesAutoresizingMaskIntoConstraints = false
					addSubview(v)
					
					var horizontalVisualFormat = "H:"
					var verticalVisualFormat = "V:"
					
					switch edge {
					case UIRectEdge.bottom:
						horizontalVisualFormat += "|-(0)-[v]-(0)-|"
						verticalVisualFormat += "[v(\(width))]-(\(padding))-|"
					case UIRectEdge.top:
						horizontalVisualFormat += "|-(0)-[v]-(0)-|"
						verticalVisualFormat += "|-(\(padding))-[v(\(width))]"
					case UIRectEdge.left:
						horizontalVisualFormat += "|-(\(padding))-[v(\(width))]"
						verticalVisualFormat += "|-(0)-[v]-(0)-|"
					case UIRectEdge.right:
						horizontalVisualFormat += "[v(\(width))]-(\(padding))-|"
						verticalVisualFormat += "|-(0)-[v]-(0)-|"
					default:
						break
					}
					
					self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
					self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
				}
			}
		}
	}
}

/// The main view of the popup dialog
final public class PopupDialogDefaultView: UIView {

    // MARK: - Appearance

    /// The font and size of the title label
    public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }

	internal var titlePadding: CGFloat = 12
	
    /// The color of the title label
    public dynamic var titleColor: UIColor? {
        get { return titleLabel.textColor }
		set {
			titleLabel.textColor = newValue
			titlePadding = 12
		}
    }

	/// The color of the title label
	public dynamic var titleUnderlineColor: UIColor? {
		get { return titleLabel.textColor }
		set {
			titleLabel.borders(for: [.bottom], width: 1, padding: -8, color: newValue ?? UIColor.black)
			titlePadding = 15
		}
	}
	
    /// The text alignment of the title label
    public dynamic var titleTextAlignment: NSTextAlignment {
        get { return titleLabel.textAlignment }
        set { titleLabel.textAlignment = newValue }
    }

    /// The font and size of the body label
    public dynamic var messageFont: UIFont {
        get { return messageLabel.font }
        set { messageLabel.font = newValue }
    }

    /// The color of the message label
    public dynamic var messageColor: UIColor? {
        get { return messageLabel.textColor }
        set { messageLabel.textColor = newValue}
    }

    /// The text alignment of the message label
    public dynamic var messageTextAlignment: NSTextAlignment {
        get { return messageLabel.textAlignment }
        set { messageLabel.textAlignment = newValue }
    }

    // MARK: - Views

    /// The view that will contain the image, if set
    internal lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    /// The title label of the dialog
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(white: 0.4, alpha: 1)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return titleLabel
    }()

    /// The message label of the dialog
    internal lazy var messageLabel: UILabel = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor(white: 0.6, alpha: 1)
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        return messageLabel
    }()
    
    /// The height constraint of the image view, 0 by default
    internal var imageHeightConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    internal func setupViews() {

        // Self setup
        translatesAutoresizingMaskIntoConstraints = false

        // Add views
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)

        // Layout views
        let views = ["imageView": imageView, "titleLabel": titleLabel, "messageLabel": messageLabel] as [String : Any]
        var constraints = [NSLayoutConstraint]()

        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==0@900)-[titleLabel]-(==0@900)-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==10@900)-[messageLabel]-(==10@900)-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]-(==10@900)-[titleLabel]-(==\(titlePadding)@900)-[messageLabel]-(==10@900)-|", options: [], metrics: nil, views: views)
        
        // ImageView height constraint
        imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0, constant: 0)
        constraints.append(imageHeightConstraint!)

        // Activate constraints
        NSLayoutConstraint.activate(constraints)
    }
}
