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

#ifndef RDK2_RPROPERTYUPDATE_RPROPERTYUPDATE
#define RDK2_RPROPERTYUPDATE_RPROPERTYUPDATE

#include <rdkcore/object/object.h>
#include "url.h"

namespace RDK2 { namespace RepositoryNS {


struct RPropertyUpdate: public RDK2::Object {

	Url completeUrl;
	enum Type { VALUE, DIFF, ENQUEUE } type;
	RDK2::Object* object;


	RPropertyUpdate();
	~RPropertyUpdate();
	RPropertyUpdate(Url completeUrl, Type type, RDK2::Object* object) :
		completeUrl(completeUrl), type(type), object(object) { }

	void read(Reader* r) throw (ReadingException);
	void write(Writer* w) const throw (WritingException);
	RDK2::Object* clone() const;
	
};

}} // namespaces

#endif
