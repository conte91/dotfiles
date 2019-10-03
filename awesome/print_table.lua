--~ print a table
function printtable(toPrint, indent)

  indent = indent or 0;

  local keys = {};
  local result = '';

  for k in pairs(toPrint) do
    keys[#keys+1] = k;
    --table.sort(keys, function(a, b)
    --  local ta, tb = type(a), type(b);
    --  if (ta ~= tb) then
    --    return ta < tb;
    --  else
    --    return a < b;
    --  end
    --end);
  end

  result = result .. string.rep('  ', indent)..'{';
  indent = indent + 1;
  for k, v in pairs(toPrint) do
    result = result .. tostring(k) .. " -> " .. tostring(v) .. "\n"

  --  local key = k;
  --  if (type(key) == 'string') then
  --    if not (string.match(key, '^[A-Za-z_][0-9A-Za-z_]*$')) then
  --      key = "['"..key.."']";
  --    end
  --  elseif (type(key) == 'number') then
  --    key = "["..key.."]";
  --  end

  --  if (type(v) == 'table') then
  --    if (next(v)) then
  --      result = result .. string.rep('  ', indent) .. tostring(key) .. " = ";
  --      result = result .. printtable(v, indent);
  --    else
  --      result = result .. string.rep('  ', indent) .. tostring(key) .. " = {},"
  --    end 
  --  elseif (type(v) == 'string') then
  --    result = result .. string.rep('  ', indent) .. tostring(key) .. " = '" .. v .. "',";
  --  else
  --    result = result .. string.rep('  ', indent) .. tostring(key) .. " = '" .. tostring(v) .. "'";
  --  end
  end
  indent = indent - 1;
  result = result .. string.rep('  ', indent) .. '}';
  return result;
end
