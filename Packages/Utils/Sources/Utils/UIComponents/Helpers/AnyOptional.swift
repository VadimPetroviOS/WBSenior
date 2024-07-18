//
//  AnyOptional.swift
//
//
//  Created by Вадим on 05.07.2024.
//



public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}
