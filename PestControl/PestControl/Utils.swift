import Foundation
import UIKit

public func - (a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: a.x - b.x, y: a.y - b.y)
}

public func * (a: CGPoint, b: CGFloat) -> CGPoint {
    return CGPoint(x: a.x * b, y: a.y * b)
}

public func / (a: CGPoint, b: CGPoint) -> CGPoint {
    return CGPoint(x: a.x / b.x, y: a.y / b.y)
}

public func / (a: CGPoint, b: CGFloat) -> CGPoint {
    return CGPoint(x: a.x / b, y: a.y / b)
}

extension CGPoint {
    public func length() -> CGFloat {
        return (x*x + y*y).squareRoot()
    }
    
    func normalized() -> CGPoint {
        let l = length()
        
        return l > 0 ? self / l : .zero
    }
}
