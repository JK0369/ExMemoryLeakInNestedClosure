//
//  ViewController.swift
//  ExTestLeak
//
//  Created by 김종권 on 2024/05/26.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let instance = SomeClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        present(VC(instance: instance), animated: true)
    }
}

class VC: UIViewController {
    private let disposeBag = DisposeBag()
    private let button = UIButton()
    weak var instance: SomeClass?
    
    init(instance: SomeClass?) {
        super.init(nibName: nil, bundle: nil)
        self.instance = instance
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray.withAlphaComponent(0.3)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("button", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        button.rx.tap
            .subscribe(with: self) { ss, _ in
                ss.instance?.f1 {
                    print("ss1")
                    ss.instance?.f2 {
                        print("ss2")
                    }
                }
            }
            .disposed(by: disposeBag)
        
//        button.rx.tap
//            .subscribe(with: self) { ss, _ in
//                ss.instance?.f1 { [weak ss] in
//                    print("ss1")
//                    ss?.instance?.f2 {
//                        print("ss2")
//                    }
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    deinit {
        print("deinit!!")
    }
}

class SomeClass {
    var closure1: (() -> ())?
    var closure2: (() -> ())?
    
    func f1(_ closure: @escaping () -> ()) {
        print("f1")
//        closure1 = closure
        closure()
    }
    
    func f2(_ closure: @escaping () -> ()) {
        print("f2")
        closure2 = closure
        closure()
    }
}
