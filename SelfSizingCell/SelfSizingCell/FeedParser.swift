//
// Created by 周佳 on 2019-01-13.
// Copyright (c) 2019 AppCoda. All rights reserved.
//

import Foundation


enum RssTag: String {
    case item = "item"
    case title = "title"
    case description = "description"
    case pubDate = "pubDate"
}

typealias ArticeItem = (title: String, description: String, pubDate: String)

class FeedParser: NSObject, XMLParserDelegate {

    private var rssItems: [ArticeItem] = []

    private var currentElement = ""

    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var parserCompletionHandler: (([(ArticeItem)]) -> Void)?

    func parserFeed(feedUrl: String, completionHander: (([(ArticeItem)]) -> Void)?) -> Void {
        self.parserCompletionHandler = completionHander

        let request = URLRequest(url: URL(string: feedUrl)!)

        let urlSession = URLSession.shared

        let task = urlSession.dataTask(with: request) {
            data, response, error in

            guard let data = data else {
                if let error = error {
                    print(error)
                }
                return
            }

            //解析XML
            let praser = XMLParser(data: data)
            praser.delegate = self
            praser.parse()

        }

        task.resume()


    }

    func parserDidStartDocument(_ parser: XMLParser) {
        rssItems = [] //开始时设置rssItems = []
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {

        currentElement = elementName
        //当当前节点为item时，重置 临时存储变量的值为 ""
        if currentElement == RssTag.item.rawValue {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //查找对应子节点的值后，分别赋值到临时存储变量
        switch currentElement {
        case RssTag.title.rawValue :
            currentTitle += string
        case RssTag.description.rawValue :
            currentDescription += string
        case RssTag.pubDate.rawValue :
            currentPubDate += string
        default : break

        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == RssTag.item.rawValue {
            //单个item节点解析完成后，通过临时的存储变量创建 ArticeItem 元组（）
            let rssItem = (title: currentTitle, description: currentDescription, pubDate: currentPubDate)
            //将元祖加入到数组
            rssItems.append(rssItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        //解析完全成功后调用 与DidStartDocument方法对应
        parserCompletionHandler?(rssItems)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
}