//
//  CustomNavigationStack.swift
//  WBSenior
//
//  Created by Вадим on 15.07.2024.
//

import SwiftUI

struct ExperimentView: View {
    @State 
    var isPushed: Bool = false
    @State 
    var isPresenting: Bool = false
    @State 
    var isShowingCustomAnimation: Bool = false
    @EnvironmentObject 
    var viewModel: CustomNavigationStackViewModel
    
    var body: some View {
        CustomNavigationStack {
            TestView()
        }
        .push(
            viewModel: viewModel,
            view: TestView(),
            isActive: isPushed
        )
        .present(
            viewModel: viewModel,
            view: TestView(),
            isActive: isPresenting
        )
        .custom(
            viewModel: viewModel,
            view: TestView(),
            isActive: isShowingCustomAnimation
        )
    }
}

struct TestView: View {
    @State 
    var isPushed: Bool = false
    @State 
    var isPresenting: Bool = false
    @State 
    var isShowingCustomAnimation: Bool = false
    @EnvironmentObject 
    var viewModel: CustomNavigationStackViewModel
    
    let backgroundColor: Color = Color.randomColor
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            VStack {
                Button(action: { isPushed.toggle() }) {
                    Text("Push")
                        .buttonStyle()
                }
                
                Button(action: { isPresenting.toggle() }) {
                    Text("Present")
                        .buttonStyle()
                }
                
                Button(action: { isShowingCustomAnimation.toggle() }) {
                    Text("Custom")
                        .buttonStyle()
                }
                
                if !viewModel.views.isEmpty {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Return to root view")
                    }
                    .foregroundStyle(.white)
                    .font(.callout)
                    .onTapGesture {
                        withAnimation {
                            viewModel.goToRootView()
                        }
                    }
                }
            }
            .padding()
        }
        .push(
            viewModel: viewModel,
            view: TestView(),
            isActive: isPushed
        )
        .present(
            viewModel: viewModel,
            view: TestView(),
            isActive: isPresenting
        )
        .custom(
            viewModel: viewModel,
            view: TestView(),
            isActive: isShowingCustomAnimation
        )
    }
}

struct Screen {
    let view: AnyView
    let typeTransition: AnyTransition
}

final class CustomNavigationStackViewModel: ObservableObject {
    @Published 
    var views: [Screen] = []
    
    func push(_ view: any View) {
        let screen = Screen(view: AnyView(view), typeTransition: .slide)
        appendView(screen)
    }
    
    func present(_ view: any View) {
        let screen = Screen(view: AnyView(view), typeTransition: .move(edge: .bottom))
        appendView(screen)
    }
    
    func custom(_ view: any View) {
        let screen = Screen(view: AnyView(view), typeTransition: .scale)
        appendView(screen)
    }
    
    func pop() {
        views.removeLast()
    }
    
    func goToRootView() {
        views.removeAll()
    }
    
    private func appendView(_ screen: Screen) {
        views.append(screen)
    }
}

struct CustomNavigationStack<Content: View>: View {
    let content: () -> Content
    @EnvironmentObject var viewModel: CustomNavigationStackViewModel
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            content()
            
            ForEach(Array(viewModel.views.enumerated()), id: \.offset) { _, screen in
                ZStack(alignment: .top) {
                    screen.view
                    HStack {
                        backButton
                        Spacer()
                    }
                }
                .transition(screen.typeTransition)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var backButton: some View {
        Button(action: {
            withAnimation {
                viewModel.pop()
            }
        }) {
            Image(systemName: "arrowshape.left")
                .foregroundStyle(.white)
                .font(.title2)
                .padding()
        }
    }
}

#Preview {
    TestView().environmentObject(CustomNavigationStackViewModel())
}

extension View {
    func push(viewModel: CustomNavigationStackViewModel, view: any View, isActive: Bool) -> some View {
        self.modifier(TransitionViewModifier(viewModel: viewModel, view: view, isActive: isActive, transitionType: .push))
    }
    
    func present(viewModel: CustomNavigationStackViewModel, view: any View, isActive: Bool) -> some View {
        self.modifier(TransitionViewModifier(viewModel: viewModel, view: view, isActive: isActive, transitionType: .present))
    }
    
    func custom(viewModel: CustomNavigationStackViewModel, view: any View, isActive: Bool) -> some View {
        self.modifier(TransitionViewModifier(viewModel: viewModel, view: view, isActive: isActive, transitionType: .custom))
    }
}

struct TransitionViewModifier: ViewModifier {
    let viewModel: CustomNavigationStackViewModel
    let view: any View
    var isActive: Bool
    var transitionType: TransitionType
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isActive) { _ in
                withAnimation {
                    switch transitionType {
                    case .push:
                        viewModel.push(view)
                    case .present:
                        viewModel.present(view)
                    case .custom:
                        viewModel.custom(view)
                    }
                }
            }
    }
    
    enum TransitionType {
        case push, present, custom
    }
}

extension Color {
    static var randomColor: Color {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

extension Text {
    func buttonStyle() -> some View {
        self.font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
    }
}
