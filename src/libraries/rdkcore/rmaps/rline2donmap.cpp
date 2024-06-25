/*
 *    OpenRDK : OpenSource Robot Development Kit
 *    Copyright (C) 2007, 2008  Daniele Calisi, Andrea Censi (<first_name>.<last_name>@dis.uniroma1.it)
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

#include "rline2donmap.h"

namespace RDK2 { namespace RMaps {

	RDK2_FACTORY(RLine2dOnMap);
	
	void RLine2dOnMap::write(Writer* w) const throw (WritingException)
	{
		w->startWriting(getClassName());
			w->write_f64(p0.x);
			w->write_f64(p0.y);
			w->write_f64(p1.x);
			w->write_f64(p1.y);
			w->write_f64(drawWidth);
			w->write_i32(color);
		w->doneWriting();
	}
	
	void RLine2dOnMap::read(Reader* r) throw (ReadingException)
	{
		r->startReading(getClassName());
			p0.x = r->read_f64();
			p0.y = r->read_f64();
			p1.x = r->read_f64();
			p1.y = r->read_f64();
			drawWidth = r->read_f64();
			color = (RgbColor) r->read_i32();
		r->doneReading();
	}

}} // namespace
