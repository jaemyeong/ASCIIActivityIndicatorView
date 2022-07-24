import UIKit

import Pretendard

import OpenColorKit

import ErrorKit

public final class ASCIIActivityIndicatorView: UIView {
    private let textLabel: UILabel
    
    private let values: [String]
    
    private var animating: Task<Void, Never>? {
        willSet {
            self.animating?.cancel()
        }
        didSet {
            self.setVisibility()
        }
    }
    
    /// 애니메이션이 정지되었을 때 뷰를 숨기거나 보여줍니다.
    public var hidesWhenStopped: Bool {
        didSet {
            self.setVisibility()
        }
    }
    
    // 현재 애니메이션 상태.
    public var isAnimating: Bool {
        self.animating != nil
    }
    
    public init(values: String...) {
        self.textLabel = UILabel()
        self.values = values.isEmpty ? ["⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏", "⠋", "⠙"] : values
        self.hidesWhenStopped = true
        
        let font: UIFont
        do {
            font = try .pretendardFont(ofSize: 60.0, weight: .regular) ?? .systemFont(ofSize: 60.0, weight: .regular)
        } catch {
            fatalError(String(describing: error))
        }
        
        super.init(
            frame: CGRect(
                origin: .zero,
                size: values.first?.size(
                    withAttributes: [
                        .font: font,
                    ]
                ) ?? .zero
            )
        )
        
        self.configureView()
        self.configureTextLabel()
        self.configureViewHierarchy()
        self.configureLayoutConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError(String(describing: InstantiateError()))
    }
    
    deinit {
        self.animating = nil
    }
}

extension ASCIIActivityIndicatorView {
    /// ActivityIndicatorView 애니메이션을 시작합니다.
    public func startAnimating() {
        self.animating = Task {
            let stream = AsyncStream<Int> { continuation in
                let handle = Task.detached {
                    var offset = 0
                    
                    while true {
                        try Task.checkCancellation()
                        
                        try await Task.sleep(nanoseconds: 1_000_000_000 / 8)
                        
                        if offset < self.values.count - 1 {
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
                    handle.cancel()
                }
            }
            
            for await value in stream {
                self.textLabel.text = self.values[value]
            }
        }
    }
    
    /// ActivityIndicatorView 애니메이션을 정지합니다.
    public func stopAnimating() {
        self.animating = nil
    }
}

extension ASCIIActivityIndicatorView {
    private func setVisibility() {
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
