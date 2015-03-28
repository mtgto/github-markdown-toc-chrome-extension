/*
 * Copyright 2015 mtgto <hogerappa@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// <reference path="../typings/tsd.d.ts"/>

chrome.storage.sync.get(function(items) {
    var ignoredUrls: string[] = items['ignore_urls'] || [];
    if (ignoredUrls.indexOf(document.URL) != -1) {
        return;
    }
    var article: JQuery = $('article.markdown-body').first();
    var baseList: JQuery = $('<ul/>');
    var lastLevel = 1;
    var lastList = baseList;
    article
        .children('h1,h2,h3,h4,h5,h6,h7')
        .each(function(index: number, element: Element) {
            var tagName: string = element.tagName;
            var text: string = element.textContent.trim();
            var href: string = $(element).children('a.anchor').first().attr('href');
            if (!href) {
                return;
            }
            var level: number = parseInt(tagName.charAt(1));
            var list: JQuery = lastList;
            if (lastLevel < level) {
                for (var i=lastLevel; i<level; i++) {
                    var newList: JQuery = $('<ul/>');
                    list.append(newList);
                    list = newList;
                }
            } else if (lastLevel > level) {
                for (var i=level; i<lastLevel; i++) {
                    list = list.parent();
                }
            }
            var item: JQuery = $('<li/>');
            var anchor: JQuery = $('<a/>');
            anchor.text(text);
            anchor.attr('href', href);
            item.append(anchor);
            list.append(item);
        });
    var toggleAnchor: JQuery = $('<a href="#">[Click to hide table of contents]</a>');
    var shown: boolean = true;
    toggleAnchor.click(function() {
        shown = !shown;
        toggleAnchor.text(shown ? '[Click to hide table of contents]' : '[Click to show table of contents]');
        baseList.toggle('fast');
    });
    article.prepend(baseList);
    article.prepend(toggleAnchor);
});
