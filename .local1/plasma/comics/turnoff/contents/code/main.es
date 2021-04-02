/*
 *   Copyright (C) 2007 Tobias Koenig <tokoe@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License version 2 as
 *   published by the Free Software Foundation
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

function init() {
    comic.comicAuthor = "Daniel Stori";
    comic.websiteUrl = "http://turnoff.us";
    comic.shopUrl = "http://turnoff.us/";
    var url = comic.websiteUrl + comic.identifier
    comic.requestPage(url, comic.Page);
}


function pageRetrieved(id, data) {
  var url;

  if (id == comic.Page) {
     rd = new RegExp("<h1 class=\"post-title\"\>(.*)</h1>");
     rdmatch = rd.exec(data);
     if (rdmatch != null) {
        comic.title = rdmatch[1];
     } else {
        comic.title = "no match :-(";
     }
     comic.additionalText = comic.title;

     comic.previousIdentifier = null;
     rd = new RegExp("<a href=\"(.+)\">previous</a>");
     rdmatch = rd.exec(data);
     if (rdmatch != null) {
        comic.previousIdentifier = rdmatch[1];
     }

     comic.nextIdentifier = null;
     rd = new RegExp("<a href=\"(.+)\">next</a>");
     rdmatch = rd.exec(data);
     if (rdmatch != null) {
        comic.nextIdentifier = rdmatch[1];
     }

     rd = new RegExp("<img src=\"(.*)\" alt=\".*geek comic\" (/?)>");
     rdmatch = rd.exec(data);
     if (rdmatch != null) {
         url = rdmatch[1]
         print("*** img url->" + url);
         comic.requestPage(comic.websiteUrl + url, comic.Image);
      } else {
         print("*** no match :-(");
         comic.additionalText = "no img url :-<";
         comic.error();
         return;
      }
  }
  return;
}
