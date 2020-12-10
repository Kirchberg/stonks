import UIKit
import PinLayout

final class MeHistoryViewControllerPin: UIViewController {
    var output: MeHistoryOutput?

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.4431372549, green: 0.3960784314, blue: 0.8901960784, alpha: 1)
        label.text = "History"
        label.font = UIFont(name: "DMSans-Bold", size: 25)
        return label
    }()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "previous"), for: .normal)
        button.addTarget(self, action: #selector(didBackActionTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.addTarget(self, action: #selector(didFilterButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = .default
        searchBar.placeholder = "Search..."
        return searchBar
    }()

    private let tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupMainView()
        output?.didLoadView()
    }

    private func setupMainView() {
        self.view.backgroundColor = .white
        self.view.addSubview(headerLabel)
        self.view.addSubview(backButton)
        self.view.addSubview(filterButton)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupHeaderLabel()
        setupBackButton()
        setupFilterButton()
        setupSearchBar()
        setupTableViewConstaints()
    }

    private func setupHeaderLabel() {
        headerLabel.pin
            .hCenter()
            .top(view.pin.safeArea.top)
            .height(40)
            .sizeToFit(.height)
    }

    private func setupBackButton() {
        backButton.pin
            .top(view.pin.safeArea.top + 2)
            .left(view.pin.safeArea.left)
            .height(29)
            .width(29)
    }

    private func setupFilterButton() {
        filterButton.pin
            .below(of: headerLabel)
            .margin(12)
            .right(view.pin.safeArea.right)
            .height(32)
            .width(32)
    }

    private func setupSearchBar() {
        searchBar.pin
            .below(of: headerLabel)
            .marginTop(10)
            .before(of: filterButton)
            .marginRight(8)
            .left(view.pin.safeArea.left)
            .height(36)
    }

    private func setupTableViewConstaints() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pin
            .below(of: searchBar)
            .marginTop(8)
            .left()
            .right()
            .bottom()
    }

    private func setupTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorInsetReference = .fromAutomaticInsets
        tableView.register(MeHistoryTableViewCellPin.self, forCellReuseIdentifier: MeHistoryTableViewCellPin.identifier)
    }

    @objc private func didBackActionTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func didFilterButtonTapped(_ sender: Any) {
        output?.didFilterButtonTapped()
    }
}

extension MeHistoryViewControllerPin: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.getNumberOfStocks() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MeHistoryTableViewCellPin.identifier, for: indexPath) as? MeHistoryTableViewCellPin else {
            return UITableViewCell()
        }
//        let cell = MeHistoryTableViewCellPin()
        guard let stock = output?.stock(at: indexPath) else {
            return UITableViewCell()
        }

        cell.setData(stock: stock)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}

extension MeHistoryViewControllerPin: MeHistoryInput {
    func reloadTable() {
        tableView.reloadData()
    }
}

extension MeHistoryViewControllerPin: MeHistoryFilterDelegate {
    func didSortedStocksLoaded(stocks: [StockHistoryData]) {
        output?.didSortedStocksLoaded(stocks: stocks)
    }
}

extension MeHistoryViewControllerPin: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output?.didUserStartToSearch(search: searchText)
    }
}

extension MeHistoryViewControllerPin {
    private struct Constants {
        static let rowHeight: CGFloat = 62
        static let cellIdentifier: String = "cellId"
    }
}