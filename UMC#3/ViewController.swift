import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    var totalprice: Double = 0.0
    
    enum Section {
        case main
    }
    
    let options = ["M (20$)", "L (25$)", "a (3$)", "b (4$)", "c (5$)"]
    let optionPrices = [20.0, 25.0, 3.0, 4.0, 5.0]
    var selectedIndices = Set<Int>()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    var optionsCollectionView: UICollectionView!
    
    let foodImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pizza"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("주문하기", for: .normal)
        button.addTarget(self, action: #selector(orderTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        setupViews()
        configureCollectionView()
        configureDataSource()
        applySnapshot(animatingDifferences: false)
    }
    
    func setupViews() {
        view.addSubview(foodImageView)
        
        // Set up Food ImageView
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            foodImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            foodImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            foodImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            foodImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Set up Order Button
        view.addSubview(orderButton)
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            orderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orderButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
            orderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func orderTapped() {
        let orderVC = OrderVC()
        orderVC.selectedOptions = selectedIndices.map { options[$0] }
        orderVC.totalPrice = totalprice
        navigationController?.pushViewController(orderVC, animated: true)
    }
    
    func configureCollectionView() {
        optionsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        optionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        optionsCollectionView.delegate = self
        optionsCollectionView.register(OptionCell.self, forCellWithReuseIdentifier: "optionCell")
        view.addSubview(optionsCollectionView)
        
        NSLayoutConstraint.activate([
            optionsCollectionView.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: 20),
            optionsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            optionsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            optionsCollectionView.bottomAnchor.constraint(equalTo: orderButton.topAnchor, constant: -20)
        ])
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: optionsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionCell", for: indexPath) as! OptionCell
            cell.optionButton.setTitle(self.options[identifier], for: .normal)
            cell.optionButton.tag = indexPath.item
            cell.optionButton.addTarget(self, action: #selector(self.optionSelected(sender:)), for: .touchUpInside)
            cell.optionButton.backgroundColor = self.selectedIndices.contains(identifier) ? .lightGray : .clear
            return cell
        }
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<options.count))
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    @objc func optionSelected(sender: UIButton) {
        let index = sender.tag
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
            totalprice -= optionPrices[index]
        } else {
            selectedIndices.insert(index)
            totalprice += optionPrices[index]
        }
        
        applySnapshot()
    }
}

class OptionCell: UICollectionViewCell {
    
    lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = self.bounds
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(optionButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
