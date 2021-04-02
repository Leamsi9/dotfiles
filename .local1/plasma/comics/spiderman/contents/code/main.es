/*
 *   Copyright (C) 2009 Atindra Kanti Mandal <atindra1@gmail.com>
 *   Based on Tobias Koenig's Garfield comics engine 
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
    comic.comicAuthor = "Lee Falk";
    comic.firstIdentifier = "2007-11-01";
    comic.websiteUrl = "http://www.sfgate.com/comics/?feature_id=Spiderman&feature_date=" + comic.identifier.toString("yyyy-MM-dd");
    var url = "http://content.comicskingdom.net/Spiderman/Spiderman." + comic.identifier.toString("yyyyMMdd") + "_large" + ".gif";
    comic.requestPage(url, comic.Image);
}
