import Foundation
import CoreGraphics

typealias Vector = CGPoint

// *******************************************************

func + (a: Vector, b: CGFloat) -> Vector {
    return Vector(x: a.x + b, y: a.y + b)
}

func - (a: Vector, b: CGFloat) -> Vector {
    return Vector(x: a.x - b, y: a.y - b)
}

func * (a: Vector, b: CGFloat) -> Vector {
    return Vector(x: a.x * b, y: a.y * b)
}

func / (a: Vector, b: CGFloat) -> Vector {
    return Vector(x: a.x / b, y: a.y / b)
}

// *******************************************************

func + (a: Vector, b: Vector) -> Vector {
    return Vector(x: a.x + b.x, y: a.y + b.y)
}

func - (a: Vector, b: Vector) -> Vector {
    return Vector(x: a.x - b.x, y: a.y - b.y)
}

// *******************************************************

extension Vector {
    var length: CGFloat {
        return (x * x + y * y).squareRoot()
    }

    func normalize() -> Vector {
        return self / length
    }

    var angle: CGFloat {
        return atan2(y, x)
    }
}
