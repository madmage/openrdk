/*
 *    OpenRDK : OpenSource Robot Development Kit
 *    Copyright (C) 2007, 2008  Daniele Calisi (daniele.calisi@dis.uniroma1.it)
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#ifndef RDK2_RQ_RQTABWIDGET
#define RDK2_RQ_RQTABWIDGET

#include <qtabwidget.h>

#include "rguiobjects.h"

namespace RDK2 { namespace RConsoleQt {

class RqTabWidget : public QTabWidget {
Q_OBJECT
public:
	RqTabWidget(QWidget * parent = 0, const char * name = 0, WFlags f = 0, RGuiWindow* w = 0) :
		QTabWidget(parent, name, f), qindow(w)
	{
		setAcceptDrops(true);
	}
	
	void dragEnterEvent(QDragEnterEvent* event);
	void dropEvent(QDropEvent* event);
	
	RGuiWindow* qindow;	// FIXME please delete if all works and compile
};

}}

#endif
