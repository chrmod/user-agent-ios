/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

@testable import Client
import Foundation
import Shared
import Storage
import XCTest

open class MockTabQueue: TabQueue {
    open func addToQueue(_ tab: ShareItem) -> Success {
        return succeed()
    }

    open func getQueuedTabs() -> Deferred<Maybe<Cursor<ShareItem>>> {
        return deferMaybe(ArrayCursor<ShareItem>(data: []))
    }

    open func clearQueuedTabs() -> Success {
        return succeed()
    }
}

open class MockPanelDataObservers: PanelDataObservers {
    override init(profile: Client.Profile) {
        super.init(profile: profile)
        self.activityStream = MockActivityStreamDataObserver(profile: profile)
    }
}

open class MockActivityStreamDataObserver: DataObserver {
    public func refreshIfNeeded(forceTopSites topSites: Bool) {
    }

    public var profile: Client.Profile
    public weak var delegate: DataObserverDelegate?

    init(profile: Client.Profile) {
        self.profile = profile
    }
}

class MockFiles: FileAccessor {
    init() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        super.init(rootPath: (docPath as NSString).appendingPathComponent("testing"))
    }
}

open class MockProfile: Client.Profile {
    public func hasAccount() -> Bool {
        return false
    }

    public func getAccount() -> Any? {
        return nil
    }

    // Read/Writeable properties for mocking
    public var recommendations: HistoryRecommendations
    public var places: RustPlaces
    public var files: FileAccessor
    public var history: BrowserHistory & SyncableHistory & ResettableSyncStorage

    fileprivate var legacyPlaces: BrowserHistory & Favicons & SyncableHistory & ResettableSyncStorage & HistoryRecommendations

    public lazy var panelDataObservers: PanelDataObservers = {
        return MockPanelDataObservers(profile: self)
    }()

    var db: BrowserDB
    var readingListDB: BrowserDB

    fileprivate let name: String = "mockaccount"

    init(databasePrefix: String = "mock") {
        files = MockFiles()
        db = BrowserDB(filename: "\(databasePrefix).db", schema: BrowserSchema(), files: files)
        readingListDB = BrowserDB(filename: "\(databasePrefix)_ReadingList.db", schema: ReadingListSchema(), files: files)
        let placesDatabasePath = URL(fileURLWithPath: (try! files.getAndEnsureDirectory()), isDirectory: true).appendingPathComponent("\(databasePrefix)_places.db").path
        places = RustPlaces(databasePath: placesDatabasePath)
        legacyPlaces = SQLiteHistory(db: self.db, prefs: MockProfilePrefs())
        recommendations = legacyPlaces
        history = legacyPlaces
    }

    public func localName() -> String {
        return name
    }

    public func _reopen() {
        isShutdown = false

        db.reopenIfClosed()
        _ = places.reopenIfClosed()
    }

    public func _shutdown() {
        isShutdown = true

        db.forceClose()
        _ = places.forceClose()
    }

    public var isShutdown: Bool = false

    public var favicons: Favicons {
        return self.legacyPlaces
    }

    lazy public var queue: TabQueue = {
        return MockTabQueue()
    }()

    lazy public var metadata: Metadata = {
        return SQLiteMetadata(db: self.db)
    }()

    lazy public var isChinaEdition: Bool = {
        return Locale.current.identifier == "zh_CN"
    }()

    lazy public var certStore: CertStore = {
        return CertStore()
    }()

    lazy public var searchEngines: SearchEngines = {
        return SearchEngines(prefs: self.prefs, files: self.files)
    }()

    lazy public var prefs: Prefs = {
        return MockProfilePrefs()
    }()

    lazy public var readingList: ReadingList = {
        return SQLiteReadingList(db: self.readingListDB)
    }()

    lazy public var recentlyClosedTabs: ClosedTabsStore = {
        return ClosedTabsStore(prefs: self.prefs)
    }()

    internal lazy var remoteClientsAndTabs: RemoteClientsAndTabs = {
        return SQLiteRemoteClientsAndTabs(db: self.db)
    }()

    fileprivate lazy var syncCommands: SyncCommands = {
        return SQLiteRemoteClientsAndTabs(db: self.db)
    }()

    public func getClients() -> Deferred<Maybe<[RemoteClient]>> {
        return deferMaybe([])
    }

    public func getCachedClients() -> Deferred<Maybe<[RemoteClient]>> {
        return deferMaybe([])
    }

    public func getClientsAndTabs() -> Deferred<Maybe<[ClientAndTabs]>> {
        return deferMaybe([])
    }

    public func getCachedClientsAndTabs() -> Deferred<Maybe<[ClientAndTabs]>> {
        return deferMaybe([])
    }

    public func cleanupHistoryIfNeeded() {}

    public func storeTabs(_ tabs: [RemoteTab]) -> Deferred<Maybe<Int>> {
        return deferMaybe(0)
    }

    public func sendItem(_ item: ShareItem, toDevices devices: [RemoteDevice]) -> Success {
        return succeed()
    }
}
