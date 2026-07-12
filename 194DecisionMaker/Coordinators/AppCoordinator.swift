import SwiftUI
import Combine

enum AppDestination: Hashable {
    case wheel([Option], DecisionMode)
    case coin
    case dice([Option])
    case elimination([Option])
    case bracket([Option])
    case guidedFlow
    case optionList(UUID?)
    case optionForm(Option?, UUID?)
    case collections
    case templates
    case history
    case statistics
    case settings
    case importExport
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    let storageService: StorageServiceProtocol
    let wheelEngine: WheelEngine
    let coinEngine: CoinEngine
    let diceEngine: DiceEngine
    let bracketEngine: BracketEngine
    let filterService: OptionFilterService
    let templateService: TemplateService
    let importExportService: ImportExportService

    init(
        storageService: StorageServiceProtocol = UserDefaultsStorageService(),
        wheelEngine: WheelEngine = WheelEngine(),
        coinEngine: CoinEngine = CoinEngine(),
        diceEngine: DiceEngine = DiceEngine(),
        bracketEngine: BracketEngine = BracketEngine(),
        filterService: OptionFilterService = OptionFilterService(),
        templateService: TemplateService = .shared,
        importExportService: ImportExportService = ImportExportService()
    ) {
        self.storageService = storageService
        self.wheelEngine = wheelEngine
        self.coinEngine = coinEngine
        self.diceEngine = diceEngine
        self.bracketEngine = bracketEngine
        self.filterService = filterService
        self.templateService = templateService
        self.importExportService = importExportService
    }

    func start() -> some View {
        HomeView(viewModel: HomeViewModel(coordinator: self))
    }

    func filteredOptions(collectionId: UUID? = nil) -> [Option] {
        let all: [Option] = storageService.load(forKey: StorageKeys.options)
        let history: [DecisionHistory] = storageService.load(forKey: StorageKeys.history)
        let rules = filterService.loadRules(from: storageService)
        return filterService.eligibleOptions(
            all: all,
            rules: rules,
            history: history,
            collectionId: collectionId
        )
    }

    func navigateToWheel(options: [Option]? = nil, mode: DecisionMode = .wheel) {
        path.append(AppDestination.wheel(options ?? filteredOptions(), mode))
    }

    func navigateToCoin() { path.append(AppDestination.coin) }
    func navigateToDice(options: [Option]? = nil) {
        path.append(AppDestination.dice(options ?? filteredOptions()))
    }
    func navigateToElimination(options: [Option]? = nil) {
        path.append(AppDestination.elimination(options ?? filteredOptions()))
    }
    func navigateToBracket(options: [Option]? = nil) {
        path.append(AppDestination.bracket(options ?? filteredOptions()))
    }
    func navigateToGuidedFlow() { path.append(AppDestination.guidedFlow) }
    func navigateToOptionList(collectionId: UUID? = nil) {
        path.append(AppDestination.optionList(collectionId))
    }
    func navigateToOptionForm(option: Option? = nil, collectionId: UUID? = nil) {
        path.append(AppDestination.optionForm(option, collectionId))
    }
    func navigateToCollections() { path.append(AppDestination.collections) }
    func navigateToTemplates() { path.append(AppDestination.templates) }
    func navigateToHistory() { path.append(AppDestination.history) }
    func navigateToStatistics() { path.append(AppDestination.statistics) }
    func navigateToSettings() { path.append(AppDestination.settings) }
    func navigateToImportExport() { path.append(AppDestination.importExport) }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() { path = NavigationPath() }

    @ViewBuilder
    func destination(for destination: AppDestination) -> some View {
        switch destination {
        case let .wheel(options, mode):
            WheelView(viewModel: WheelViewModel(
                options: options,
                mode: mode,
                storageService: storageService,
                coordinator: self,
                wheelEngine: wheelEngine,
                filterService: filterService
            ))
        case .coin:
            CoinView(viewModel: CoinViewModel(
                storageService: storageService,
                coinEngine: coinEngine,
                coordinator: self
            ))
        case let .dice(options):
            DiceView(viewModel: DiceViewModel(
                options: options,
                storageService: storageService,
                coordinator: self,
                diceEngine: diceEngine
            ))
        case let .elimination(options):
            EliminationView(viewModel: EliminationViewModel(
                options: options,
                storageService: storageService,
                coordinator: self,
                bracketEngine: bracketEngine
            ))
        case let .bracket(options):
            BracketView(viewModel: BracketViewModel(
                options: options,
                storageService: storageService,
                coordinator: self,
                bracketEngine: bracketEngine
            ))
        case .guidedFlow:
            GuidedFlowView(viewModel: GuidedFlowViewModel(
                storageService: storageService,
                coordinator: self,
                filterService: filterService
            ))
        case let .optionList(collectionId):
            OptionListView(viewModel: OptionListViewModel(
                storageService: storageService,
                coordinator: self,
                collectionId: collectionId
            ))
        case let .optionForm(option, collectionId):
            OptionFormView(viewModel: OptionFormViewModel(
                option: option,
                collectionId: collectionId,
                storageService: storageService,
                coordinator: self
            ))
        case .collections:
            CollectionsView(viewModel: CollectionsViewModel(
                storageService: storageService,
                coordinator: self
            ))
        case .templates:
            TemplatesView(viewModel: TemplatesViewModel(
                storageService: storageService,
                coordinator: self,
                templateService: templateService
            ))
        case .history:
            HistoryView(viewModel: HistoryViewModel(
                storageService: storageService,
                coordinator: self
            ))
        case .statistics:
            StatisticsView(viewModel: StatisticsViewModel(
                storageService: storageService,
                coordinator: self
            ))
        case .settings:
            SettingsView(viewModel: SettingsViewModel(
                storageService: storageService,
                coordinator: self
            ))
        case .importExport:
            ImportExportView(viewModel: ImportExportViewModel(
                storageService: storageService,
                coordinator: self,
                importExportService: importExportService
            ))
        }
    }
}
