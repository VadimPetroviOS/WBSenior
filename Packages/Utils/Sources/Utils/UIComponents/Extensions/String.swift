//
//  String.swift
//  WBSenior
//
//  Created by Вадим on 04.07.2024.
//

import Foundation

public extension String {
     func formatUserInput(pattern: String) -> String {
        var inputCollection = Array(self)
        var resultCollection: Array<Character> = []
        
        for i in 0 ..< pattern.count {
            let patternCharIndex = String.Index(utf16Offset: i, in: pattern)
            let patternChar = pattern[patternCharIndex]
            
            guard let nextInputChar = inputCollection.first else { break }

            if (patternChar == nextInputChar || patternChar == "_") {
                resultCollection.append(nextInputChar)
                inputCollection.removeFirst()
            } else {
                resultCollection.append(patternChar)
            }
        }
        
        return String(resultCollection)
    }
}
