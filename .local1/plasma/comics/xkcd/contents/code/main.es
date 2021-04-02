/*
 *   Copyright (C) 2007 Tobias Koenig <tokoe@kde.org>
 *   Copyright (C) 2009 - 2017 Matthias Fuchs <mat69@gmx.net>
 *   Copyright (C) 2019 Hans-Peter Jansen <hpj@urpla.net>
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

function init()
{
    comic.comicAuthor = "Randall Munroe";
    comic.websiteUrl = "https://xkcd.com/";
    comic.shopUrl = "https://store.xkcd.com/";
    comic.firstIdentifier = 1;

    comic.requestPage(comic.websiteUrl, comic.User);
}

function pageRetrieved(id, data)
{
    // find the most recent strip
    if (id == comic.User) {
        var re = new RegExp("Permanent link to this comic: https://xkcd.com/(\\d+)/");
        var match = re.exec(data);
        if ( match != null ) {
            comic.lastIdentifier = match[1];
            comic.websiteUrl += comic.identifier + "/";
            comic.requestPage(comic.websiteUrl, comic.Page);
        } else {
	    print("Failed to fetch most recent strip from " + comic.websiteUrl);
            comic.error();
        }
    }

    else if (id == comic.Page) {
        // get previous id
        var re = new RegExp('rel="prev" href="/(\\d+)/"');
        var match = re.exec(data);
        if (match != null) {
            comic.previousIdentifier = match[1];
        } else {
            print("No previous strip.");
        }

        // get next id
        var re = new RegExp('rel="next" href="/(\\d+)/"');
        var match = re.exec(data);
        if (match != null) {
            comic.nextIdentifier = match[1];
        } else {
            print("No next strip.");
        }

        //find tooltip of the strip
        var re = new RegExp('<img src="//imgs\.xkcd\.com/comics/[^"]+" title="([^"]+)');
        var match = re.exec(data);
        if (match != null) {
            var additionalText = match[1];
            comic.additionalText = additionalText.replace(/&quot;/g, '"').replace(/&#39;/g, "'");
	} else {
	    print("Unable to locate additional text.");
	}
    
        //find title of the strip
        var re = new RegExp('<div id="ctitle">([^<]+)</div>');
        var match = re.exec(data);
        if (match != null) {
            comic.title = match[1];
	} else {
	    print("Unable to locate a title.");
        }

	// fetch image
        var re = new RegExp("Image URL \\(for hotlinking/embedding\\): (https://imgs\.xkcd\.com/comics/.+)");
        var match = re.exec(data);
        if (match != null) {
            comic.requestPage(match[1], comic.Image);
        } else {
	    print("Failed to locate Image URL.");
            comic.error();
        }
    }
}
