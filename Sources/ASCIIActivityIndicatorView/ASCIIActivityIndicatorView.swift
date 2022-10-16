import Pretendard
import OpenColorKit
import ErrorKit

#if canImport(UIKit)

import UIKit

public final class ASCIIActivityIndicatorView: UIView {
    
    private let textLabel: UILabel
    
    private let values: [String]
    
    private var animationTask: Task<Void, Never>? {
        willSet {
            guard let animationTask = self.animationTask else {
                return
            }
            animationTask.cancel()
        }
        didSet {
            self.updateVisibility()
        }
    }
    
    public var hidesWhenStopped: Bool {
        didSet {
            self.updateVisibility()
        }
    }
    
    public var isAnimating: Bool {
        self.animationTask != nil
    }
    
    public init(values: String...) {
        self.textLabel = UILabel()
        self.values = values.isEmpty ? ["⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏", "⠋", "⠙"] : values
        self.hidesWhenStopped = true
        
        super.init(frame: .zero)
        
        self.configureView()
        self.configureTextLabel()
        self.configureViewHierarchy()
        self.configureLayoutConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError(String(describing: InstantiateError()))
    }
    
    public func startAnimating() {
        let numberOfValues = self.values.count
        
        let indexStream = AsyncStream<Int> { continuation in
            let generator = Task {
                var offset = 0
                
                while true {
                    try Task.checkCancellation()
                    
                    try await Task.sleep(nanoseconds: 125_000_000)
                    
                    if offset < numberOfValues - 1 {
                        offset += 1
                    } else {
                        offset = 0
                    }
                    
                    continuation.yield(offset)
                }
            }
            
            continuation.onTermination = { termination in
                guard case .cancelled = termination else {
                    return
                }
                generator.cancel()
            }
        }
        
        self.animationTask = Task { [weak self] in
            for await index in indexStream {
                guard let self = self else {
                    return
                }
                self.textLabel.text = self.values[index]
            }
        }
    }
    
    public func stopAnimating() {
        self.animationTask = nil
    }
}

extension ASCIIActivityIndicatorView {
    
    private func updateVisibility() {
        self.isHidden = self.hidesWhenStopped ? !self.isAnimating : false
    }
}

extension ASCIIActivityIndicatorView {
    
    private func configureView() {
        self.backgroundColor = .openColor.gray.gray0.color
    }
    
    private func configureTextLabel() {
        let font: UIFont
        
        do {
            font = try .pretendardFont(ofSize: 60.0, weight: .regular) ?? .systemFont(ofSize: 60.0, weight: .regular)
        } catch {
            fatalError(String(describing: error))
        }
        
        let textLabel = self.textLabel
        textLabel.font = font
        textLabel.textColor = .openColor.gray.gray8.color
        textLabel.text = self.values.first
    }
    
    private func configureViewHierarchy() {
        self.addSubview(self.textLabel)
    }
    
    private func configureLayoutConstraints() {
        let textLabel = self.textLabel
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor),
        ])
    }
}

#endif
