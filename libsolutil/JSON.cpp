/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0
/** @file JSON.cpp
 * @author Alexander Arlt <alexander.arlt@arlt-labs.com>
 * @date 2018
 */

#include <libsolutil/JSON.h>

#include <libsolutil/CommonIO.h>

#include <boost/algorithm/string/replace.hpp>

#include <map>
#include <memory>
#include <sstream>

static_assert(
	(NLOHMANN_JSON_VERSION_MAJOR == 3) && (NLOHMANN_JSON_VERSION_MINOR == 11) && (NLOHMANN_JSON_VERSION_PATCH == 3),
	"Unexpected nlohmann-json version. Expecting 3.11.3.");

namespace solidity::util
{

namespace
{

/// Takes a JSON value (@ _json) and removes all its members with value 'null' recursively.
void removeNullMembersHelper(Json& _json)
{
	if (_json.is_array())
	{
		for (auto& child: _json)
			removeNullMembersHelper(child);
	}
	else if (_json.is_object())
	{
		for (auto it = _json.begin(); it != _json.end();)
		{
			if (it->is_null())
				it = _json.erase(it);
			else
			{
				removeNullMembersHelper(*it);
				++it;
			}
		}
	}
}

} // end anonymous namespace

Json removeNullMembers(Json _json)
{
	removeNullMembersHelper(_json);
	return _json;
}

std::string jsonPrettyPrint(Json const& _input) { return jsonPrint(_input, JsonFormat{JsonFormat::Pretty}); }

std::string jsonCompactPrint(Json const& _input) { return jsonPrint(_input, JsonFormat{JsonFormat::Compact}); }

std::string jsonPrint(Json const& _input, JsonFormat const& _format)
{
	// NOTE: -1 here means no new lines (it is also the default setting)
	return _input.dump(
		/* indent */ (_format.format == JsonFormat::Pretty) ? static_cast<int>(_format.indent) : -1,
		/* indent_char */ ' ',
		/* ensure_ascii */ true);
}

bool jsonParseStrict(std::string const& _input, Json& _json, std::string* _errs /* = nullptr */)
{
	try
	{
		_json = Json::parse(_input);
		_errs = {};
		return true;
	}
	catch (Json::parse_error const& e)
	{
		// NOTE: e.id() gives the code and e.byte() gives the byte offset
		if (_errs)
		{
			*_errs = e.what();
		}
		return false;
	}
}

std::optional<Json> jsonValueByPath(Json const& _node, std::string_view _jsonPath)
{
	if (!_node.is_object() || _jsonPath.empty())
		return {};

	std::string memberName = std::string(_jsonPath.substr(0, _jsonPath.find_first_of('.')));
	if (!_node.contains(memberName))
		return {};

	if (memberName == _jsonPath)
		return _node[memberName];

	return jsonValueByPath(_node[memberName], _jsonPath.substr(memberName.size() + 1));
}

} // namespace solidity::util
