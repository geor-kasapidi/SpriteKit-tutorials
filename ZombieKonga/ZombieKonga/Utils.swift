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

func * (a: Vector, b: Vector) -> Vector {
    return Vector(x: a.x * b.x, y: a.y * b.y)
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

// *******************************************************

let π = CGFloat.pi
let ππ = 2 * π

final class GeometryUtils {
    private init() {}

    static func shortestAngle(between angle1: CGFloat, and angle2: CGFloat) -> CGFloat {
        var angle = (angle2 - angle1).truncatingRemainder(dividingBy: ππ)

        if angle >= π { angle -= ππ }
        if angle <= -π { angle += ππ }

        return angle
    }
}

extension CGFloat {
    func sign() -> CGFloat {
        return self < 0 ? -1 : 1
    }
}

// *******************************************************

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }

    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)

        return random() * (max - min) + min
    }
}

// *******************************************************
