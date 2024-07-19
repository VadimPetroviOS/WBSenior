//
//  RulesForAnyType.swift
//  WBSenior
//
//  Created by Вадим on 18.07.2024.
//

import SwiftUI

struct RulesForAnyTypeView: View {
    var body: some View {
        Text("StartEvent")
            .onAppear {
                startEvent()
            }
    }
    
    private func startEvent() {
        // Обобщенная структура
        struct Stack<Element> {
            private var stack: [Element] = []

            mutating func push(_ element: Element) {
                stack.append(element)
            }
            
            
            mutating func pop() -> Element? {
                stack.popLast()
            }
        }

        // Обобщенный класс
        class Queue<Element> {
            private var queue: [Element] = []
            
            func enqueue(_ element: Element) {
                queue.append(element)
            }
            
            func dequeue() -> Element? {
                queue.isEmpty ? nil : queue.removeFirst()
            }
        }

        // Создание протокола
        protocol Container {
            associatedtype Item
            mutating func append(_ item: Item)
            mutating func remove() -> Item?
        }

        // Реализация протокола
        struct СontainerStack<Element>: Container {
            typealias Item = Element
            
            private var stack: [Item] = []
            
            mutating func append(_ item: Item) {
                stack.append(item)
            }
            
            mutating func remove() -> Item? {
                stack.popLast()
            }
        }


        class СontainerQueue<Element>: Container {
            typealias Item = Element
            
            private var queue: [Item] = []
            
            func append(_ item: Item) {
                queue.append(item)
            }
            
            func remove() -> Item? {
                queue.isEmpty ? nil : queue.removeFirst()
            }
        }

        // Непрозрачные типы
        func makeOpaqueContainer<T: Container>(container: T) -> some Container {
            return container
        }

        // Стирание типов
        class AnyContainer<T>: Container {
            typealias Item = T
            
            private let _append: (T) -> Void
            private let _remove: () -> T?
            
            init<C: Container>(_ container: C) where C.Item == T {
                var mutableContainer = container
                _append = { item in mutableContainer.append(item) }
                _remove = { return mutableContainer.remove() }
            }
            
            func append(_ item: T) {
                _append(item)
            }
            
            func remove() -> T? {
                return _remove()
            }
        }
        
        // Примеры использования
        var intStack = Stack<Int>()
        intStack.push(1)
        intStack.push(2)
        intStack.push(3)

        print(intStack.pop() ?? 0)

        let stringQueue = Queue<String>()
        stringQueue.enqueue("a")
        stringQueue.enqueue("b")
        stringQueue.enqueue("c")

        print(stringQueue.dequeue() ?? "")

        let e: Double = exp(1)
        var doubleStack = СontainerStack<Double>()
        doubleStack.append(e)

        let opaqueContainer = makeOpaqueContainer(container: doubleStack)
        let anyContainer = AnyContainer(doubleStack)

        anyContainer.append(e * 2)
        
        print(anyContainer.remove() ?? 0)
    }
}



