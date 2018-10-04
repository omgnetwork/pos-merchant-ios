//
//  Extension.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt
import OmiseGO

func dispatchMain(_ block: @escaping EmptyClosure) {
    DispatchQueue.main.async { block() }
}

func dispatchGlobal(_ block: @escaping EmptyClosure) {
    DispatchQueue.global().async { block() }
}

func dispatchMain(afterMilliseconds: Int, _ block: @escaping EmptyClosure) {
    let deadlineTime = DispatchTime.now() + .milliseconds(afterMilliseconds)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime) { block() }
}

extension UIColor {
    static func color(fromHexString: String, alpha: CGFloat? = 1.0) -> UIColor {
        let hexint = Int(colorInteger(fromHexString: fromHexString))
        let red = CGFloat((hexint & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xFF) >> 0) / 255.0
        let alpha = alpha!
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)

        return color
    }

    private static func colorInteger(fromHexString: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: fromHexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)

        return hexInt
    }
}

extension String {
    func isValidEmailAddress() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                                             options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil
    }

    func isValidPassword() -> Bool {
        return self.count >= 8
    }

    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func trunc(length: Int, trailing: String = "") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}

extension UITableView {
    public func registerNib(tableViewCell: UITableViewCell.Type) {
        self.register(UINib(nibName: String(describing: tableViewCell), bundle: nil),
                      forCellReuseIdentifier: String(describing: tableViewCell))
    }
}

extension UITableViewCell {
    class func identifier() -> String {
        return String(describing: self)
    }
}

extension Date {
    func toString(withFormat format: String? = "dd MMM yyyy HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}

extension UIView {
    func addBorder(withColor color: UIColor, width: CGFloat, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    class func fromNib() -> Self {
        return self.fromNib(nibName: nil)
    }

    class func fromNib(nibName: String?) -> Self {
        func fromNibHelper<T>(nibName: String?) -> T where T: UIView {
            let bundle = Bundle(for: T.self)
            let name = nibName ?? String(describing: T.self)
            return bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T ?? T()
        }
        return fromNibHelper(nibName: nibName)
    }
}
