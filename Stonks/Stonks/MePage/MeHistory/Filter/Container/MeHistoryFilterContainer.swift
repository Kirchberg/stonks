import UIKit

final class MeHistoryFilterContainer {
    let viewController: MeHistoryFilterViewControllerPin

    class func assemble(with context: MeHistoryFilterContext) -> MeHistoryFilterContainer {
//        let storyboard = UIStoryboard(name: Storyboard.mePage.name, bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: Storyboard.meFilterPage.name) as? MeHistoryFilterViewController else {
//            fatalError("MeHistoryFilterContainer: viewController must be type MeHistoryFilterViewController")
//        }
        let vc = MeHistoryFilterViewControllerPin()
        let interactor = MeHistoryFilterInteractor()
        let presenter = MeHistoryFilterPresenter(interactor: interactor)

        interactor.output = presenter
        vc.output = presenter
        presenter.view = vc
        return MeHistoryFilterContainer(view: vc)
    }

    private init(view: MeHistoryFilterViewControllerPin) {
        self.viewController = view
    }
}

struct MeHistoryFilterContext {

}
