import UIKit

class OrderVC: UIViewController {
    
    var selectedOptions: [String] = []
    var totalPrice: Double = 0.0
    
    let mainLabel = UILabel()
    let backButton = UIButton(type: .custom)
    
    var someString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Order"
        
        configureUI()
        updateMainLabel()
    }
    
    func configureUI() {
        view.backgroundColor = .gray
        
        // 레이블 관련 설정
        mainLabel.font = UIFont.systemFont(ofSize: 22)
        mainLabel.numberOfLines = 0 // Allows the label to wrap text
        mainLabel.textAlignment = .center
        
        view.addSubview(mainLabel)
        
        // 레이블 오토레이아웃
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // Back button configuration
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        // Back button auto layout
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func updateMainLabel() {
        let optionsText = selectedOptions.joined(separator: "\n")
        mainLabel.text = "\(optionsText)\n\nTotal Price: $\(totalPrice)"
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
